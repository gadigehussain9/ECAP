targetScope = 'subscription'

@description('Short application identifier used in ECAP resource names.')
param applicationName string

@description('Deployment environment, for example dev, qa, stage, or prod.')
param environment string

@description('Resource type prefix used to construct a resource name.')
param resourcePrefix string

var nameSuffix = '${toLower(applicationName)}-${toLower(environment)}'

output resourceGroupName string = '${resourcePrefix}-${nameSuffix}'
output logAnalyticsWorkspaceName string = 'law-${nameSuffix}'
output applicationInsightsName string = 'appi-${nameSuffix}'
