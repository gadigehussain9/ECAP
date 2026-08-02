targetScope = 'resourceGroup'

@description('Globally unique ECAP Storage Account name.')
param name string

@description('Azure region for the Storage Account.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Whether Azure Files large file shares are enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param largeFileSharesState string = 'Disabled'

@description('Whether shared key authorization is allowed. Azure RBAC is preferred.')
param allowSharedKeyAccess bool = false

@description('Whether public network access to the Storage Account is enabled. Keep enabled until private endpoint networking is provisioned.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  storageAccountLogCategories: [
    'StorageRead'
    'StorageWrite'
    'StorageDelete'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: true
    dnsEndpointType: 'Standard'
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: true
      services: {
        blob: {
          enabled: true
          keyType: 'Account'
        }
        file: {
          enabled: true
          keyType: 'Account'
        }
        queue: {
          enabled: true
          keyType: 'Account'
        }
        table: {
          enabled: true
          keyType: 'Account'
        }
      }
    }
    largeFileSharesState: largeFileSharesState
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: true
  }
}

resource storageAccountDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'storage-account-diagnostics'
  scope: storageAccount
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.storageAccountLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output name string = storageAccount.name
output resourceId string = storageAccount.id
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
output queueEndpoint string = storageAccount.properties.primaryEndpoints.queue
output tableEndpoint string = storageAccount.properties.primaryEndpoints.table
output fileEndpoint string = storageAccount.properties.primaryEndpoints.file
