targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Whether Key Vault purge protection is enabled.')
param keyVaultEnablePurgeProtection bool = false

@description('Optional subnet resource ID for an App Configuration private endpoint.')
param appConfigurationPrivateEndpointSubnetResourceId string = ''

@description('Centralized App Service configuration inherited from the selected environment profile.')
param appServiceConfiguration object

module monitoring './monitoring.bicep' = {
  name: 'ecap-monitoring-${globals.environment}'
  params: {
    globals: globals
  }
}

module app './app.bicep' = {
  name: 'ecap-app-service-${globals.environment}'
  params: {
    configuration: {
      planName: appServiceConfiguration.planName
      appName: appServiceConfiguration.appName
      skuName: appServiceConfiguration.skuName
      skuTier: appServiceConfiguration.skuTier
      instanceCount: appServiceConfiguration.instanceCount
      zoneRedundant: appServiceConfiguration.zoneRedundant
      perSiteScaling: appServiceConfiguration.perSiteScaling
      linuxFxVersion: appServiceConfiguration.linuxFxVersion
      alwaysOn: appServiceConfiguration.alwaysOn
      healthCheckPath: appServiceConfiguration.healthCheckPath
      http20Enabled: appServiceConfiguration.http20Enabled
      webSocketsEnabled: appServiceConfiguration.webSocketsEnabled
      minimumTlsVersion: appServiceConfiguration.minimumTlsVersion
      publicNetworkAccess: appServiceConfiguration.publicNetworkAccess
      additionalAppSettings: appServiceConfiguration.additionalAppSettings
      sqlDatabaseName: appServiceConfiguration.sqlDatabaseName
    }
    location: globals.location
    tags: globals.standardTags
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    applicationInsightsConnectionString: monitoring.outputs.applicationInsightsConnectionString
    diagnosticSettings: {
      enabled: globals.diagnosticSettings.enabled
      appServiceLogCategories: [
        'AppServiceHTTPLogs'
        'AppServiceConsoleLogs'
        'AppServiceAppLogs'
        'AppServiceAuditLogs'
      ]
      metricCategories: globals.diagnosticSettings.metricCategories
    }
  }
}

module identity './identity.bicep' = {
  name: 'ecap-identity-${globals.environment}'
  params: {
    appServiceResourceId: app.outputs.appServiceResourceId
    principalId: app.outputs.managedIdentityPrincipalId
    clientId: app.outputs.managedIdentityClientId
    tenantId: app.outputs.managedIdentityTenantId
  }
}

module security './security.bicep' = {
  name: 'ecap-security-${globals.environment}'
  params: {
    globals: globals
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    enablePurgeProtection: keyVaultEnablePurgeProtection
  }
}

module configuration './configuration.bicep' = {
  name: 'ecap-configuration-${globals.environment}'
  dependsOn: [
    security
  ]
  params: {
    globals: globals
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    privateEndpointSubnetResourceId: appConfigurationPrivateEndpointSubnetResourceId
  }
}

module data './data.bicep' = {
  name: 'ecap-data-${globals.environment}'
  dependsOn: [
    configuration
  ]
  params: {
    globals: globals
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
  }
}

module ai './ai.bicep' = {
  name: 'ecap-ai-${globals.environment}'
  dependsOn: [
    data
  ]
  params: {
    globals: globals
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
  }
}

module compute './compute.bicep' = {
  name: 'ecap-compute-${globals.environment}'
  dependsOn: [
    ai
  ]
  params: {
    globals: globals
  }
}

module networking './networking.bicep' = {
  name: 'ecap-networking-${globals.environment}'
  dependsOn: [
    compute
  ]
  params: {
    globals: globals
  }
}

module rbac './rbac.bicep' = {
  name: 'ecap-rbac-${globals.environment}'
  dependsOn: [
    networking
  ]
  params: {
    principalId: identity.outputs.principalId
    storageAccountName: data.outputs.storageAccountName
    keyVaultName: security.outputs.name
    appConfigurationName: configuration.outputs.name
    azureAISearchName: ai.outputs.azureAISearchName
    azureOpenAIName: ai.outputs.name
  }
}

