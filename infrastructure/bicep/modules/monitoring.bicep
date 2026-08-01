targetScope = 'resourceGroup'

@description('Name of the Log Analytics workspace.')
param workspaceName string

@description('Name of the Application Insights component.')
param applicationInsightsName string

@description('Azure region for monitoring resources.')
param location string

@description('Log Analytics workspace SKU.')
param logAnalyticsSku string = 'PerGB2018'

@description('Number of days to retain Log Analytics data.')
param logAnalyticsRetentionInDays int = 30

@description('Whether public Log Analytics ingestion is enabled.')
param logAnalyticsPublicNetworkAccessForIngestion string = 'Enabled'

@description('Whether public Log Analytics queries are enabled.')
param logAnalyticsPublicNetworkAccessForQuery string = 'Enabled'

@description('Application Insights resource kind.')
param applicationInsightsKind string = 'web'

@description('Application Insights application type.')
param applicationInsightsType string = 'web'

@description('Standard ECAP resource tags.')
param tags object

module logAnalytics './log-analytics.bicep' = {
  name: 'ecap-log-analytics'
  params: {
    workspaceName: workspaceName
    location: location
    skuName: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
    publicNetworkAccessForIngestion: logAnalyticsPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: logAnalyticsPublicNetworkAccessForQuery
    tags: tags
  }
}

module applicationInsights './application-insights.bicep' = {
  name: 'ecap-application-insights'
  params: {
    applicationInsightsName: applicationInsightsName
    location: location
    workspaceResourceId: logAnalytics.outputs.resourceId
    kind: applicationInsightsKind
    applicationType: applicationInsightsType
    tags: tags
  }
}

output logAnalyticsWorkspaceId string = logAnalytics.outputs.resourceId
output logAnalyticsWorkspaceName string = logAnalytics.outputs.name
output logAnalyticsCustomerId string = logAnalytics.outputs.customerId
output applicationInsightsId string = applicationInsights.outputs.resourceId
output applicationInsightsName string = applicationInsights.outputs.name
@secure()
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString
