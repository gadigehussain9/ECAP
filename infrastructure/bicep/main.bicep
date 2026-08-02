targetScope = 'subscription'

@description('Short application identifier used in resource names and tags.')
param applicationName string

@description('Company or organization name used by downstream governance consumers.')
param companyName string = 'ECAP'

@description('Deployment environment, for example dev, qa, stage, or prod.')
param environment string

@description('Azure region for the environment resources.')
param location string

@description('Optional suffix applied by the centralized naming service.')
param namingSuffix string = ''

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

@description('Optional lock applied to the environment Resource Group. Leave empty by default; supported values are CanNotDelete and ReadOnly.')
@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
param resourceLockLevel string = ''

@description('ECAP project or product identifier.')
param project string = ''

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

@description('Whether Key Vault purge protection is enabled. This cannot be disabled after it is enabled.')
param keyVaultEnablePurgeProtection bool = false

@description('Optional subnet resource ID for an App Configuration private endpoint.')
param appConfigurationPrivateEndpointSubnetResourceId string = ''

@description('Whether standard diagnostic settings are enabled.')
param diagnosticSettingsEnabled bool = true

@description('App Service Plan SKU name. Premium v3 is the enterprise default.')
@allowed([
  'P1v3'
  'P2v3'
  'P3v3'
])
param appServicePlanSkuName string = 'P1v3'

@description('App Service Plan SKU tier.')
@allowed([
  'PremiumV3'
])
param appServicePlanSkuTier string = 'PremiumV3'

@description('Initial App Service Plan instance count.')
@minValue(1)
param appServicePlanInstanceCount int = 1

@description('Whether the App Service Plan uses availability zones.')
param appServicePlanZoneRedundant bool = false

@description('Whether per-site scaling is enabled on the App Service Plan.')
param appServicePlanPerSiteScaling bool = false

@description('App Service .NET runtime version, for example 10.0.')
param appServiceRuntimeVersion string = '10.0'

@description('Whether the App Service is kept warm without an incoming request.')
param appServiceAlwaysOn bool = true

@description('Health check endpoint path exposed by the hosted application.')
param appServiceHealthCheckPath string = '/health'

@description('Whether HTTP/2 is enabled for the App Service.')
param appServiceHttp20Enabled bool = true

@description('Whether WebSockets are enabled for the App Service.')
param appServiceWebSocketsEnabled bool = false

@description('Whether public network access is enabled for the App Service.')
@allowed([
  'Enabled'
  'Disabled'
])
param appServicePublicNetworkAccess string = 'Enabled'

@description('Additional non-secret App Service application settings reserved for workload integrations.')
param appServiceAdditionalAppSettings object = {}

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

@description('Storage Account network ACL configuration. Keep the default open until private endpoint networking is provisioned.')
param storageNetworkAcls object = {
  bypass: 'AzureServices'
  defaultAction: 'Allow'
  ipRules: []
  virtualNetworkRules: []
}

