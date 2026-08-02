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

@description('Storage Account replication SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param sku string = 'Standard_LRS'

@description('Whether shared key authorization is allowed. Azure RBAC is preferred.')
param allowSharedKeyAccess bool = false

@description('Whether public network access to the Storage Account is enabled. Keep enabled until private endpoint networking is provisioned.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Minimum TLS version accepted by the Storage Account.')
@allowed([
  'TLS1_2'
])
param minimumTlsVersion string = 'TLS1_2'

@description('Storage network ACL configuration reserved for future network restrictions.')
param networkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
  ipRules: []
  virtualNetworkRules: []
}

@description('Whether Blob Service versioning is enabled.')
param blobVersioningEnabled bool = true

@description('Number of days deleted blobs are retained for recovery.')
@minValue(1)
@maxValue(365)
param blobSoftDeleteRetentionDays int = 30

@description('Number of days deleted containers are retained for recovery.')
@minValue(1)
@maxValue(365)
param containerSoftDeleteRetentionDays int = 30

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
    name: sku
  }
  kind: 'StorageV2'
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
    minimumTlsVersion: minimumTlsVersion
    networkAcls: {
      bypass: networkAcls.bypass
      defaultAction: networkAcls.defaultAction
      ipRules: networkAcls.ipRules
      virtualNetworkRules: networkAcls.virtualNetworkRules
    }
    publicNetworkAccess: publicNetworkAccess
    supportsHttpsTrafficOnly: true
  }
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  name: 'default'
  parent: storageAccount
  properties: {
    isVersioningEnabled: blobVersioningEnabled
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      days: blobSoftDeleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: containerSoftDeleteRetentionDays
    }
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
