targetScope = 'resourceGroup'

@description('App Service resource ID owning the system-assigned managed identity.')
param appServiceResourceId string

@description('System-assigned managed identity principal ID exposed by the App Service module.')
param principalId string

@description('System-assigned managed identity client ID exposed by the App Service module.')
param clientId string

@description('Microsoft Entra tenant ID for the deployment.')
param tenantId string = subscription().tenantId

output appServiceResourceId string = appServiceResourceId
output principalId string = principalId
output clientId string = clientId
output tenantId string = tenantId
