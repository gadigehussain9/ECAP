targetScope = 'resourceGroup'

@description('Azure OpenAI account name that owns the deployment.')
param accountName string

@description('Deployment name exposed to clients.')
param deploymentName string

@description('Azure OpenAI model name. Availability varies by region and subscription.')
param modelName string

@description('Azure OpenAI model version. Availability varies by region and subscription.')
param modelVersion string

@description('Deployment SKU name.')
@allowed([
  'GlobalStandard'
  'Standard'
])
param skuName string = 'GlobalStandard'

@description('Deployment capacity in thousands of tokens per minute.')
param capacity int = 1

resource account 'Microsoft.CognitiveServices/accounts@2024-10-01' existing = {
  name: accountName
}

resource deployment 'Microsoft.CognitiveServices/accounts/deployments@2024-10-01' = {
  name: deploymentName
  parent: account
  sku: {
    name: skuName
    capacity: capacity
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: modelName
      version: modelVersion
    }
  }
}

output name string = deployment.name
