<#
.SYNOPSIS
    Deploys the ECAP subscription-scoped Bicep template for one environment.
.DESCRIPTION
    The script checks Azure authentication and subscription context, validates the
    environment parameter file, validates the template, creates the deployment,
    and emits JSON status records and a deployment summary. Secure deployment
    outputs are never written to the console.
.EXAMPLE
    ./deploy.ps1 -Environment dev
    ./deploy.ps1 -Environment prod -SubscriptionId '00000000-0000-0000-0000-000000000000'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dev', 'qa', 'stage', 'prod')]
    [string] $Environment,

    [Parameter(Mandatory = $false)]
    [string] $SubscriptionId,

    [Parameter(Mandatory = $false)]
    [string] $ParameterFile,

    [Parameter(Mandatory = $false)]
    [string] $TemplateFile = (Join-Path $PSScriptRoot '..\main.bicep'),

    [Parameter(Mandatory = $false)]
    [string] $DeploymentName = "ecap-$Environment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Status {
    param([string] $Event, [string] $Status, [hashtable] $Data = @{})
    $record = [ordered]@{
        timestamp = (Get-Date).ToUniversalTime().ToString('o')
        event = $Event
        status = $Status
        data = $Data
    }
    Write-Output ($record | ConvertTo-Json -Depth 20 -Compress)
}

function Invoke-AzJson {
    param([string[]] $Arguments)
    # Invoke Azure CLI and capture its machine-readable JSON response.
    $response = (& az @Arguments --output json 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) {
        throw "Azure CLI failed ($LASTEXITCODE): $response"
    }
    if ([string]::IsNullOrWhiteSpace($response)) { return $null }
    try { return ($response | ConvertFrom-Json) }
    catch { throw "Azure CLI returned invalid JSON: $response" }
}

function Get-ParameterDocument {
    param([string] $Path)
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { throw "Parameter file was not found: $Path" }
    # Read the deployment parameter document so required naming and environment values can be checked locally.
    $document = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    if ($null -eq $document.parameters) { throw "Parameter file has no 'parameters' object: $Path" }
    return $document
}

try {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI (az) is required.' }
    if (-not $ParameterFile) { $ParameterFile = Join-Path $PSScriptRoot "..\environments\$Environment.parameters.json" }
    $TemplateFile = (Resolve-Path -LiteralPath $TemplateFile -ErrorAction Stop).Path
    $ParameterFile = (Resolve-Path -LiteralPath $ParameterFile -ErrorAction Stop).Path

    Write-Status 'login-check' 'started'
    # Query the current Azure CLI account to verify that an authenticated session exists.
    $account = Invoke-AzJson @('account', 'show')
    if ($null -eq $account -or [string]::IsNullOrWhiteSpace([string] $account.id)) { throw 'Azure CLI is not logged in.' }
    Write-Status 'login-check' 'succeeded' @{ user = [string] $account.user.name; tenantId = [string] $account.tenantId }

    if ($SubscriptionId) {
        # Select the requested subscription before validating and deploying to it.
        Invoke-AzJson @('account', 'set', '--subscription', $SubscriptionId) | Out-Null
    }
    # Read the active subscription to prevent deployment to an unintended Azure context.
    $activeSubscription = Invoke-AzJson @('account', 'show')
    if ($SubscriptionId -and $activeSubscription.id -ne $SubscriptionId) { throw "Active subscription '$($activeSubscription.id)' does not match '$SubscriptionId'." }
    Write-Status 'subscription-validation' 'succeeded' @{ subscriptionId = [string] $activeSubscription.id; subscriptionName = [string] $activeSubscription.name }

    $parameterDocument = Get-ParameterDocument $ParameterFile
    $values = $parameterDocument.parameters
    foreach ($name in @('applicationName', 'environment', 'location', 'resourceGroupPrefix')) {
        if ($null -eq $values.$name -or [string]::IsNullOrWhiteSpace([string] $values.$name.value)) { throw "Required parameter '$name' is missing or empty." }
    }
    if ([string] $values.environment.value -ne $Environment) { throw "Environment '$($values.environment.value)' in the parameter file does not match '$Environment'." }
    $suffix = if ($values.namingSuffix) { [string] $values.namingSuffix.value } else { '' }
    $resourceGroupName = "{0}-{1}-{2}{3}" -f ([string] $values.resourceGroupPrefix.value).ToLowerInvariant(), ([string] $values.applicationName.value).ToLowerInvariant(), $Environment.ToLowerInvariant(), $(if ($suffix) { "-$($suffix.ToLowerInvariant().Replace(' ', '-'))" } else { '' })
    Write-Status 'parameter-validation' 'succeeded' @{ environment = $Environment; parameterFile = $ParameterFile; resourceGroupName = $resourceGroupName; location = [string] $values.location.value }

    # Validate the subscription-scoped Bicep template and all supplied parameters before creating resources.
    Invoke-AzJson @('deployment', 'sub', 'validate', '--location', [string] $values.location.value, '--template-file', $TemplateFile, '--parameters', "@$ParameterFile") | Out-Null
    Write-Status 'template-validation' 'succeeded' @{ templateFile = $TemplateFile }

    # Create the subscription deployment; the template itself creates or updates the environment Resource Group.
    $deployment = Invoke-AzJson @('deployment', 'sub', 'create', '--name', $DeploymentName, '--location', [string] $values.location.value, '--template-file', $TemplateFile, '--parameters', "@$ParameterFile")
    $provisioningState = [string] $deployment.properties.provisioningState
    if ($provisioningState -ne 'Succeeded') { throw "Deployment completed with state '$provisioningState'." }
    $outputs = @{}
    if ($deployment.properties.outputs) {
        foreach ($property in $deployment.properties.outputs.psobject.Properties) {
            # Omit secure or secret-like output names from structured console output.
            if ($property.Name -notmatch '(?i)secret|password|connection|string|key|token') { $outputs[$property.Name] = $property.Value.value }
        }
    }
    Write-Status 'deployment-summary' 'succeeded' @{ deploymentName = $DeploymentName; provisioningState = $provisioningState; resourceGroupName = $resourceGroupName; outputs = $outputs }
    exit 0
}
catch {
    Write-Status 'deployment-summary' 'failed' @{ message = $_.Exception.Message; environment = $Environment; deploymentName = $DeploymentName }
    exit 1
}
