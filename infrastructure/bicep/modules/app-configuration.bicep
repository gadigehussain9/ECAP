targetScope = 'resourceGroup'

@description('Name of the App Configuration store.')
param name string

@description('Azure region for the App Configuration store.')
param location string

@description('Standard ECAP resource tags.')
param tags object

@description('Optional Log Analytics workspace resource ID for diagnostic settings.')
param logAnalyticsWorkspaceResourceId string = ''

@description('Optional subnet resource ID. When supplied, deploys a private endpoint for the store.')
param privateEndpointSubnetResourceId string = ''

@description('Centralized diagnostic settings configuration.')
param diagnosticSettings object = {
  enabled: true
  appConfigurationLogCategories: [
    'HttpRequest'
    'Audit'
  ]
  metricCategories: [
    'AllMetrics'
  ]
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: name
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  sku: {
    name: 'standard'
  }
  properties: {
    disableLocalAuth: true
    publicNetworkAccess: 'Enabled'
  }
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-09-01' = if (!empty(privateEndpointSubnetResourceId)) {
  name: '${name}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: privateEndpointSubnetResourceId
    }
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: appConfiguration.id
          groupIds: [
            'configurationStores'
          ]
        }
      }
    ]
  }
}

resource appConfigurationDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(logAnalyticsWorkspaceResourceId) && diagnosticSettings.enabled) {
  name: 'app-configuration-diagnostics'
  scope: appConfiguration
  properties: {
    workspaceId: logAnalyticsWorkspaceResourceId
    logs: [for category in diagnosticSettings.appConfigurationLogCategories: {
      category: category
      enabled: true
    }]
    metrics: [for category in diagnosticSettings.metricCategories: {
      category: category
      enabled: true
    }]
  }
}

output endpoint string = appConfiguration.properties.endpoint
output resourceId string = appConfiguration.id
output name string = appConfiguration.name
