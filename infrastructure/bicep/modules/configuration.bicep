targetScope = 'resourceGroup'

@description('Name of the App Configuration store.')
param appConfigurationName string

@description('Azure region for the App Configuration store.')
param location string

@description('Optional workload principal ID to receive App Configuration Data Reader permissions.')
param principalId string = ''

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional subnet resource ID for a future-ready private endpoint.')
param privateEndpointSubnetResourceId string = ''

@description('Centralized ECAP governance tags passed to child resource modules.')
param tags object

module appConfiguration './app-configuration.bicep' = {
  name: 'ecap-app-configuration'
  params: {
    name: appConfigurationName
    location: location
    tags: tags
    principalId: principalId
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    privateEndpointSubnetResourceId: privateEndpointSubnetResourceId
  }
}

output endpoint string = appConfiguration.outputs.endpoint
output resourceId string = appConfiguration.outputs.resourceId
output name string = appConfiguration.outputs.name
