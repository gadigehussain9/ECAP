targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional subnet resource ID for a future-ready private endpoint.')
param privateEndpointSubnetResourceId string = ''

module appConfiguration './app-configuration.bicep' = {
  name: 'ecap-app-configuration'
  params: {
    name: globals.namingOutputs.appConfigurationName
    location: globals.location
    tags: globals.standardTags
    logAnalyticsWorkspaceResourceId: logAnalyticsWorkspaceResourceId
    privateEndpointSubnetResourceId: privateEndpointSubnetResourceId
    diagnosticSettings: globals.diagnosticSettings
  }
}

output endpoint string = appConfiguration.outputs.endpoint
output resourceId string = appConfiguration.outputs.resourceId
output name string = appConfiguration.outputs.name
