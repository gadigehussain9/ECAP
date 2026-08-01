targetScope = 'resourceGroup'

@description('Centralized ECAP governance tags passed to child resource modules.')
param tags object

// Networking is a future layer; resource modules will be composed here when approved.

output inheritedTags object = tags
