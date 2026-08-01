targetScope = 'resourceGroup'

@description('Name of the Key Vault.')
param keyVaultName string

@description('Azure region for the Key Vault.')
param location string

@description('Optional system-assigned managed identity principal ID for RBAC.')
param principalId string = ''

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Whether purge protection is enabled on the Key Vault.')
param enablePurgeProtection bool = false

@description('Centralized ECAP governance tags passed to child resource modules.')
param tags object

module keyVault './key-vault.bicep' = {
  name: 'ecap-key-vault'
  params: {
    name: keyVaultName
    location: location
    tags: tags
    principalId: principalId
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    enablePurgeProtection: enablePurgeProtection
  }
}

output resourceId string = keyVault.outputs.resourceId
output name string = keyVault.outputs.name
output vaultUri string = keyVault.outputs.vaultUri
