targetScope = 'resourceGroup'

@description('Globally unique Azure SQL logical server name.')
param name string

@description('Azure region for the SQL logical server.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Whether public network access to the SQL logical server is enabled. Disable when Private Endpoint networking is provisioned.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Enabled'

@description('Microsoft Entra administrator login/display name. Leave empty to provision the server before the tenant administrator is assigned.')
param administratorLogin string = ''

@description('Microsoft Entra administrator object ID. No SQL authentication credentials are used.')
param administratorObjectId string = ''

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  sqlServerLogCategories: [
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

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: {
    minimalTlsVersion: '1.2'
    publicNetworkAccess: publicNetworkAccess
    version: '12.0'
  }
}

resource sqlAdministrator 'Microsoft.Sql/servers/administrators@2022-05-01-preview' = if (!empty(administratorLogin) && !empty(administratorObjectId)) {
  name: 'ActiveDirectory'
  parent: sqlServer
  properties: {
    administratorType: 'ActiveDirectory'
    login: administratorLogin
    sid: administratorObjectId
    tenantId: subscription().tenantId
  }
}

resource sqlServerDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'sql-server-diagnostics'
  scope: sqlServer
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.sqlServerLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output name string = sqlServer.name
output resourceId string = sqlServer.id
output fullyQualifiedDomainName string = sqlServer.properties.fullyQualifiedDomainName
