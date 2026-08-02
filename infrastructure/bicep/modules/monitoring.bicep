targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

module logAnalytics './log-analytics.bicep' = {
  name: 'ecap-log-analytics'
  params: {
    workspaceName: globals.namingOutputs.logAnalyticsWorkspaceName
    location: globals.location
    skuName: globals.defaultSkus.logAnalytics
    retentionInDays: globals.monitoringConfiguration.logAnalyticsRetentionInDays
    publicNetworkAccessForIngestion: globals.monitoringConfiguration.logAnalyticsPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: globals.monitoringConfiguration.logAnalyticsPublicNetworkAccessForQuery
    tags: globals.standardTags
  }
}

module applicationInsights './application-insights.bicep' = {
  name: 'ecap-application-insights'
  params: {
    applicationInsightsName: globals.namingOutputs.applicationInsightsName
    location: globals.location
    workspaceResourceId: logAnalytics.outputs.resourceId
    kind: globals.monitoringConfiguration.applicationInsightsKind
    applicationType: globals.monitoringConfiguration.applicationInsightsType
    samplingPercentage: globals.monitoringConfiguration.applicationInsightsSamplingPercentage
    tags: globals.standardTags
  }
}

output logAnalyticsWorkspaceId string = logAnalytics.outputs.resourceId
output logAnalyticsWorkspaceName string = logAnalytics.outputs.name
output logAnalyticsCustomerId string = logAnalytics.outputs.customerId
output applicationInsightsId string = applicationInsights.outputs.resourceId
output applicationInsightsName string = applicationInsights.outputs.name
@secure()
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString
