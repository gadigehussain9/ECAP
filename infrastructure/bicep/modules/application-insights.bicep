@description('Name of the Application Insights component.')
param applicationInsightsName string

@description('Azure region for Application Insights.')
param location string

@description('Resource ID of the Log Analytics workspace used by Application Insights.')
param workspaceResourceId string

@description('Application Insights resource kind.')
@allowed([
  'web'
  'other'
])
param kind string = 'web'

@description('Application Insights application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Standard ECAP resource tags.')
param tags object

@description('Percentage of telemetry retained by adaptive sampling.')
@minValue(0)
@maxValue(100)
param samplingPercentage int = 100

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: kind
  tags: tags
  properties: {
    Application_Type: applicationType
    SamplingPercentage: samplingPercentage
    WorkspaceResourceId: workspaceResourceId
  }
}

output resourceId string = applicationInsights.id
output name string = applicationInsights.name
@secure()
output connectionString string = applicationInsights.properties.ConnectionString
