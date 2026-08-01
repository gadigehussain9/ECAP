targetScope = 'resourceGroup'

@description('Centralized ECAP deployment configuration from the globals module.')
param globals object

// Networking is a future layer; resource modules will be composed here when approved.

output inheritedTags object = globals.standardTags
