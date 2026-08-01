targetScope = 'subscription'

@description('Short application identifier used in resource names and tags.')
param applicationName string

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

var normalizedNamingSuffix = toLower(replace(namingSuffix, ' ', '-'))
var namingBase = '${toLower(applicationName)}-${toLower(environment)}'
var qualifiedNamingBase = empty(normalizedNamingSuffix) ? namingBase : '${namingBase}-${normalizedNamingSuffix}'
var resourceGroupName = '${toLower(resourceGroupPrefix)}-${qualifiedNamingBase}'
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

module naming './modules/naming.bicep' = {
  name: 'ecap-naming-${uniqueString(subscription().id, applicationName, environment)}'
  scope: subscription()
  params: {
    applicationName: applicationName
    environment: environment
    location: location
    resourceGroupPrefix: resourceGroupPrefix
    optionalSuffix: namingSuffix
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

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: bootstrapTags
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
  params: {
    keyVaultName: naming.outputs.keyVaultName
    location: location
    principalId: workloadPrincipalId
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    enablePurgeProtection: keyVaultEnablePurgeProtection
    tags: tagging.outputs.standardTags
  }
}

module configuration './modules/configuration.bicep' = {
  name: 'ecap-configuration-${environment}'
  scope: resourceGroup
  params: {
    appConfigurationName: naming.outputs.appConfigurationName
    location: location
    principalId: workloadPrincipalId
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    privateEndpointSubnetResourceId: appConfigurationPrivateEndpointSubnetResourceId
    tags: tagging.outputs.standardTags
  }
}

module data './modules/data.bicep' = {
  name: 'ecap-data-${environment}'
  scope: resourceGroup
  params: {
    tags: tagging.outputs.standardTags
  }
}

module ai './modules/ai.bicep' = {
  name: 'ecap-ai-${environment}'
  scope: resourceGroup
  params: {
    tags: tagging.outputs.standardTags
  }
}

module compute './modules/compute.bicep' = {
  name: 'ecap-compute-${environment}'
  scope: resourceGroup
  params: {
    tags: tagging.outputs.standardTags
  }
}

module networking './modules/networking.bicep' = {
  name: 'ecap-networking-${environment}'
  scope: resourceGroup
  params: {
    tags: tagging.outputs.standardTags
  }
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
output keyVaultResourceId string = security.outputs.resourceId
output keyVaultName string = security.outputs.name
output keyVaultUri string = security.outputs.vaultUri
output appConfigurationResourceId string = configuration.outputs.resourceId
output appConfigurationName string = configuration.outputs.name
output appConfigurationEndpoint string = configuration.outputs.endpoint
