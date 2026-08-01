targetScope = 'subscription'

@description('Deployment environment, for example dev, qa, stage, or prod.')
param environment string

@description('Azure region for the environment resources.')
param location string

@description('Short application identifier used in resource names and tags.')
param applicationName string

@description('Company or organization name used by downstream governance consumers.')
param companyName string = 'ECAP'

@description('Optional ECAP project or product identifier.')
param project string = ''

@description('Prefix used for the environment Resource Group name.')
param resourceGroupPrefix string = 'rg'

@description('Optional suffix applied by the centralized naming service.')
param namingSuffix string = ''

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

@description('Source repository identifier.')
param repository string = ''

@description('Department responsible for the workload.')
param department string = ''

@description('Support contact or support team identifier.')
param supportContact string = ''

@description('Workload lifecycle state.')
param lifecycle string = 'Active'

@description('Data classification applied to the resources.')
param dataClassification string = 'Internal'

@description('Compliance classification or applicable control framework.')
param compliance string = 'None'

@description('Business owner for the workload.')
param businessOwner string = ''

@description('Technical owner for the workload.')
param technicalOwner string = ''

@description('Workload classification.')
param workload string = ''

@description('Deployment date in ISO 8601 date format.')
param deploymentDate string = utcNow('yyyy-MM-dd')

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

@description('Whether standard diagnostic settings are enabled.')
param diagnosticSettingsEnabled bool = true

@description('Locations approved by the platform policy. Defaults to the deployment location.')
param allowedLocations array = []

@description('Feature flags reserved for future platform capabilities.')
param featureFlags object = {}

module naming './shared/naming.bicep' = {
  name: 'ecap-naming-${uniqueString(subscription().id, applicationName, environment)}'
  params: {
    applicationName: applicationName
    environment: environment
    location: location
    resourceGroupPrefix: resourceGroupPrefix
    optionalSuffix: namingSuffix
  }
}

module tagging './shared/tags.bicep' = {
  name: 'ecap-tags-${uniqueString(subscription().id, applicationName, environment)}'
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
    project: project
    repository: repository
    department: department
    supportContact: supportContact
    lifecycle: lifecycle
    dataClassification: dataClassification
    compliance: compliance
    businessOwner: businessOwner
    technicalOwner: technicalOwner
    workload: workload
    deploymentDate: deploymentDate
    additionalTags: additionalTags
  }
}

var effectiveProjectName = empty(project) ? applicationName : project
var effectiveAllowedLocations = empty(allowedLocations) ? [location] : allowedLocations
var defaultSkus = {
  logAnalytics: logAnalyticsSku
  keyVault: 'standard'
  appConfiguration: 'standard'
}
var monitoringConfiguration = {
  logAnalyticsRetentionInDays: logAnalyticsRetentionInDays
  logAnalyticsPublicNetworkAccessForIngestion: logAnalyticsPublicNetworkAccessForIngestion
  logAnalyticsPublicNetworkAccessForQuery: logAnalyticsPublicNetworkAccessForQuery
  applicationInsightsKind: applicationInsightsKind
  applicationInsightsType: applicationInsightsType
}
var diagnosticSettings = {
  enabled: diagnosticSettingsEnabled
  keyVaultLogCategories: [
    'AuditEvent'
  ]
  appConfigurationLogCategories: [
    'HttpRequest'
    'Audit'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}
var namingOutputs = {
  resourceGroupName: naming.outputs.resourceGroupName
  appServiceName: naming.outputs.appServiceName
  appServicePlanName: naming.outputs.appServicePlanName
  storageAccountName: naming.outputs.storageAccountName
  sqlServerName: naming.outputs.sqlServerName
  sqlDatabaseName: naming.outputs.sqlDatabaseName
  keyVaultName: naming.outputs.keyVaultName
  azureOpenAIName: naming.outputs.azureOpenAIName
  aiSearchName: naming.outputs.aiSearchName
  managedIdentityName: naming.outputs.managedIdentityName
  logAnalyticsWorkspaceName: naming.outputs.logAnalyticsWorkspaceName
  applicationInsightsName: naming.outputs.applicationInsightsName
  appConfigurationName: naming.outputs.appConfigurationName
}

output globals object = {
  environment: environment
  location: location
  applicationName: applicationName
  companyName: companyName
  projectName: effectiveProjectName
  resourcePrefix: resourceGroupPrefix
  standardTags: tagging.outputs.standardTags
  defaultSkus: defaultSkus
  monitoringConfiguration: monitoringConfiguration
  diagnosticSettings: diagnosticSettings
  allowedLocations: effectiveAllowedLocations
  namingOutputs: namingOutputs
  featureFlags: featureFlags
}

output environment string = environment
output location string = location
output applicationName string = applicationName
output companyName string = companyName
output projectName string = effectiveProjectName
output resourcePrefix string = resourceGroupPrefix
output standardTags object = tagging.outputs.standardTags
output defaultSkus object = defaultSkus
output monitoringConfiguration object = monitoringConfiguration
output diagnosticSettings object = diagnosticSettings
output allowedLocations array = effectiveAllowedLocations
output namingOutputs object = namingOutputs
output featureFlags object = featureFlags
