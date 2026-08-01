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

@description('ECAP project or product identifier. Defaults to the application when omitted.')
param project string = ''

@description('Source repository identifier. Defaults to the application when omitted.')
param repository string = ''

@description('Department responsible for the workload. Defaults to the business unit when omitted.')
param department string = ''

@description('Support contact or support team identifier. Defaults to the resource owner when omitted.')
param supportContact string = ''

@description('Workload lifecycle state.')
param lifecycle string = 'Active'

@description('Data classification applied to the resources.')
param dataClassification string = 'Internal'

@description('Compliance classification or applicable control framework.')
param compliance string = 'None'

@description('Business owner for the workload. Defaults to the resource owner when omitted.')
param businessOwner string = ''

@description('Technical owner for the workload. Defaults to the resource owner when omitted.')
param technicalOwner string = ''

@description('Workload classification. Defaults to the application when omitted.')
param workload string = ''

@description('Deployment date in ISO 8601 date format. Defaults to the current deployment date.')
param deploymentDate string = utcNow('yyyy-MM-dd')

@description('Additional tags. Required ECAP tags always take precedence.')
param additionalTags object = {}

var projectTag = empty(project) ? application : project
var repositoryTag = empty(repository) ? application : repository
var departmentTag = empty(department) ? businessUnit : department
var supportContactTag = empty(supportContact) ? owner : supportContact
var businessOwnerTag = empty(businessOwner) ? owner : businessOwner
var technicalOwnerTag = empty(technicalOwner) ? owner : technicalOwner
var workloadTag = empty(workload) ? application : workload

output standardTags object = union(additionalTags, {
  Application: application
  Environment: environment
  Owner: owner
  ManagedBy: managedBy
  CostCenter: costCenter
  BusinessUnit: businessUnit
  Criticality: criticality
  Project: projectTag
  Repository: repositoryTag
  Department: departmentTag
  SupportContact: supportContactTag
  Lifecycle: lifecycle
  DataClassification: dataClassification
  Compliance: compliance
  BusinessOwner: businessOwnerTag
  TechnicalOwner: technicalOwnerTag
  Workload: workloadTag
  DeploymentDate: deploymentDate
  CreatedBy: createdBy
  Version: version
})

output requiredTagKeys array = [
  'Application'
  'Environment'
  'Owner'
  'ManagedBy'
  'CostCenter'
  'BusinessUnit'
  'Criticality'
  'Project'
  'Repository'
  'Department'
  'SupportContact'
  'Lifecycle'
  'Version'
  'CreatedBy'
  'DataClassification'
  'Compliance'
  'BusinessOwner'
  'TechnicalOwner'
  'Workload'
  'DeploymentDate'
]
