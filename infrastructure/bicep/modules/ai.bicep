targetScope = 'resourceGroup'

@description('Centralized ECAP governance tags passed to child resource modules.')
param tags object

// AI resource modules will be composed here as they are approved.

output inheritedTags object = tags
