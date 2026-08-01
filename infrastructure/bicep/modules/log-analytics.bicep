@description('Name of the Log Analytics workspace.')
param workspaceName string

@description('Azure region for the workspace.')
param location string

@description('Workspace SKU.')
@allowed([
  'PerGB2018'
  'CapacityReservation'
])
param skuName string = 'PerGB2018'

@description('Number of days to retain workspace data.')
@minValue(30)
@maxValue(730)
param retentionInDays int = 30

@description('Whether public ingestion is enabled for this workspace.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Whether public queries are enabled for this workspace.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Standard ECAP resource tags.')
param tags object

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
    retentionInDays: retentionInDays
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
  }
}

output resourceId string = workspace.id
output name string = workspace.name
output customerId string = workspace.properties.customerId
