targetScope = 'resourceGroup'

@description('Centralized App Service configuration from the globals module.')
param configuration object

@description('Azure region for the App Service resources.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Application Insights connection string for platform telemetry.')
@secure()
param applicationInsightsConnectionString string = ''

@description('Azure OpenAI endpoint used by the application with managed identity authentication.')
param azureOpenAIEndpoint string = ''

@description('Azure AI Search endpoint used by the application with managed identity authentication.')
param azureAISearchEndpoint string = ''

@description('Azure SQL logical server fully qualified domain name used for Microsoft Entra authentication.')
param sqlServerFullyQualifiedDomainName string = ''

@description('Storage Blob endpoint used by the application with managed identity authentication.')
param storageBlobEndpoint string = ''

@description('Key Vault URI used for RBAC-authorized secret retrieval and future Key Vault references.')
param keyVaultUri string = ''

@description('App Configuration endpoint used with managed identity authentication.')
param appConfigurationEndpoint string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  appServiceLogCategories: [
    'AppServiceHTTPLogs'
    'AppServiceConsoleLogs'
    'AppServiceAppLogs'
    'AppServiceAuditLogs'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: configuration.planName
  location: location
  tags: tags
  kind: 'linux'
  sku: {
    name: configuration.skuName
    tier: configuration.skuTier
    capacity: configuration.instanceCount
  }
  properties: {
    reserved: true
    zoneRedundant: configuration.zoneRedundant
    perSiteScaling: configuration.perSiteScaling
  }
}

resource appService 'Microsoft.Web/sites@2024-04-01' = {
  name: configuration.appName
  location: location
  tags: tags
  kind: 'app,linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    publicNetworkAccess: configuration.publicNetworkAccess
    clientAffinityEnabled: false
    siteConfig: {
      linuxFxVersion: configuration.linuxFxVersion
      alwaysOn: configuration.alwaysOn
      healthCheckPath: configuration.healthCheckPath
      http20Enabled: configuration.http20Enabled
      minTlsVersion: configuration.minimumTlsVersion
      ftpsState: 'Disabled'
      webSocketsEnabled: configuration.webSocketsEnabled
      appSettings: [
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsightsConnectionString
        }
        {
          name: 'AzureOpenAI__Endpoint'
          value: azureOpenAIEndpoint
        }
        {
          name: 'AzureOpenAI__Authentication'
          value: 'ManagedIdentity'
        }
        {
          name: 'AzureAISearch__Endpoint'
          value: azureAISearchEndpoint
        }
        {
          name: 'AzureAISearch__Authentication'
          value: 'ManagedIdentity'
        }
        {
          name: 'AzureSql__Connection'
          value: 'Server=tcp:${sqlServerFullyQualifiedDomainName},1433;Database=${configuration.sqlDatabaseName};Encrypt=True;TrustServerCertificate=False;'
        }
        {
          name: 'AzureSql__Authentication'
          value: 'Active Directory Managed Identity'
        }
        {
          name: 'Storage__Account'
          value: storageBlobEndpoint
        }
        {
          name: 'Storage__Authentication'
          value: 'ManagedIdentity'
        }
        {
          name: 'AppConfiguration__Endpoint'
          value: appConfigurationEndpoint
        }
        {
          name: 'KeyVault__Uri'
          value: keyVaultUri
        }
        {
          name: 'KeyVault__ReferencePrefix'
          value: ''
        }
        ...configuration.additionalAppSettings
      ]
    }
  }
}

resource appServiceDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'app-service-diagnostics'
  scope: appService
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.appServiceLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output appServiceName string = appService.name
output appServiceResourceId string = appService.id
output defaultHostName string = appService.properties.defaultHostName
output managedIdentityPrincipalId string = appService.identity.principalId
output managedIdentityClientId string = appService.identity.principalId
output managedIdentityTenantId string = subscription().tenantId
output appServicePlanName string = appServicePlan.name
output appServicePlanResourceId string = appServicePlan.id
