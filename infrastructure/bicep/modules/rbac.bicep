targetScope = 'resourceGroup'

@description('Principal ID of the App Service system-assigned managed identity.')
param principalId string

@description('Storage Account name receiving Blob Data Contributor permissions.')
param storageAccountName string

@description('Key Vault resource ID receiving Secrets User permissions.')
param keyVaultName string

@description('App Configuration resource ID receiving Data Reader permissions.')
param appConfigurationName string

@description('Azure AI Search resource ID receiving Index Data Contributor permissions.')
param azureAISearchName string

@description('Azure OpenAI resource ID receiving Cognitive Services OpenAI User permissions.')
param azureOpenAIName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageAccountName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: appConfigurationName
}

resource azureAISearch 'Microsoft.Search/searchServices@2024-06-01' existing = {
  name: azureAISearchName
}

resource azureOpenAI 'Microsoft.CognitiveServices/accounts@2023-05-01' existing = {
  name: azureOpenAIName
}

var storageBlobDataContributorRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
var keyVaultSecretsUserRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
var appConfigurationDataReaderRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071')
var searchIndexDataContributorRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8ebe5a00-799e-43f5-93ac-243d3dce84a7')
var cognitiveServicesOpenAIUserRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5e0bd9bd-7b93-4f28-af87-19fc36ad61bd')

resource storageBlobDataContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(storageAccount.id, principalId, storageBlobDataContributorRoleDefinitionId)
  scope: storageAccount
  properties: {
    roleDefinitionId: storageBlobDataContributorRoleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource keyVaultSecretsUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(keyVault.id, principalId, keyVaultSecretsUserRoleDefinitionId)
  scope: keyVault
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource appConfigurationDataReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(appConfiguration.id, principalId, appConfigurationDataReaderRoleDefinitionId)
  scope: appConfiguration
  properties: {
    roleDefinitionId: appConfigurationDataReaderRoleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource searchIndexDataContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(azureAISearch.id, principalId, searchIndexDataContributorRoleDefinitionId)
  scope: azureAISearch
  properties: {
    roleDefinitionId: searchIndexDataContributorRoleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

resource cognitiveServicesOpenAIUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(azureOpenAI.id, principalId, cognitiveServicesOpenAIUserRoleDefinitionId)
  scope: azureOpenAI
  properties: {
    roleDefinitionId: cognitiveServicesOpenAIUserRoleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

output assignedRoles array = [
  'Storage Blob Data Contributor'
  'Key Vault Secrets User'
  'App Configuration Data Reader'
  'Search Index Data Contributor'
  'Cognitive Services OpenAI User'
]