module resourceLock './modules/resource-lock.bicep' = if (!empty(resourceLockLevel)) {
  name: 'ecap-resource-lock-${environment}'
  scope: resourceGroup
  params: {
    lockLevel: resourceLockLevel
    environment: environment
  }
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

@description('Whether public network access to the Azure SQL logical server is enabled. Disable when Private Endpoint networking is provisioned.')
@allowed([
  'Enabled'
  'Disabled'
])
param sqlPublicNetworkAccess string = 'Enabled'

@description('Microsoft Entra administrator login/display name for Azure SQL. No SQL login credentials are used.')
param sqlAdministratorLogin string = ''

@description('Microsoft Entra administrator object ID for Azure SQL.')
param sqlAdministratorObjectId string = ''

@description('Azure SQL database SKU name, such as GP_Gen5_2 or GP_S_Gen5_1.')
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

@description('Azure OpenAI public network access mode.')
@allowed([
  'Enabled'
  'Disabled'
])
param azureOpenAIPublicNetworkAccess string = 'Enabled'

@description('Whether Azure OpenAI API key authentication is disabled.')
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

@description('Azure AI Search semantic ranking capability.')
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

var normalizedNamingSuffix = toLower(replace(namingSuffix, ' ', '-'))
var namingBase = '${toLower(applicationName)}-${toLower(environment)}'
var qualifiedNamingBase = empty(normalizedNamingSuffix) ? namingBase : '${namingBase}-${normalizedNamingSuffix}'
var resourceGroupName = '${toLower(resourceGroupPrefix)}-${qualifiedNamingBase}'
// Resource Group bootstrap tags must be calculable before subscription module outputs exist.
var bootstrapProject = empty(project) ? applicationName : project
var bootstrapRepository = empty(repository) ? applicationName : repository
var bootstrapDepartment = empty(department) ? businessUnit : department
var bootstrapSupportContact = empty(supportContact) ? owner : supportContact
var bootstrapBusinessOwner = empty(businessOwner) ? owner : businessOwner
var bootstrapTechnicalOwner = empty(technicalOwner) ? owner : technicalOwner
var bootstrapWorkload = empty(workload) ? applicationName : workload
var bootstrapTags = union(additionalTags, {
  Application: applicationName
  Environment: environment
  Owner: owner
  ManagedBy: managedBy
  CostCenter: costCenter
  BusinessUnit: businessUnit
  Criticality: criticality
  Project: bootstrapProject
  Repository: bootstrapRepository
  Department: bootstrapDepartment
  SupportContact: bootstrapSupportContact
  Lifecycle: lifecycle
  Version: infrastructureVersion
  CreatedBy: createdBy
  DataClassification: dataClassification
  Compliance: compliance
  BusinessOwner: bootstrapBusinessOwner
  TechnicalOwner: bootstrapTechnicalOwner
  Workload: bootstrapWorkload
  DeploymentDate: deploymentDate
})
module globals './modules/globals.bicep' = {
  name: 'ecap-globals-${uniqueString(subscription().id, applicationName, environment)}'
  scope: subscription()
  params: {
    environment: environment
    location: location
    applicationName: applicationName
    companyName: companyName
    project: project
    resourceGroupPrefix: resourceGroupPrefix
    namingSuffix: namingSuffix
    owner: owner
    managedBy: managedBy
    costCenter: costCenter
    businessUnit: businessUnit
    criticality: criticality
    createdBy: createdBy
    infrastructureVersion: infrastructureVersion
    additionalTags: additionalTags
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
    logAnalyticsSku: logAnalyticsSku
    logAnalyticsRetentionInDays: logAnalyticsRetentionInDays
    logAnalyticsPublicNetworkAccessForIngestion: logAnalyticsPublicNetworkAccessForIngestion
    logAnalyticsPublicNetworkAccessForQuery: logAnalyticsPublicNetworkAccessForQuery
    applicationInsightsKind: applicationInsightsKind
    applicationInsightsType: applicationInsightsType
    diagnosticSettingsEnabled: diagnosticSettingsEnabled
    storageLargeFileSharesState: storageLargeFileSharesState
    storageAllowSharedKeyAccess: storageAllowSharedKeyAccess
    storagePublicNetworkAccess: storagePublicNetworkAccess
    storageMinimumTlsVersion: storageMinimumTlsVersion
    storageNetworkAcls: storageNetworkAcls
    storageSku: storageSku
    storageBlobVersioningEnabled: storageBlobVersioningEnabled
    storageBlobSoftDeleteRetentionDays: storageBlobSoftDeleteRetentionDays
    storageContainerSoftDeleteRetentionDays: storageContainerSoftDeleteRetentionDays
    sqlPublicNetworkAccess: sqlPublicNetworkAccess
    sqlAdministratorLogin: sqlAdministratorLogin
    sqlAdministratorObjectId: sqlAdministratorObjectId
    sqlDatabaseSkuName: sqlDatabaseSkuName
    sqlDatabaseSkuTier: sqlDatabaseSkuTier
    sqlDatabaseSkuFamily: sqlDatabaseSkuFamily
    sqlDatabaseSkuCapacity: sqlDatabaseSkuCapacity
    sqlDatabaseComputeModel: sqlDatabaseComputeModel
    sqlDatabaseAutoPauseDelayMinutes: sqlDatabaseAutoPauseDelayMinutes
    sqlDatabaseZoneRedundant: sqlDatabaseZoneRedundant
    sqlBackupRetentionDays: sqlBackupRetentionDays
    sqlDifferentialBackupIntervalHours: sqlDifferentialBackupIntervalHours
    sqlBackupStorageRedundancy: sqlBackupStorageRedundancy
    allowedLocations: allowedLocations
    featureFlags: featureFlags
    azureOpenAIName: azureOpenAIName
    azureOpenAIPublicNetworkAccess: azureOpenAIPublicNetworkAccess
    azureOpenAIDisableLocalAuth: azureOpenAIDisableLocalAuth
    azureOpenAIChatDeploymentName: azureOpenAIChatDeploymentName
    azureOpenAIChatModelName: azureOpenAIChatModelName
    azureOpenAIChatModelVersion: azureOpenAIChatModelVersion
    azureOpenAIEmbeddingDeploymentName: azureOpenAIEmbeddingDeploymentName
    azureOpenAIEmbeddingModelName: azureOpenAIEmbeddingModelName
    azureOpenAIEmbeddingModelVersion: azureOpenAIEmbeddingModelVersion
    azureOpenAISkuName: azureOpenAISkuName
    azureOpenAIDeploymentSkuName: azureOpenAIDeploymentSkuName
    azureOpenAIDeploymentCapacity: azureOpenAIDeploymentCapacity
    azureAISearchName: azureAISearchName
    azureAISearchSkuName: azureAISearchSkuName
    azureAISearchReplicaCount: azureAISearchReplicaCount
    azureAISearchPartitionCount: azureAISearchPartitionCount
    azureAISearchPublicNetworkAccess: azureAISearchPublicNetworkAccess
    azureAISearchSemanticSearch: azureAISearchSemanticSearch
    azureAISearchAuthOptions: azureAISearchAuthOptions
    azureAISearchDisableLocalAuth: azureAISearchDisableLocalAuth
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: bootstrapTags
}

module platform './modules/platform.bicep' = {
  name: 'ecap-platform-${environment}'
  scope: resourceGroup
  params: {
    globals: globals.outputs.globals
    keyVaultEnablePurgeProtection: keyVaultEnablePurgeProtection
    appConfigurationPrivateEndpointSubnetResourceId: appConfigurationPrivateEndpointSubnetResourceId
    appServicePlanSkuName: appServicePlanSkuName
    appServicePlanSkuTier: appServicePlanSkuTier
    appServicePlanInstanceCount: appServicePlanInstanceCount
    appServicePlanZoneRedundant: appServicePlanZoneRedundant
    appServicePlanPerSiteScaling: appServicePlanPerSiteScaling
    appServiceRuntimeVersion: appServiceRuntimeVersion
    appServiceAlwaysOn: appServiceAlwaysOn
    appServiceHealthCheckPath: appServiceHealthCheckPath
    appServiceHttp20Enabled: appServiceHttp20Enabled
    appServiceWebSocketsEnabled: appServiceWebSocketsEnabled
    appServicePublicNetworkAccess: appServicePublicNetworkAccess
    appServiceAdditionalAppSettings: appServiceAdditionalAppSettings
  }
}

output resourceGroupId string = resourceGroup.id
output resourceGroupName string = resourceGroup.name
output logAnalyticsWorkspaceId string = platform.outputs.logAnalyticsWorkspaceId
output logAnalyticsWorkspaceName string = platform.outputs.logAnalyticsWorkspaceName
output logAnalyticsCustomerId string = platform.outputs.logAnalyticsCustomerId
output applicationInsightsId string = platform.outputs.applicationInsightsId
output applicationInsightsName string = platform.outputs.applicationInsightsName
@secure()
output applicationInsightsConnectionString string = platform.outputs.applicationInsightsConnectionString
output keyVaultResourceId string = platform.outputs.keyVaultResourceId
output keyVaultName string = platform.outputs.keyVaultName
output keyVaultUri string = platform.outputs.keyVaultUri
output appConfigurationResourceId string = platform.outputs.appConfigurationResourceId
output appConfigurationName string = platform.outputs.appConfigurationName
output appConfigurationEndpoint string = platform.outputs.appConfigurationEndpoint
output storageAccountName string = platform.outputs.storageAccountName
output storageAccountResourceId string = platform.outputs.storageAccountResourceId
output blobEndpoint string = platform.outputs.blobEndpoint
output queueEndpoint string = platform.outputs.queueEndpoint
output tableEndpoint string = platform.outputs.tableEndpoint
output fileEndpoint string = platform.outputs.fileEndpoint
output sqlServerName string = platform.outputs.sqlServerName
output sqlServerResourceId string = platform.outputs.sqlServerResourceId
output sqlServerFullyQualifiedDomainName string = platform.outputs.sqlServerFullyQualifiedDomainName
output sqlDatabaseName string = platform.outputs.sqlDatabaseName
output sqlDatabaseResourceId string = platform.outputs.sqlDatabaseResourceId
output appServiceName string = platform.outputs.appServiceName
output appServiceResourceId string = platform.outputs.appServiceResourceId
output appServiceDefaultHostName string = platform.outputs.appServiceDefaultHostName
output appServiceManagedIdentityPrincipalId string = platform.outputs.appServiceManagedIdentityPrincipalId
output appServiceManagedIdentityClientId string = platform.outputs.appServiceManagedIdentityClientId
output appServiceManagedIdentityTenantId string = platform.outputs.appServiceManagedIdentityTenantId
output identityPrincipalId string = platform.outputs.identityPrincipalId
output identityClientId string = platform.outputs.identityClientId
output identityTenantId string = platform.outputs.identityTenantId
output assignedRbacRoles array = platform.outputs.assignedRbacRoles
output appServicePlanName string = platform.outputs.appServicePlanName
output appServicePlanResourceId string = platform.outputs.appServicePlanResourceId
output azureOpenAIResourceId string = platform.outputs.azureOpenAIResourceId
output azureOpenAIName string = platform.outputs.azureOpenAIName
output azureOpenAIEndpoint string = platform.outputs.azureOpenAIEndpoint
output azureOpenAILocation string = platform.outputs.azureOpenAILocation
output chatDeploymentName string = platform.outputs.chatDeploymentName
output embeddingDeploymentName string = platform.outputs.embeddingDeploymentName
output azureAISearchResourceId string = platform.outputs.azureAISearchResourceId
output azureAISearchName string = platform.outputs.azureAISearchName
output azureAISearchEndpoint string = platform.outputs.azureAISearchEndpoint
output azureAISearchLocation string = platform.outputs.azureAISearchLocation
output azureAISearchReplicaCount int = platform.outputs.azureAISearchReplicaCount
output azureAISearchPartitionCount int = platform.outputs.azureAISearchPartitionCount
