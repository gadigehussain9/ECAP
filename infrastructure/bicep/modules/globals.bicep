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

@description('Whether Azure Files large file shares are enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param storageLargeFileSharesState string = 'Disabled'

@description('Whether shared key authorization is allowed for the Storage Account.')
param storageAllowSharedKeyAccess bool = false

@description('Whether public network access to the Storage Account is enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param storagePublicNetworkAccess string = 'Enabled'

@description('Minimum TLS version accepted by the Storage Account.')
@allowed([
  'TLS1_2'
])
param storageMinimumTlsVersion string = 'TLS1_2'

@description('Storage Account network ACL configuration.')
param storageNetworkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
  ipRules: []
  virtualNetworkRules: []
}

@description('Storage Account replication SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
])
param storageSku string = 'Standard_LRS'

@description('Whether Blob Service versioning is enabled.')
param storageBlobVersioningEnabled bool = true

@description('Number of days deleted blobs are retained for recovery.')
@minValue(1)
@maxValue(365)
param storageBlobSoftDeleteRetentionDays int = 30

@description('Number of days deleted containers are retained for recovery.')
@minValue(1)
@maxValue(365)
param storageContainerSoftDeleteRetentionDays int = 30

@description('Whether public network access to the Azure SQL logical server is enabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param sqlPublicNetworkAccess string = 'Enabled'

@description('Microsoft Entra administrator login/display name for Azure SQL.')
param sqlAdministratorLogin string = ''

@description('Microsoft Entra administrator object ID for Azure SQL.')
param sqlAdministratorObjectId string = ''

@description('Azure SQL database SKU name.')
param sqlDatabaseSkuName string = 'GP_Gen5_2'

@description('Azure SQL database service tier.')
param sqlDatabaseSkuTier string = 'GeneralPurpose'

@description('Azure SQL database SKU family.')
param sqlDatabaseSkuFamily string = 'Gen5'

@description('Azure SQL database vCore capacity.')
param sqlDatabaseSkuCapacity int = 2

@description('Azure SQL database compute model.')
@allowed([
  'Provisioned'
  'Serverless'
])
param sqlDatabaseComputeModel string = 'Provisioned'

@description('Idle minutes before a serverless database is paused.')
@minValue(-1)
param sqlDatabaseAutoPauseDelayMinutes int = 60

@description('Whether Azure SQL database zone redundancy is enabled.')
param sqlDatabaseZoneRedundant bool = false

@description('Point-in-time restore retention in days for Azure SQL.')
@minValue(1)
@maxValue(35)
param sqlBackupRetentionDays int = 7

@description('Differential backup interval in hours for Azure SQL.')
@allowed([
  12
  24
])
param sqlDifferentialBackupIntervalHours int = 12

@description('Requested Azure SQL backup storage redundancy.')
@allowed([
  'Local'
  'Zone'
  'Geo'
])
param sqlBackupStorageRedundancy string = 'Local'

@description('Locations approved by the platform policy. Defaults to the deployment location.')
param allowedLocations array = []

@description('Feature flags reserved for future platform capabilities.')
param featureFlags object = {}

@description('Optional Azure OpenAI resource name. Defaults to the enterprise naming module output.')
param azureOpenAIName string = ''

@description('Azure OpenAI public network access mode. Disable after private endpoint networking is provisioned.')
@allowed([
  'Enabled'
  'Disabled'
])
param azureOpenAIPublicNetworkAccess string = 'Enabled'

@description('Whether API key authentication is disabled. Microsoft Entra ID and Azure RBAC are preferred.')
param azureOpenAIDisableLocalAuth bool = true

@description('Azure OpenAI chat deployment name.')
param azureOpenAIChatDeploymentName string = 'chat'

@description('Azure OpenAI chat model name.')
param azureOpenAIChatModelName string

@description('Azure OpenAI chat model version.')
param azureOpenAIChatModelVersion string

@description('Azure OpenAI embedding deployment name.')
param azureOpenAIEmbeddingDeploymentName string = 'embeddings'

@description('Azure OpenAI embedding model name.')
param azureOpenAIEmbeddingModelName string

@description('Azure OpenAI embedding model version.')
param azureOpenAIEmbeddingModelVersion string

@description('Azure OpenAI account SKU.')
param azureOpenAISkuName string = 'S0'

@description('Azure OpenAI deployment SKU.')
@allowed([
  'GlobalStandard'
  'Standard'
])
param azureOpenAIDeploymentSkuName string = 'GlobalStandard'

@description('Azure OpenAI deployment capacity in thousands of tokens per minute.')
param azureOpenAIDeploymentCapacity int = 1

@description('Optional Azure AI Search service name. Defaults to the enterprise naming module output.')
param azureAISearchName string = ''

@description('Azure AI Search service SKU.')
param azureAISearchSkuName string = 'standard'

@description('Azure AI Search replica count.')
@minValue(1)
param azureAISearchReplicaCount int = 1

@description('Azure AI Search partition count.')
@minValue(1)
param azureAISearchPartitionCount int = 1

@description('Azure AI Search public network access mode.')
@allowed([
  'enabled'
  'disabled'
])
param azureAISearchPublicNetworkAccess string = 'enabled'

@description('Azure AI Search semantic ranking capability. Availability depends on SKU and region.')
@allowed([
  'disabled'
  'free'
  'standard'
])
param azureAISearchSemanticSearch string = 'free'

@description('Azure AI Search authentication mode.')
@allowed([
  'aad'
  'aadOrApiKey'
])
param azureAISearchAuthOptions string = 'aad'

@description('Whether Azure AI Search local API-key authentication is disabled.')
param azureAISearchDisableLocalAuth bool = true

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

var azureAISearchConfiguration = {
  name: empty(azureAISearchName) ? naming.outputs.aiSearchName : azureAISearchName
  skuName: azureAISearchSkuName
  replicaCount: azureAISearchReplicaCount
  partitionCount: azureAISearchPartitionCount
  publicNetworkAccess: azureAISearchPublicNetworkAccess
  semanticSearch: azureAISearchSemanticSearch
  authOptions: azureAISearchAuthOptions
  disableLocalAuth: azureAISearchDisableLocalAuth
}

var azureOpenAIConfiguration = {
  name: empty(azureOpenAIName) ? naming.outputs.azureOpenAIName : azureOpenAIName
  publicNetworkAccess: azureOpenAIPublicNetworkAccess
  disableLocalAuth: azureOpenAIDisableLocalAuth
  skuName: azureOpenAISkuName
  deploymentSkuName: azureOpenAIDeploymentSkuName
  deploymentCapacity: azureOpenAIDeploymentCapacity
  chatDeploymentName: azureOpenAIChatDeploymentName
  chatModelName: azureOpenAIChatModelName
  chatModelVersion: azureOpenAIChatModelVersion
  embeddingDeploymentName: azureOpenAIEmbeddingDeploymentName
  embeddingModelName: azureOpenAIEmbeddingModelName
  embeddingModelVersion: azureOpenAIEmbeddingModelVersion
}

var sqlConfiguration = {
  publicNetworkAccess: sqlPublicNetworkAccess
  administratorLogin: sqlAdministratorLogin
  administratorObjectId: sqlAdministratorObjectId
  databaseSkuName: sqlDatabaseSkuName
  databaseSkuTier: sqlDatabaseSkuTier
  databaseSkuFamily: sqlDatabaseSkuFamily
  databaseSkuCapacity: sqlDatabaseSkuCapacity
  databaseComputeModel: sqlDatabaseComputeModel
  databaseAutoPauseDelayMinutes: sqlDatabaseAutoPauseDelayMinutes
  databaseZoneRedundant: sqlDatabaseZoneRedundant
  backupRetentionDays: sqlBackupRetentionDays
  differentialBackupIntervalHours: sqlDifferentialBackupIntervalHours
  backupStorageRedundancy: sqlBackupStorageRedundancy
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
  azureAISearchLogCategories: [
    'OperationLogs'
    'QueryLogs'
  ]
  azureOpenAILogCategories: [
    'Audit'
    'RequestResponse'
    'Trace'
  ]
  appConfigurationLogCategories: [
    'HttpRequest'
    'Audit'
  ]
  storageAccountLogCategories: [
    'StorageRead'
    'StorageWrite'
    'StorageDelete'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}
var storageConfiguration = {
  sku: storageSku
  largeFileSharesState: storageLargeFileSharesState
  allowSharedKeyAccess: storageAllowSharedKeyAccess
  publicNetworkAccess: storagePublicNetworkAccess
  minimumTlsVersion: storageMinimumTlsVersion
  networkAcls: storageNetworkAcls
  privateEndpoint: {
    enabled: false
    subnetResourceId: ''
    privateDnsZoneResourceIds: []
  }
  blobVersioningEnabled: storageBlobVersioningEnabled
  blobSoftDeleteRetentionDays: storageBlobSoftDeleteRetentionDays
  containerSoftDeleteRetentionDays: storageContainerSoftDeleteRetentionDays
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
  storageConfiguration: storageConfiguration
  sqlConfiguration: sqlConfiguration
  azureOpenAIConfiguration: azureOpenAIConfiguration
  azureAISearchConfiguration: azureAISearchConfiguration
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
output storageConfiguration object = storageConfiguration
output sqlConfiguration object = sqlConfiguration
output azureOpenAIConfiguration object = azureOpenAIConfiguration
output azureAISearchConfiguration object = azureAISearchConfiguration
output allowedLocations array = effectiveAllowedLocations
output namingOutputs object = namingOutputs
output featureFlags object = featureFlags
