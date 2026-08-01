targetScope = 'subscription'

@description('Short application identifier used in ECAP resource names.')
param applicationName string

@description('Deployment environment, for example dev, qa, stage, or prod.')
param environment string

@description('Azure region used to make globally unique names deterministic per deployment location.')
param location string

@description('Prefix used for the environment Resource Group name.')
param resourceGroupPrefix string = 'rg'

@description('Optional suffix appended to the normalized application and environment name.')
param optionalSuffix string = ''

@description('Resource type to return through the generic resourceName output.')
@allowed([
  'resourceGroup'
  'appService'
  'appServicePlan'
  'storageAccount'
  'sqlServer'
  'sqlDatabase'
  'keyVault'
  'azureOpenAI'
  'aiSearch'
  'managedIdentity'
  'logAnalytics'
  'applicationInsights'
  'appConfiguration'
])
param resourceType string = 'resourceGroup'

var normalizedApplicationName = toLower(applicationName)
var normalizedEnvironment = toLower(environment)
var normalizedOptionalSuffix = toLower(replace(optionalSuffix, ' ', '-'))
var nameBase = '${normalizedApplicationName}-${normalizedEnvironment}'
var qualifiedName = empty(normalizedOptionalSuffix) ? nameBase : '${nameBase}-${normalizedOptionalSuffix}'
var locationToken = toLower(replace(location, ' ', ''))
var globalUniqueToken = take(uniqueString(subscription().id, qualifiedName, locationToken), 6)
var compactQualifiedName = replace(qualifiedName, '-', '')

var resourceGroupName = '${toLower(resourceGroupPrefix)}-${qualifiedName}'
var appServiceName = '${take('app-${qualifiedName}', 53)}-${globalUniqueToken}'
var appServicePlanName = take('asp-${qualifiedName}', 40)
var storageAccountName = 'st${take(compactQualifiedName, 16)}${globalUniqueToken}'
var sqlServerName = '${take('sql-${qualifiedName}', 56)}-${globalUniqueToken}'
var sqlDatabaseName = take('sqldb-${qualifiedName}', 128)
var keyVaultName = '${take('kv-${qualifiedName}', 17)}-${globalUniqueToken}'
var azureOpenAIName = '${take('aoai-${qualifiedName}', 57)}-${globalUniqueToken}'
var aiSearchName = '${take('aisearch-${qualifiedName}', 53)}-${globalUniqueToken}'
var managedIdentityName = take('mi-${qualifiedName}', 128)
var logAnalyticsWorkspaceName = take('law-${qualifiedName}', 63)
var applicationInsightsName = take('appi-${qualifiedName}', 255)
var appConfigurationName = '${take('appcfg-${qualifiedName}', 43)}-${globalUniqueToken}'

var names = {
  resourceGroup: resourceGroupName
  appService: appServiceName
  appServicePlan: appServicePlanName
  storageAccount: storageAccountName
  sqlServer: sqlServerName
  sqlDatabase: sqlDatabaseName
  keyVault: keyVaultName
  azureOpenAI: azureOpenAIName
  aiSearch: aiSearchName
  managedIdentity: managedIdentityName
  logAnalytics: logAnalyticsWorkspaceName
  applicationInsights: applicationInsightsName
  appConfiguration: appConfigurationName
}

output resourceGroupName string = resourceGroupName
output appServiceName string = appServiceName
output appServicePlanName string = appServicePlanName
output storageAccountName string = storageAccountName
output sqlServerName string = sqlServerName
output sqlDatabaseName string = sqlDatabaseName
output keyVaultName string = keyVaultName
output azureOpenAIName string = azureOpenAIName
output aiSearchName string = aiSearchName
output managedIdentityName string = managedIdentityName
output logAnalyticsWorkspaceName string = logAnalyticsWorkspaceName
output applicationInsightsName string = applicationInsightsName
output appConfigurationName string = appConfigurationName
output resourceName string = names[resourceType]
