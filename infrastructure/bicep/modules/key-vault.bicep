targetScope = 'resourceGroup'

@description('Name of the Key Vault.')
param name string

@description('Azure region for the Key Vault.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Whether purge protection is enabled. This cannot be disabled after it is enabled.')
param enablePurgeProtection bool = false

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  keyVaultLogCategories: [
    'AuditEvent'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableSoftDelete: true
    enablePurgeProtection: enablePurgeProtection
    enableRbacAuthorization: true
    publicNetworkAccess: 'Enabled'
    softDeleteRetentionInDays: 90
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
}

resource keyVaultDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'key-vault-diagnostics'
  scope: keyVault
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.keyVaultLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output resourceId string = keyVault.id
output name string = keyVault.name
output vaultUri string = keyVault.properties.vaultUri
