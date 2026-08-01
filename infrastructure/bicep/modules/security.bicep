targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Optional system-assigned managed identity principal ID for RBAC.')
param principalId string = ''

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Whether purge protection is enabled on the Key Vault.')
param enablePurgeProtection bool = false

module keyVault './key-vault.bicep' = {
  name: 'ecap-key-vault'
  params: {
    name: globals.namingOutputs.keyVaultName
    location: globals.location
    tags: globals.standardTags
    principalId: principalId
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    enablePurgeProtection: enablePurgeProtection
    diagnosticSettings: globals.diagnosticSettings
  }
}

output resourceId string = keyVault.outputs.resourceId
output name string = keyVault.outputs.name
output vaultUri string = keyVault.outputs.vaultUri