resource appServiceSettings 'Microsoft.Web/sites/config@2024-04-01' = {
  name: '${globals.namingOutputs.appServiceName}/appsettings'
  properties: {
    APPLICATIONINSIGHTS_CONNECTION_STRING: monitoring.outputs.applicationInsightsConnectionString
    AzureOpenAI__Endpoint: ai.outputs.endpoint
    AzureOpenAI__Authentication: 'ManagedIdentity'
    AzureAISearch__Endpoint: ai.outputs.azureAISearchEndpoint
    AzureAISearch__Authentication: 'ManagedIdentity'
    AzureSql__Connection: 'Server=tcp:${data.outputs.sqlServerFullyQualifiedDomainName},1433;Database=${data.outputs.sqlDatabaseName};Encrypt=True;TrustServerCertificate=False;'
    AzureSql__Authentication: 'Active Directory Managed Identity'
    Storage__Account: data.outputs.blobEndpoint
    Storage__Authentication: 'ManagedIdentity'
    AppConfiguration__Endpoint: configuration.outputs.endpoint
    KeyVault__Uri: security.outputs.vaultUri
    KeyVault__ReferencePrefix: ''
  }
  dependsOn: [
    rbac
  ]
}

output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
output logAnalyticsWorkspaceName string = monitoring.outputs.logAnalyticsWorkspaceName
output logAnalyticsCustomerId string = monitoring.outputs.logAnalyticsCustomerId
output applicationInsightsId string = monitoring.outputs.applicationInsightsId
output applicationInsightsName string = monitoring.outputs.applicationInsightsName
@secure()
output applicationInsightsConnectionString string = monitoring.outputs.applicationInsightsConnectionString
output appServiceName string = app.outputs.appServiceName
output appServiceResourceId string = app.outputs.appServiceResourceId
output appServiceDefaultHostName string = app.outputs.defaultHostName
output appServiceManagedIdentityPrincipalId string = app.outputs.managedIdentityPrincipalId
output appServiceManagedIdentityClientId string = app.outputs.managedIdentityClientId
output appServiceManagedIdentityTenantId string = app.outputs.managedIdentityTenantId
output identityPrincipalId string = identity.outputs.principalId
output identityClientId string = identity.outputs.clientId
output identityTenantId string = identity.outputs.tenantId
output assignedRbacRoles array = rbac.outputs.assignedRoles
output appServicePlanName string = app.outputs.appServicePlanName
output appServicePlanResourceId string = app.outputs.appServicePlanResourceId
output keyVaultResourceId string = security.outputs.resourceId
output keyVaultName string = security.outputs.name
output keyVaultUri string = security.outputs.vaultUri
output appConfigurationResourceId string = configuration.outputs.resourceId
output appConfigurationName string = configuration.outputs.name
output appConfigurationEndpoint string = configuration.outputs.endpoint
output storageAccountName string = data.outputs.storageAccountName
output storageAccountResourceId string = data.outputs.storageAccountResourceId
output blobEndpoint string = data.outputs.blobEndpoint
output queueEndpoint string = data.outputs.queueEndpoint
output tableEndpoint string = data.outputs.tableEndpoint
output fileEndpoint string = data.outputs.fileEndpoint
output sqlServerName string = data.outputs.sqlServerName
output sqlServerResourceId string = data.outputs.sqlServerResourceId
output sqlServerFullyQualifiedDomainName string = data.outputs.sqlServerFullyQualifiedDomainName
output sqlDatabaseName string = data.outputs.sqlDatabaseName
output sqlDatabaseResourceId string = data.outputs.sqlDatabaseResourceId
output azureOpenAIResourceId string = ai.outputs.resourceId
output azureOpenAIName string = ai.outputs.name
output azureOpenAIEndpoint string = ai.outputs.endpoint
output azureOpenAILocation string = ai.outputs.location
output chatDeploymentName string = ai.outputs.chatDeploymentName
output embeddingDeploymentName string = ai.outputs.embeddingDeploymentName
output azureAISearchResourceId string = ai.outputs.azureAISearchResourceId
output azureAISearchName string = ai.outputs.azureAISearchName
output azureAISearchEndpoint string = ai.outputs.azureAISearchEndpoint
output azureAISearchLocation string = ai.outputs.azureAISearchLocation
output azureAISearchReplicaCount int = ai.outputs.azureAISearchReplicaCount
output azureAISearchPartitionCount int = ai.outputs.azureAISearchPartitionCount
