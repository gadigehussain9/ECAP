targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

@description('Optional workload principal ID used by security and configuration layers.')
param workloadPrincipalId string = ''

@description('Whether Key Vault purge protection is enabled.')
param keyVaultEnablePurgeProtection bool = false

@description('Optional subnet resource ID for an App Configuration private endpoint.')
param appConfigurationPrivateEndpointSubnetResourceId string = ''

module monitoring './monitoring.bicep' = {
  name: 'ecap-monitoring-${globals.environment}'
  params: {
    globals: globals
  }
}

module security './security.bicep' = {
  name: 'ecap-security-${globals.environment}'
  params: {
    globals: globals
    principalId: workloadPrincipalId
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    enablePurgeProtection: keyVaultEnablePurgeProtection
  }
}

module configuration './configuration.bicep' = {
  name: 'ecap-configuration-${globals.environment}'
  dependsOn: [
    security
  ]
  params: {
    globals: globals
    principalId: workloadPrincipalId
    logAnalyticsWorkspaceResourceId: monitoring.outputs.logAnalyticsWorkspaceId
    privateEndpointSubnetResourceId: appConfigurationPrivateEndpointSubnetResourceId
  }
}

module data './data.bicep' = {
  name: 'ecap-data-${globals.environment}'
  dependsOn: [
    configuration
  ]
  params: {
    globals: globals
  }
}

module ai './ai.bicep' = {
  name: 'ecap-ai-${globals.environment}'
  dependsOn: [
    data
  ]
  params: {
    globals: globals
  }
}

module compute './compute.bicep' = {
  name: 'ecap-compute-${globals.environment}'
  dependsOn: [
    ai
  ]
  params: {
    globals: globals
  }
}

module networking './networking.bicep' = {
  name: 'ecap-networking-${globals.environment}'
  dependsOn: [
    compute
  ]
  params: {
    globals: globals
  }
}

output logAnalyticsWorkspaceId string = monitoring.outputs.logAnalyticsWorkspaceId
output logAnalyticsWorkspaceName string = monitoring.outputs.logAnalyticsWorkspaceName
output logAnalyticsCustomerId string = monitoring.outputs.logAnalyticsCustomerId
output applicationInsightsId string = monitoring.outputs.applicationInsightsId
output applicationInsightsName string = monitoring.outputs.applicationInsightsName
@secure()
output applicationInsightsConnectionString string = monitoring.outputs.applicationInsightsConnectionString
output keyVaultResourceId string = security.outputs.resourceId
output keyVaultName string = security.outputs.name
output keyVaultUri string = security.outputs.vaultUri
output appConfigurationResourceId string = configuration.outputs.resourceId
output appConfigurationName string = configuration.outputs.name
output appConfigurationEndpoint string = configuration.outputs.endpoint
