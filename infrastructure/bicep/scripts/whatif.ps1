<#
.SYNOPSIS
    Displays Azure What-If changes for an ECAP environment.
.DESCRIPTION
    Validates Azure context and the environment parameter file, then calls the
    subscription-scoped Azure What-If operation. It never calls deployment create
    and therefore does not modify resources. Changes and a summary are emitted as
    JSON records; failures return exit code 1.
.EXAMPLE
    ./whatif.ps1 -Environment stage
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dev', 'qa', 'stage', 'prod')]
    [string] $Environment,
    [string] $SubscriptionId,
    [string] $ParameterFile,
    [string] $TemplateFile = (Join-Path $PSScriptRoot '..\main.bicep'),
    [string] $Location
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Status {
    param([string] $Event, [string] $Status, [hashtable] $Data = @{})
    Write-Output (([ordered]@{ timestamp = (Get-Date).ToUniversalTime().ToString('o'); event = $Event; status = $Status; data = $Data } | ConvertTo-Json -Depth 20 -Compress))
}

function Invoke-AzJson {
    param([string[]] $Arguments)
    # Run Azure CLI in JSON mode so What-If changes can be enumerated without scraping table output.
    $response = (& az @Arguments --output json 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Azure CLI failed ($LASTEXITCODE): $response" }
    if ([string]::IsNullOrWhiteSpace($response)) { return $null }
    try { return ($response | ConvertFrom-Json) } catch { throw "Azure CLI returned invalid JSON: $response" }
}

try {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI (az) is required.' }
    if (-not $ParameterFile) { $ParameterFile = Join-Path $PSScriptRoot "..\environments\$Environment.parameters.json" }
    $TemplateFile = (Resolve-Path -LiteralPath $TemplateFile -ErrorAction Stop).Path
    $ParameterFile = (Resolve-Path -LiteralPath $ParameterFile -ErrorAction Stop).Path
    $values = (Get-Content -LiteralPath $ParameterFile -Raw | ConvertFrom-Json).parameters
    foreach ($name in @('applicationName', 'environment', 'location', 'resourceGroupPrefix')) {
        if ($null -eq $values.$name -or [string]::IsNullOrWhiteSpace([string] $values.$name.value)) { throw "Required parameter '$name' is missing or empty." }
    }
    if ([string] $values.environment.value -ne $Environment) { throw "Environment '$($values.environment.value)' does not match '$Environment'." }
    if (-not $Location) { $Location = [string] $values.location.value }

    # Verify the authenticated Azure CLI account and select the requested subscription when supplied.
    $account = Invoke-AzJson @('account', 'show')
    if ($SubscriptionId) { Invoke-AzJson @('account', 'set', '--subscription', $SubscriptionId) | Out-Null; $account = Invoke-AzJson @('account', 'show') }
    if ($SubscriptionId -and $account.id -ne $SubscriptionId) { throw "Active subscription '$($account.id)' does not match '$SubscriptionId'." }
    Write-Status 'subscription-validation' 'succeeded' @{ subscriptionId = [string] $account.id; environment = $Environment }

    # Request a plan from Azure Resource Manager; this is the only deployment-related command in this script.
    $whatIf = Invoke-AzJson @('deployment', 'sub', 'what-if', '--location', $Location, '--template-file', $TemplateFile, '--parameters', "@$ParameterFile")
    $changes = @($whatIf.changes)
    $counts = @{}
    foreach ($change in $changes) {
        $changeType = [string] $change.changeType
        if (-not $counts.ContainsKey($changeType)) { $counts[$changeType] = 0 }
        $counts[$changeType]++
        # Emit resource-level changes while leaving secure property values out of console output.
        Write-Status 'what-if-change' 'detected' @{ changeType = $changeType; resourceId = [string] $change.resourceId; resourceType = [string] $change.resourceType }
    }
    Write-Status 'what-if-summary' 'succeeded' @{ environment = $Environment; changeCount = $changes.Count; changeTypes = $counts; deploymentPerformed = $false; templateFile = $TemplateFile; parameterFile = $ParameterFile }
    exit 0
}
catch {
    Write-Status 'what-if-summary' 'failed' @{ message = $_.Exception.Message; environment = $Environment; deploymentPerformed = $false }
    exit 1
}
