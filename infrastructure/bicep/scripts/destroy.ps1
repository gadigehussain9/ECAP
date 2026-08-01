<#
.SYNOPSIS
    Safely deletes the ECAP environment Resource Group.
.DESCRIPTION
    Resolves the expected Resource Group from the environment parameter file,
    verifies Azure context and Resource Group identity, requires an exact
    confirmation phrase, and logs structured deletion events. Production also
    requires -Force. The deletion operation is asynchronous in Azure and is
    submitted only after all safety checks pass.
.EXAMPLE
    ./destroy.ps1 -Environment dev -Confirmation 'DELETE rg-ecap-dev'
    ./destroy.ps1 -Environment prod -Confirmation 'DELETE rg-ecap-prod' -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('dev', 'qa', 'stage', 'prod')]
    [string] $Environment,
    [Parameter(Mandatory = $true)]
    [string] $Confirmation,
    [switch] $Force,
    [string] $SubscriptionId,
    [string] $ParameterFile,
    [string] $LogPath = (Join-Path $PSScriptRoot 'destroy.log')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Status {
    param([string] $Event, [string] $Status, [hashtable] $Data = @{})
    $record = [ordered]@{ timestamp = (Get-Date).ToUniversalTime().ToString('o'); event = $Event; status = $Status; data = $Data }
    $json = $record | ConvertTo-Json -Depth 20 -Compress
    Write-Output $json
    # Append the same structured record to the operator log for auditability.
    Add-Content -LiteralPath $LogPath -Value $json
}

function Invoke-AzJson {
    param([string[]] $Arguments)
    # Execute Azure CLI and parse the JSON response used by safety checks and deletion.
    $response = (& az @Arguments --output json 2>&1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw "Azure CLI failed ($LASTEXITCODE): $response" }
    if ([string]::IsNullOrWhiteSpace($response)) { return $null }
    try { return ($response | ConvertFrom-Json) } catch { throw "Azure CLI returned invalid JSON: $response" }
}

try {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) { throw 'Azure CLI (az) is required.' }
    $logDirectory = Split-Path -Parent $LogPath
    if ($logDirectory -and -not (Test-Path -LiteralPath $logDirectory)) { New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null }
    if (-not $ParameterFile) { $ParameterFile = Join-Path $PSScriptRoot "..\environments\$Environment.parameters.json" }
    $ParameterFile = (Resolve-Path -LiteralPath $ParameterFile -ErrorAction Stop).Path
    $values = (Get-Content -LiteralPath $ParameterFile -Raw | ConvertFrom-Json).parameters
    foreach ($name in @('applicationName', 'environment', 'resourceGroupPrefix')) {
        if ($null -eq $values.$name -or [string]::IsNullOrWhiteSpace([string] $values.$name.value)) { throw "Required parameter '$name' is missing or empty." }
    }
    if ([string] $values.environment.value -ne $Environment) { throw "Environment '$($values.environment.value)' does not match '$Environment'." }
    $suffix = if ($values.namingSuffix) { [string] $values.namingSuffix.value } else { '' }
    $resourceGroupName = "{0}-{1}-{2}{3}" -f ([string] $values.resourceGroupPrefix.value).ToLowerInvariant(), ([string] $values.applicationName.value).ToLowerInvariant(), $Environment.ToLowerInvariant(), $(if ($suffix) { "-$($suffix.ToLowerInvariant().Replace(' ', '-'))" } else { '' })
    $expectedConfirmation = "DELETE $resourceGroupName"

    # Query the current Azure CLI account to prove that deletion has an authenticated context.
    $account = Invoke-AzJson @('account', 'show')
    if ($SubscriptionId) { Invoke-AzJson @('account', 'set', '--subscription', $SubscriptionId) | Out-Null; $account = Invoke-AzJson @('account', 'show') }
    if ($SubscriptionId -and $account.id -ne $SubscriptionId) { throw "Active subscription '$($account.id)' does not match '$SubscriptionId'." }
    Write-Status 'subscription-validation' 'succeeded' @{ subscriptionId = [string] $account.id; environment = $Environment }

    if ($Environment -eq 'prod' -and -not $Force) { throw 'Production deletion requires the -Force switch.' }
    if ($Confirmation -cne $expectedConfirmation) { throw "Confirmation mismatch. Supply exactly: $expectedConfirmation" }
    Write-Status 'safety-check' 'succeeded' @{ resourceGroupName = $resourceGroupName; productionForce = [bool] $Force }

    # Confirm the target exists and capture its subscription identity before deletion.
    $resourceGroup = Invoke-AzJson @('group', 'show', '--name', $resourceGroupName)
    if ($null -eq $resourceGroup -or [string]::IsNullOrWhiteSpace([string] $resourceGroup.id)) { throw "Resource Group '$resourceGroupName' was not found." }
    if ($resourceGroup.id -notmatch "/resourceGroups/$resourceGroupName$") { throw 'Resolved Resource Group identity did not match the expected name.' }
    Write-Status 'resource-group-validation' 'succeeded' @{ resourceGroupName = $resourceGroupName; location = [string] $resourceGroup.location }

    # Submit an asynchronous Resource Group deletion only after every guard has passed.
    Invoke-AzJson @('group', 'delete', '--name', $resourceGroupName, '--yes', '--no-wait') | Out-Null
    Write-Status 'resource-group-deletion' 'submitted' @{ resourceGroupName = $resourceGroupName; asynchronous = $true }
    exit 0
}
catch {
    try { Write-Status 'resource-group-deletion' 'failed' @{ message = $_.Exception.Message; environment = $Environment } }
    catch { Write-Output (([ordered]@{ timestamp = (Get-Date).ToUniversalTime().ToString('o'); event = 'resource-group-deletion'; status = 'failed'; data = @{ message = $_.Exception.Message } } | ConvertTo-Json -Compress)) }
    exit 1
}
