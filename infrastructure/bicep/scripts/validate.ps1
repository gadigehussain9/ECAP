<#
.SYNOPSIS
    Builds, lints, and validates an ECAP Bicep deployment without deploying it.
.DESCRIPTION
    Runs Bicep build and lint, validates the parameter document, checks the Azure
    subscription context, and runs subscription validation plus What-If validation.
    Every result is emitted as a JSON status record and failures return exit code 1.
.EXAMPLE
    ./validate.ps1 -Environment qa
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dev', 'qa', 'stage', 'prod')]
    [string] $Environment,
    [string] $SubscriptionId,
    [string] $ParameterFile,
    [string] $TemplateFile = (Join-Path $PSScriptRoot '..\main.bicep')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Status {
    param([string] $Event, [string] $Status, [hashtable] $Data = @{})
    Write-Output (([ordered]@{ timestamp = (Get-Date).ToUniversalTime().ToString('o'); event = $Event; status = $Status; data = $Data } | ConvertTo-Json -Depth 20 -Compress))
}

function Invoke-AzJson {
    param([string[]] $Arguments)
    # Run Azure CLI with JSON output so validation results can be processed consistently.
    $errorFile = [IO.Path]::GetTempFileName()
    try {
        $response = (& az @Arguments --output json 2> $errorFile | Out-String)
        if ($null -eq $response) { $response = '' } else { $response = $response.Trim() }
        $exitCode = $LASTEXITCODE
        $errorOutput = [string](Get-Content -LiteralPath $errorFile -Raw -ErrorAction SilentlyContinue)
        if ($null -eq $errorOutput) { $errorOutput = '' } else { $errorOutput = $errorOutput.Trim() }
    }
    finally {
        Remove-Item -LiteralPath $errorFile -Force -ErrorAction SilentlyContinue
    }
    if ($exitCode -ne 0) { throw "Azure CLI failed ($exitCode): $errorOutput $response" }
    if ([string]::IsNullOrWhiteSpace($response)) { return $null }
    try { return ($response | ConvertFrom-Json) } catch { throw "Azure CLI returned invalid JSON: $response" }
}

function Invoke-AzCommand {
    param([string[]] $Arguments)
    # Run a text-producing Azure CLI command and fail when the CLI returns a nonzero exit code.
    $errorFile = [IO.Path]::GetTempFileName()
    try {
        $response = (& az @Arguments 2> $errorFile | Out-String)
        if ($null -eq $response) { $response = '' } else { $response = $response.Trim() }
        $exitCode = $LASTEXITCODE
        $errorOutput = [string](Get-Content -LiteralPath $errorFile -Raw -ErrorAction SilentlyContinue)
        if ($null -eq $errorOutput) { $errorOutput = '' } else { $errorOutput = $errorOutput.Trim() }
    }
    finally {
        Remove-Item -LiteralPath $errorFile -Force -ErrorAction SilentlyContinue
    }
    if ($exitCode -ne 0) { throw "Azure CLI failed ($exitCode): $errorOutput $response" }
    return $response
}

function Get-ParameterDocument {
    param([string] $Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Parameter file was not found: $Path" }
    # Parse the standard ARM deployment parameter schema for local checks.
    $document = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    if ($null -eq $document.parameters) { throw "Parameter file has no 'parameters' object: $Path" }
    return $document
}

try {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI (az) is required.' }
    if (-not $ParameterFile) { $ParameterFile = Join-Path $PSScriptRoot "..\environments\$Environment.parameters.json" }
    $TemplateFile = (Resolve-Path -LiteralPath $TemplateFile -ErrorAction Stop).Path
    $ParameterFile = (Resolve-Path -LiteralPath $ParameterFile -ErrorAction Stop).Path

    # Compile the Bicep source to verify syntax and module resolution.
    Invoke-AzCommand @('bicep', 'build', '--file', $TemplateFile) | Out-Null
    Write-Status 'bicep-build' 'succeeded' @{ templateFile = $TemplateFile }
    # Run the configured Bicep analyzer rules using the standalone CLI when available.
    if (Get-Command bicep -ErrorAction SilentlyContinue) {
        $lintOutput = (& bicep lint --file $TemplateFile 2>&1 | Out-String).Trim()
        if ($LASTEXITCODE -ne 0) { throw "Bicep lint failed ($LASTEXITCODE): $lintOutput" }
        Write-Status 'bicep-lint' 'succeeded' @{ templateFile = $TemplateFile; tool = 'bicep' }
    }
    else {
        # Azure CLI Bicep build runs the configured analyzer when no standalone lint command is installed.
        Invoke-AzCommand @('bicep', 'build', '--file', $TemplateFile) | Out-Null
        Write-Status 'bicep-lint' 'succeeded' @{ templateFile = $TemplateFile; tool = 'az bicep build analyzer fallback' }
    }

    $parameterDocument = Get-ParameterDocument $ParameterFile
    $values = $parameterDocument.parameters
    foreach ($name in @('applicationName', 'environment', 'location', 'resourceGroupPrefix')) {
        if ($null -eq $values.$name -or [string]::IsNullOrWhiteSpace([string] $values.$name.value)) { throw "Required parameter '$name' is missing or empty." }
    }
    if ([string] $values.environment.value -ne $Environment) { throw "Environment '$($values.environment.value)' does not match '$Environment'." }
    Write-Status 'parameter-validation' 'succeeded' @{ environment = $Environment; parameterFile = $ParameterFile }

    # Verify that Azure CLI has an authenticated account and select the requested subscription when supplied.
    $account = Invoke-AzJson @('account', 'show')
    if ($SubscriptionId) { Invoke-AzJson @('account', 'set', '--subscription', $SubscriptionId) | Out-Null; $account = Invoke-AzJson @('account', 'show') }
    if ($SubscriptionId -and $account.id -ne $SubscriptionId) { throw "Active subscription '$($account.id)' does not match '$SubscriptionId'." }
    Write-Status 'subscription-validation' 'succeeded' @{ subscriptionId = [string] $account.id }

    # Ask Azure Resource Manager to validate the subscription-scoped deployment without changing resources.
    Invoke-AzJson @('deployment', 'sub', 'validate', '--location', [string] $values.location.value, '--template-file', $TemplateFile, '--parameters', "@$ParameterFile") | Out-Null
    Write-Status 'azure-validation' 'succeeded'
    # Ask Azure Resource Manager to calculate changes; What-If does not create or modify resources.
    Invoke-AzCommand @('deployment', 'sub', 'what-if', '--location', [string] $values.location.value, '--template-file', $TemplateFile, '--parameters', "@$ParameterFile") | Out-Null
    Write-Status 'what-if-validation' 'succeeded'
    Write-Status 'validation-summary' 'succeeded' @{ environment = $Environment; templateFile = $TemplateFile; parameterFile = $ParameterFile }
    exit 0
}
catch {
    Write-Status 'validation-summary' 'failed' @{ message = $_.Exception.Message; environment = $Environment }
    exit 1
}
