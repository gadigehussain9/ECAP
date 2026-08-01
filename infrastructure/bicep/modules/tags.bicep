targetScope = 'subscription'

@description('Application name used for resource governance and cost reporting.')
param application string

@description('Deployment environment.')
param environment string

@description('Resource owner or owning team.')
param owner string

@description('Infrastructure management system.')
param managedBy string

@description('Cost allocation identifier.')
param costCenter string

@description('Business unit responsible for the resource.')
param businessUnit string

@description('Business criticality classification.')
param criticality string

@description('Identity that created or deployed the resource.')
param createdBy string

@description('Version of the infrastructure contract.')
param version string

@description('Additional tags. Required ECAP tags always take precedence.')
param additionalTags object = {}

output standardTags object = union(additionalTags, {
  Application: application
  Environment: environment
  Owner: owner
  ManagedBy: managedBy
  CostCenter: costCenter
  BusinessUnit: businessUnit
  Criticality: criticality
  CreatedBy: createdBy
  Version: version
})
