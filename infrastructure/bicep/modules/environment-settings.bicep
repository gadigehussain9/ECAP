targetScope = 'subscription'

@description('Deployment environment used to select the platform sizing profile.')
@allowed([
  'dev'
  'qa'
  'stage'
  'prod'
])
param environment string

var settings = {
  dev: {
    appServicePlanSkuName: 'P1v3'
    appServicePlanSkuTier: 'PremiumV3'
    appServicePlanInstanceCount: 1
    appServicePlanZoneRedundant: false
    storageSku: 'Standard_LRS'
    sqlDatabaseSkuName: 'GP_S_Gen5_1'
    sqlDatabaseSkuTier: 'GeneralPurpose'
    sqlDatabaseSkuFamily: 'Gen5'
    sqlDatabaseSkuCapacity: 1
    sqlDatabaseComputeModel: 'Serverless'
    sqlDatabaseAutoPauseDelayMinutes: 60
    sqlDatabaseZoneRedundant: false
    sqlBackupRetentionDays: 7
    sqlBackupStorageRedundancy: 'Local'
    azureAISearchSkuName: 'basic'
    azureAISearchReplicaCount: 1
    azureAISearchPartitionCount: 1
    azureAISearchSemanticSearch: 'free'
    azureOpenAIDeploymentCapacity: 1
    logAnalyticsRetentionInDays: 30
    applicationInsightsSamplingPercentage: 50
    applicationInsightsRetentionInDays: 30
    diagnosticSettingsEnabled: true
    diagnosticVerbosity: 'minimal'
    future: {
      privateEndpoints: false
      networkIsolation: false
      autoscaling: false
      geoReplication: false
    }
  }
  qa: {
    appServicePlanSkuName: 'P1v3'
    appServicePlanSkuTier: 'PremiumV3'
    appServicePlanInstanceCount: 1
    appServicePlanZoneRedundant: false
    storageSku: 'Standard_LRS'
    sqlDatabaseSkuName: 'GP_S_Gen5_1'
    sqlDatabaseSkuTier: 'GeneralPurpose'
    sqlDatabaseSkuFamily: 'Gen5'
    sqlDatabaseSkuCapacity: 1
    sqlDatabaseComputeModel: 'Serverless'
    sqlDatabaseAutoPauseDelayMinutes: 60
    sqlDatabaseZoneRedundant: false
    sqlBackupRetentionDays: 14
    sqlBackupStorageRedundancy: 'Local'
    azureAISearchSkuName: 'standard'
    azureAISearchReplicaCount: 1
    azureAISearchPartitionCount: 1
    azureAISearchSemanticSearch: 'free'
    azureOpenAIDeploymentCapacity: 2
    logAnalyticsRetentionInDays: 30
    applicationInsightsSamplingPercentage: 25
    applicationInsightsRetentionInDays: 30
    diagnosticSettingsEnabled: true
    diagnosticVerbosity: 'standard'
    future: {
      privateEndpoints: false
      networkIsolation: false
      autoscaling: false
      geoReplication: false
    }
  }
  stage: {
    appServicePlanSkuName: 'P2v3'
    appServicePlanSkuTier: 'PremiumV3'
    appServicePlanInstanceCount: 2
    appServicePlanZoneRedundant: true
    storageSku: 'Standard_GRS'
    sqlDatabaseSkuName: 'GP_Gen5_2'
    sqlDatabaseSkuTier: 'GeneralPurpose'
    sqlDatabaseSkuFamily: 'Gen5'
    sqlDatabaseSkuCapacity: 2
    sqlDatabaseComputeModel: 'Provisioned'
    sqlDatabaseAutoPauseDelayMinutes: -1
    sqlDatabaseZoneRedundant: true
    sqlBackupRetentionDays: 30
    sqlBackupStorageRedundancy: 'Geo'
    azureAISearchSkuName: 'standard'
    azureAISearchReplicaCount: 2
    azureAISearchPartitionCount: 1
    azureAISearchSemanticSearch: 'standard'
    azureOpenAIDeploymentCapacity: 5
    logAnalyticsRetentionInDays: 30
    applicationInsightsSamplingPercentage: 15
    applicationInsightsRetentionInDays: 30
    diagnosticSettingsEnabled: true
    diagnosticVerbosity: 'verbose'
    future: {
      privateEndpoints: false
      networkIsolation: false
      autoscaling: false
      geoReplication: false
    }
  }
  prod: {
    appServicePlanSkuName: 'P3v3'
    appServicePlanSkuTier: 'PremiumV3'
    appServicePlanInstanceCount: 3
    appServicePlanZoneRedundant: true
    storageSku: 'Standard_RAGRS'
    sqlDatabaseSkuName: 'GP_Gen5_4'
    sqlDatabaseSkuTier: 'GeneralPurpose'
    sqlDatabaseSkuFamily: 'Gen5'
    sqlDatabaseSkuCapacity: 4
    sqlDatabaseComputeModel: 'Provisioned'
    sqlDatabaseAutoPauseDelayMinutes: -1
    sqlDatabaseZoneRedundant: true
    sqlBackupRetentionDays: 35
    sqlBackupStorageRedundancy: 'Geo'
    azureAISearchSkuName: 'standard'
    azureAISearchReplicaCount: 3
    azureAISearchPartitionCount: 1
    azureAISearchSemanticSearch: 'standard'
    azureOpenAIDeploymentCapacity: 10
    logAnalyticsRetentionInDays: 90
    applicationInsightsSamplingPercentage: 10
    applicationInsightsRetentionInDays: 90
    diagnosticSettingsEnabled: true
    diagnosticVerbosity: 'verbose'
    future: {
      privateEndpoints: false
      networkIsolation: false
      autoscaling: false
      geoReplication: false
    }
  }
}

output environment string = environment
output settings object = settings[environment]
