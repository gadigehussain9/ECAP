targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

var azureOpenAIConfiguration = globals.azureOpenAIConfiguration

resource azureOpenAI 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: azureOpenAIConfiguration.name
  location: globals.location
  tags: globals.standardTags
  kind: 'OpenAI'
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: azureOpenAIConfiguration.skuName
  }
  properties: {
    customSubDomainName: azureOpenAIConfiguration.name
    publicNetworkAccess: azureOpenAIConfiguration.publicNetworkAccess
    networkAcls: {
      defaultAction: 'Allow'
      ipRules: []
      virtualNetworkRules: []
    }
    disableLocalAuth: azureOpenAIConfiguration.disableLocalAuth
  }
}

module chatDeployment './azure-openai-deployment.bicep' = {
  name: 'ecap-azure-openai-chat-deployment'
  params: {
    accountName: azureOpenAI.name
    deploymentName: azureOpenAIConfiguration.chatDeploymentName
    modelName: azureOpenAIConfiguration.chatModelName
    modelVersion: azureOpenAIConfiguration.chatModelVersion
    skuName: azureOpenAIConfiguration.deploymentSkuName
    capacity: azureOpenAIConfiguration.deploymentCapacity
  }
}

module embeddingDeployment './azure-openai-deployment.bicep' = {
  name: 'ecap-azure-openai-embedding-deployment'
  params: {
    accountName: azureOpenAI.name
    deploymentName: azureOpenAIConfiguration.embeddingDeploymentName
    modelName: azureOpenAIConfiguration.embeddingModelName
    modelVersion: azureOpenAIConfiguration.embeddingModelVersion
    skuName: azureOpenAIConfiguration.deploymentSkuName
    capacity: azureOpenAIConfiguration.deploymentCapacity
  }
}

resource azureOpenAIDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && globals.diagnosticSettings.enabled) {
  name: 'azure-openai-diagnostics'
  scope: azureOpenAI
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in globals.diagnosticSettings.azureOpenAILogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in globals.diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output inheritedTags object = globals.standardTags
output resourceId string = azureOpenAI.id
output name string = azureOpenAI.name
output endpoint string = azureOpenAI.properties.endpoint
output chatDeploymentName string = chatDeployment.outputs.name
output embeddingDeploymentName string = embeddingDeployment.outputs.name
