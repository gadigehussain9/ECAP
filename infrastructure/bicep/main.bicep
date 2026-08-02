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

@description('Optional workload principal ID used for Key Vault and App Configuration RBAC assignments.')
param workloadPrincipalId string = ''

@description('Whether Key Vault purge protection is enabled. This cannot be disabled after it is enabled.')
param keyVaultEnablePurgeProtection bool = false

@description('Optional subnet resource ID for an App Configuration private endpoint.')
param appConfigurationPrivateEndpointSubnetResourceId string = ''

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

@description('Storage Account network ACL configuration. Keep the default open until private endpoint networking is provisioned.')
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
    workloadPrincipalId: workloadPrincipalId
    appConfigurationPrivateEndpointSubnetResourceId: appConfigurationPrivateEndpointSubnetResourceId
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
