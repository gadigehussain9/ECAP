targetScope = 'subscription'

@description('Short application identifier used in resource names and tags.')
param applicationName string

@description('Deployment environment, for example dev, qa, stage, or prod.')
param environment string

@description('Azure region for the environment resources.')
param location string

@description('Prefix used for the environment Resource Group name.')
param resourceGroupPrefix string

@description('Resource owner or owning team.')
param owner string

@description('Infrastructure management system.')
param managedBy string

@description('Cost allocation identifier.')
param costCenter string

@description('Business unit responsible for the resources.')
param businessUnit string

@description('Business criticality classification.')
param criticality string

@description('Identity that created or deployed the resources.')
param createdBy string

@description('Version of the infrastructure contract.')
param infrastructureVersion string

@description('Additional resource tags.')
param additionalTags object = {}

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

var nameSuffix = '${toLower(applicationName)}-${toLower(environment)}'
var resourceGroupName = '${resourceGroupPrefix}-${nameSuffix}'
var standardTags = union(additionalTags, {
  Application: applicationName
  Environment: environment
  Owner: owner
  ManagedBy: managedBy
  CostCenter: costCenter
  BusinessUnit: businessUnit
  Criticality: criticality
  CreatedBy: createdBy
  Version: infrastructureVersion
})

module naming './modules/naming.bicep' = {
  name: 'ecap-naming-${uniqueString(subscription().id, applicationName, environment)}'
  scope: subscription()
  params: {
    applicationName: applicationName
    environment: environment
    resourcePrefix: resourceGroupPrefix
  }
}

module tagging './modules/tags.bicep' = {
  name: 'ecap-tags-${uniqueString(subscription().id, applicationName, environment)}'
  scope: subscription()
  params: {
    application: applicationName
    environment: environment
    owner: owner
    managedBy: managedBy
    costCenter: costCenter
    businessUnit: businessUnit
    criticality: criticality
    createdBy: createdBy
    version: infrastructureVersion
    additionalTags: additionalTags
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: standardTags
}

module logAnalytics './modules/log-analytics.bicep' = {
  name: 'ecap-log-analytics-${environment}'
  scope: resourceGroup
  params: {
    workspaceName: naming.outputs.logAnalyticsWorkspaceName
    location: location
    skuName: logAnalyticsSku
    retentionInDays: logAnalyticsRetentionInDays
    publicNetworkAccessForIngestion: logAnalyticsPublicNetworkAccessForIngestion
    publicNetworkAccessForQuery: logAnalyticsPublicNetworkAccessForQuery
    tags: tagging.outputs.standardTags
  }
}

module applicationInsights './modules/application-insights.bicep' = {
  name: 'ecap-application-insights-${environment}'
  scope: resourceGroup
  params: {
    applicationInsightsName: naming.outputs.applicationInsightsName
    location: location
    workspaceResourceId: logAnalytics.outputs.resourceId
    kind: applicationInsightsKind
    applicationType: applicationInsightsType
    tags: tagging.outputs.standardTags
  }
}

output resourceGroupId string = resourceGroup.id
output resourceGroupName string = resourceGroup.name
output logAnalyticsWorkspaceId string = logAnalytics.outputs.resourceId
output logAnalyticsWorkspaceName string = logAnalytics.outputs.name
output logAnalyticsCustomerId string = logAnalytics.outputs.customerId
output applicationInsightsId string = applicationInsights.outputs.resourceId
output applicationInsightsName string = applicationInsights.outputs.name
@secure()
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString
