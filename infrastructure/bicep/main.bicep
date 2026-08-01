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

module monitoring './modules/monitoring.bicep' = {
  name: 'ecap-monitoring-${environment}'
  scope: resourceGroup
  params: {
    workspaceName: naming.outputs.logAnalyticsWorkspaceName
    applicationInsightsName: naming.outputs.applicationInsightsName
    location: location
    logAnalyticsSku: logAnalyticsSku
    logAnalyticsRetentionInDays: logAnalyticsRetentionInDays
    logAnalyticsPublicNetworkAccessForIngestion: logAnalyticsPublicNetworkAccessForIngestion
    logAnalyticsPublicNetworkAccessForQuery: logAnalyticsPublicNetworkAccessForQuery
    applicationInsightsKind: applicationInsightsKind
    applicationInsightsType: applicationInsightsType
    tags: tagging.outputs.standardTags
  }
}

module security './modules/security.bicep' = {
  name: 'ecap-security-${environment}'
  scope: resourceGroup
}

module configuration './modules/configuration.bicep' = {
  name: 'ecap-configuration-${environment}'
  scope: resourceGroup
}

module data './modules/data.bicep' = {
  name: 'ecap-data-${environment}'
  scope: resourceGroup
}

module ai './modules/ai.bicep' = {
  name: 'ecap-ai-${environment}'
  scope: resourceGroup
}

module compute './modules/compute.bicep' = {
  name: 'ecap-compute-${environment}'
  scope: resourceGroup
}

module networking './modules/networking.bicep' = {
  name: 'ecap-networking-${environment}'
  scope: resourceGroup
}

output resourceGroupId string = resourceGroup.id
output resourceGroupName string = resourceGroup.name
output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
output logAnalyticsWorkspaceName string = monitoring.outputs.logAnalyticsWorkspaceName
output logAnalyticsCustomerId string = monitoring.outputs.logAnalyticsCustomerId
output applicationInsightsId string = monitoring.outputs.applicationInsightsId
output applicationInsightsName string = monitoring.outputs.applicationInsightsName
@secure()
output applicationInsightsConnectionString string = monitoring.outputs.applicationInsightsConnectionString
