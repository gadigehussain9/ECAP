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
    sku: globals.storageConfiguration.sku
    largeFileSharesState: globals.storageConfiguration.largeFileSharesState
    allowSharedKeyAccess: globals.storageConfiguration.allowSharedKeyAccess
    publicNetworkAccess: globals.storageConfiguration.publicNetworkAccess
    minimumTlsVersion: globals.storageConfiguration.minimumTlsVersion
    networkAcls: globals.storageConfiguration.networkAcls
    blobVersioningEnabled: globals.storageConfiguration.blobVersioningEnabled
    blobSoftDeleteRetentionDays: globals.storageConfiguration.blobSoftDeleteRetentionDays
    containerSoftDeleteRetentionDays: globals.storageConfiguration.containerSoftDeleteRetentionDays
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: globals.diagnosticSettings
  }
}

module sqlServer './sql-server.bicep' = {
  name: 'ecap-sql-server'
  params: {
    name: globals.namingOutputs.sqlServerName
    location: globals.location
    tags: globals.standardTags
    publicNetworkAccess: globals.sqlConfiguration.publicNetworkAccess
    administratorLogin: globals.sqlConfiguration.administratorLogin
    administratorObjectId: globals.sqlConfiguration.administratorObjectId
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: globals.diagnosticSettings
  }
}

module sqlDatabase './sql-database.bicep' = {
  name: 'ecap-sql-database'
  params: {
    name: globals.namingOutputs.sqlDatabaseName
    serverName: sqlServer.outputs.name
    tags: globals.standardTags
    skuName: globals.sqlConfiguration.databaseSkuName
    skuTier: globals.sqlConfiguration.databaseSkuTier
    skuFamily: globals.sqlConfiguration.databaseSkuFamily
    skuCapacity: globals.sqlConfiguration.databaseSkuCapacity
    computeModel: globals.sqlConfiguration.databaseComputeModel
    autoPauseDelayMinutes: globals.sqlConfiguration.databaseAutoPauseDelayMinutes
    zoneRedundant: globals.sqlConfiguration.databaseZoneRedundant
    backupRetentionDays: globals.sqlConfiguration.backupRetentionDays
    differentialBackupIntervalHours: globals.sqlConfiguration.differentialBackupIntervalHours
    backupStorageRedundancy: globals.sqlConfiguration.backupStorageRedundancy
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
output sqlServerName string = sqlServer.outputs.name
output sqlServerResourceId string = sqlServer.outputs.resourceId
output sqlServerFullyQualifiedDomainName string = sqlServer.outputs.fullyQualifiedDomainName
output sqlDatabaseName string = sqlDatabase.outputs.name
output sqlDatabaseResourceId string = sqlDatabase.outputs.resourceId
