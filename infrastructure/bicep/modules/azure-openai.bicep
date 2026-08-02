targetScope = 'resourceGroup'

@description('Azure OpenAI account configuration from the centralized globals object.')
param configuration object

@description('Azure region for the Azure OpenAI account.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  azureOpenAILogCategories: [
    'Audit'
    'RequestResponse'
    'Trace'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource azureOpenAI 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: configuration.name
  location: location
  tags: tags
  kind: 'OpenAI'
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: configuration.skuName
  }
  properties: {
    customSubDomainName: configuration.name
    publicNetworkAccess: configuration.publicNetworkAccess
    networkAcls: {
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    disableLocalAuth: configuration.disableLocalAuth
  }
}

resource azureOpenAIDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'azure-openai-diagnostics'
  scope: azureOpenAI
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.azureOpenAILogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output resourceId string = azureOpenAI.id
output name string = azureOpenAI.name
output endpoint string = azureOpenAI.properties.endpoint
output location string = azureOpenAI.location
