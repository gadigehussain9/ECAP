targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

// AI resource modules will be composed here as they are approved.

output inheritedTags object = globals.standardTags
