targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

var azureOpenAIConfiguration = globals.azureOpenAIConfiguration
var azureAISearchConfiguration = globals.azureAISearchConfiguration

module azureOpenAI './azure-openai.bicep' = {
  name: 'ecap-azure-openai-account'
  params: {
    configuration: azureOpenAIConfiguration
    location: globals.location
    tags: globals.standardTags
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: globals.diagnosticSettings
  }
}

module azureAISearch './azure-ai-search.bicep' = {
  name: 'ecap-azure-ai-search'
  params: {
    configuration: azureAISearchConfiguration
    location: globals.location
    tags: globals.standardTags
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    diagnosticSettings: globals.diagnosticSettings
  }
}

module chatDeployment './azure-openai-deployment.bicep' = {
  name: 'ecap-azure-openai-chat-deployment'
  params: {
    accountName: azureOpenAI.outputs.name
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
    accountName: azureOpenAI.outputs.name
    deploymentName: azureOpenAIConfiguration.embeddingDeploymentName
    modelName: azureOpenAIConfiguration.embeddingModelName
    modelVersion: azureOpenAIConfiguration.embeddingModelVersion
    skuName: azureOpenAIConfiguration.deploymentSkuName
    capacity: azureOpenAIConfiguration.deploymentCapacity
  }
}

output inheritedTags object = globals.standardTags
output resourceId string = azureOpenAI.outputs.resourceId
output name string = azureOpenAI.outputs.name
output endpoint string = azureOpenAI.outputs.endpoint
output location string = azureOpenAI.outputs.location
output chatDeploymentName string = chatDeployment.outputs.name
output embeddingDeploymentName string = embeddingDeployment.outputs.name
output azureAISearchResourceId string = azureAISearch.outputs.resourceId
output azureAISearchName string = azureAISearch.outputs.name
output azureAISearchEndpoint string = azureAISearch.outputs.endpoint
output azureAISearchLocation string = azureAISearch.outputs.location
output azureAISearchReplicaCount int = azureAISearch.outputs.replicaCount
output azureAISearchPartitionCount int = azureAISearch.outputs.partitionCount
