targetScope = 'resourceGroup'

@description('Azure SQL database name.')
param name string

@description('Parent Azure SQL logical server name.')
param serverName string

@description('Standard ECAP resource tags.')
param tags object

@description('Azure SQL SKU name, such as GP_Gen5_2 for provisioned or GP_S_Gen5_1 for serverless.')
param skuName string = 'GP_Gen5_2'

@description('Azure SQL service tier.')
param skuTier string = 'GeneralPurpose'

@description('Azure SQL SKU family.')
param skuFamily string = 'Gen5'

@description('Azure SQL vCore capacity.')
param skuCapacity int = 2

@description('Compute model. Serverless uses the configured auto-pause value; Provisioned disables auto-pause.')
@allowed([
  'Provisioned'
  'Serverless'
])
param computeModel string = 'Provisioned'

@description('Number of minutes before an idle serverless database is paused. Use -1 to disable auto-pause.')
@minValue(-1)
param autoPauseDelayMinutes int = 60

@description('Whether zone redundancy is enabled for the database.')
param zoneRedundant bool = false

@description('Point-in-time restore retention in days.')
@minValue(1)
@maxValue(35)
param backupRetentionDays int = 7

@description('Differential backup interval in hours.')
@allowed([
  12
  24
])
param differentialBackupIntervalHours int = 12

@description('Requested backup storage redundancy.')
@allowed([
  'Local'
  'Zone'
  'Geo'
])
param backupStorageRedundancy string = 'Local'

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  sqlDatabaseLogCategories: [
    'SQLInsights'
    'AutomaticTuning'
    'QueryStoreRuntimeStatistics'
    'QueryStoreWaitStatistics'
    'Errors'
    'DatabaseWaitStatistics'
    'Timeouts'
    'Blocks'
    'Deadlocks'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-08-01' = {
  name: name
  parent: sqlServer
  location: resourceGroup().location
  tags: tags
  sku: {
    name: skuName
    tier: skuTier
    family: skuFamily
    capacity: skuCapacity
  }
  properties: {
    autoPauseDelay: computeModel == 'Serverless' ? autoPauseDelayMinutes : -1
    requestedBackupStorageRedundancy: backupStorageRedundancy
    zoneRedundant: zoneRedundant
  }
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2023-08-01' = {
  name: 'default'
  parent: sqlDatabase
  properties: {
    retentionDays: backupRetentionDays
    diffBackupIntervalInHours: differentialBackupIntervalHours
  }
}

resource transparentDataEncryption 'Microsoft.Sql/servers/databases/transparentDataEncryption@2021-11-01' = {
  name: 'current'
  parent: sqlDatabase
  properties: {
    state: 'Enabled'
  }
}

resource sqlDatabaseDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'sql-database-diagnostics'
  scope: sqlDatabase
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.sqlDatabaseLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output name string = sqlDatabase.name
output resourceId string = sqlDatabase.id
