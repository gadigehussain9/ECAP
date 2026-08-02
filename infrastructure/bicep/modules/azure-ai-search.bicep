targetScope = 'resourceGroup'

@description('Azure AI Search service configuration from the centralized globals object.')
param configuration object

@description('Azure region for the Search service.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  azureAISearchLogCategories: [
    'OperationLogs'
    'QueryLogs'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource searchService 'Microsoft.Search/searchServices@2024-06-01' = {
  name: configuration.name
  location: location
  tags: tags
  sku: {
    name: configuration.skuName
  }
  properties: {
    replicaCount: configuration.replicaCount
    partitionCount: configuration.partitionCount
    hostingMode: 'default'
    publicNetworkAccess: configuration.publicNetworkAccess
    networkRuleSet: {
      ipRules: []
      virtualNetworkRules: []
    }
    semanticSearch: configuration.semanticSearch
    authOptions: configuration.authOptions
    disableLocalAuth: configuration.disableLocalAuth
  }
}

resource searchDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'azure-ai-search-diagnostics'
  scope: searchService
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.azureAISearchLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output resourceId string = searchService.id
output name string = searchService.name
output endpoint string = 'https://${searchService.name}.search.windows.net'
output location string = searchService.location
output replicaCount int = searchService.properties.replicaCount
output partitionCount int = searchService.properties.partitionCount
