targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

module storageAccount './storage-account.bicep' = {
  name: 'ecap-storage-account'
  params: {
    name: globals.namingOutputs.storageAccountName
    location: globals.location
    tags: globals.standardTags
    largeFileSharesState: globals.storageConfiguration.largeFileSharesState
    allowSharedKeyAccess: globals.storageConfiguration.allowSharedKeyAccess
    publicNetworkAccess: globals.storageConfiguration.publicNetworkAccess
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: globals.diagnosticSettings
  }
}

output inheritedTags object = globals.standardTags
output storageAccountName string = storageAccount.outputs.name
output storageAccountResourceId string = storageAccount.outputs.resourceId
output blobEndpoint string = storageAccount.outputs.blobEndpoint
output queueEndpoint string = storageAccount.outputs.queueEndpoint
output tableEndpoint string = storageAccount.outputs.tableEndpoint
output fileEndpoint string = storageAccount.outputs.fileEndpoint
