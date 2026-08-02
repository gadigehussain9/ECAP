targetScope = 'resourceGroup'

@description('Optional lock level for the environment Resource Group.')
param lockLevel string

@description('Deployment environment name used in the lock name.')
param environment string

resource resourceGroupLock 'Microsoft.Authorization/locks@2016-09-01' = if (!empty(lockLevel)) {
  name: 'ecap-${environment}-${toLower(lockLevel)}'
  properties: {
    level: lockLevel
    notes: 'Optional ECAP environment protection lock. Remove or change through an approved infrastructure deployment.'
  }
}
