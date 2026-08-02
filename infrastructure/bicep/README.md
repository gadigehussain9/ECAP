# ECAP Bicep Foundation

## Architecture review

The original subscription-scoped main.bicep created the environment Resource Group and directly composed the existing naming, tagging, Log Analytics, and Application Insights modules. The refactor retains subscription bootstrap responsibilities and delegates Resource Group composition to layer orchestrators.

The requested docs/handbook/epic-0-enterprise-foundation/ and docs/standards/ paths are absent. The authoritative sources used are docs/EPICs/epic-0-enterprise-foundation/ and docs/architecture/adr/.

## US-014 storage architecture review

The Storage Account remains a `StorageV2` resource with HTTPS-only access,
explicit TLS 1.2, disabled public blob access, infrastructure encryption, and
shared-key access disabled by default. The Storage Account system-assigned
identity was removed because the current ECAP design uses the App Service
system-assigned identity as the workload identity and no customer-managed-key
dependency is documented. Azure RBAC should be granted to that workload
identity by the consuming workload deployment.

### Storage configuration

The root deployment retains the existing storage parameters and exposes the
following settings through the shared `storageConfiguration` object:

| Parameter | Default | Purpose |
|-----------|---------|---------|
| `storageSku` | `Standard_LRS` | Selects the allowed replication SKU: `Standard_LRS`, `Standard_GRS`, or `Standard_RAGRS`. |
| `storageMinimumTlsVersion` | `TLS1_2` | Explicitly enforces the enterprise minimum TLS version. Only `TLS1_2` is currently permitted. |
| `storageNetworkAcls` | Azure Services / Allow | Configures bypass, default action, IP rules, and virtual network rules for future network restriction. |
| `storageBlobVersioningEnabled` | `true` | Keeps prior blob versions available after overwrite. |
| `storageBlobSoftDeleteRetentionDays` | `30` | Retains deleted blobs for recovery. |
| `storageContainerSoftDeleteRetentionDays` | `30` | Retains deleted containers for recovery. |

The environment recommendations are Standard LRS for development and QA,
Standard GRS for stage, and Standard RAGRS for production. LRS is the lowest
cost option and protects against local hardware failures. GRS replicates to a
secondary region for regional disaster recovery at additional cost and with
asynchronous replication. RAGRS adds read access to the secondary region,
improving read availability during a primary-region outage, but costs more and
does not provide synchronous writes or zero data-loss recovery. Production may
use GRS when secondary read access is not a business requirement.

Blob versioning protects against accidental overwrite and application update
errors. Blob soft delete protects against accidental blob deletion, while
container soft delete protects against deletion of an entire container. These
features improve recovery capability but increase storage consumption and
should be aligned with retention, privacy, and cost policies.

Public endpoints remain enabled for this sprint. The structured storage
configuration carries network ACL settings (`bypass`, `defaultAction`, IP
rules, and virtual network rules), plus a disabled `privateEndpoint` placeholder
for a future subnet and Private DNS Zone resource contract. ACL restrictions
can therefore be introduced without changing the Storage Account module
contract. Private Endpoint and Private DNS Zone resources are intentionally not
deployed yet; the future networking layer must provision them and change public
access to disabled as part of the same controlled transition.

Lifecycle Management is intentionally not deployed. A future child resource
`Microsoft.Storage/storageAccounts/managementPolicies` can consume the same
storage account and add rules to move blobs to Cool or Archive tiers and delete
expired data. Such policies should be introduced only with workload-specific
age, prefix, and retention requirements.

### Storage validation and deployment

```powershell
# Compile and lint the complete Bicep graph.
az bicep build --file infrastructure/bicep/main.bicep

# Validate a deployment without changing Azure resources.
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json

# Preview the change set.
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json

# Deploy with Azure CLI after validation and approval.
az deployment sub create --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json

# Deploy with PowerShell after validation and approval.
New-AzSubscriptionDeployment -Location eastus -TemplateFile infrastructure/bicep/main.bicep -TemplateParameterFile infrastructure/bicep/environments/dev.parameters.json
```

Repeat validation, what-if, and deployment with the `qa`, `stage`, and `prod`
parameter files as appropriate. Verify the resulting Storage Account has the
expected SKU, TLS 1.2, HTTPS-only traffic, disabled public blob access, blob
versioning, and both soft-delete retention policies. In the Azure portal,
inspect Storage Account > Configuration for the SKU, minimum TLS version,
HTTPS-only traffic, shared-key access, and public blob access; inspect Data
protection for versioning and retention settings; and inspect Networking for
the ACL values. Do not deploy Private Endpoints or lifecycle policies as part
of this sprint.

## US-015 Azure SQL foundation

The data layer deploys a reusable Azure SQL logical server and one Azure SQL
Database using the centralized names and tags from `globals.bicep`:

```text
modules/data.bicep
  |-- sql-server.bicep
  |     |-- Microsoft.Sql/servers
  |     |-- Microsoft.Sql/servers/administrators (when Entra values are supplied)
  |     +-- Microsoft.Insights/diagnosticSettings
  +-- sql-database.bicep
        |-- Microsoft.Sql/servers/databases
        |-- backupShortTermRetentionPolicies
        |-- transparentDataEncryption (Enabled)
        +-- Microsoft.Insights/diagnosticSettings
```

### Inputs

The root deployment accepts SQL network, Microsoft Entra administrator, SKU,
compute model, zone redundancy, backup retention, and backup redundancy
parameters. Development and QA use General Purpose Serverless with local
backup storage and auto-pause; Stage and Production use provisioned compute,
zone redundancy, geo-redundant backups, and longer retention. All values can
be overridden by an environment parameter file or deployment pipeline.

`sqlAdministratorLogin` and `sqlAdministratorObjectId` are intentionally empty
in committed environment files. Supply both through a protected deployment
variable or secret store. The deployment never configures SQL authentication
credentials or commits a password.

### Outputs and dependencies

The deployment exposes `sqlServerResourceId`, `sqlServerName`,
`sqlServerFullyQualifiedDomainName`, `sqlDatabaseResourceId`, and
`sqlDatabaseName`. The SQL modules depend on the centralized globals contract,
standard tags, and the Log Analytics workspace created by the monitoring
layer. Public access is configurable and can be disabled when the future
networking layer provisions Private Endpoint and Private DNS resources.

### Validation and deployment

```powershell
# Compile the complete Bicep graph.
az bicep build --file infrastructure/bicep/main.bicep

# Validate without changing Azure resources.
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json --parameters sqlAdministratorLogin=$env:ECAP_SQL_ADMIN_LOGIN sqlAdministratorObjectId=$env:ECAP_SQL_ADMIN_OBJECT_ID

# Preview changes.
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json --parameters sqlAdministratorLogin=$env:ECAP_SQL_ADMIN_LOGIN sqlAdministratorObjectId=$env:ECAP_SQL_ADMIN_OBJECT_ID

# Deploy after validation and approval.
az deployment sub create --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json --parameters sqlAdministratorLogin=$env:ECAP_SQL_ADMIN_LOGIN sqlAdministratorObjectId=$env:ECAP_SQL_ADMIN_OBJECT_ID

# Equivalent PowerShell deployment.
New-AzSubscriptionDeployment -Location eastus -TemplateFile infrastructure/bicep/main.bicep -TemplateParameterFile infrastructure/bicep/environments/dev.parameters.json -sqlAdministratorLogin $env:ECAP_SQL_ADMIN_LOGIN -sqlAdministratorObjectId $env:ECAP_SQL_ADMIN_OBJECT_ID
```

Use `infrastructure/bicep/scripts/validate.ps1 -Environment <environment>` for
the repository's complete build, parameter, Azure validation, and What-If
workflow. Provide the Entra values through the pipeline's parameter mechanism
when running a deployment; do not place them in source control.

### Azure portal verification

- Confirm the SQL logical server name, region, standard tags, and system-assigned identity.
- Confirm Microsoft Entra administrator configuration and the expected tenant/object ID.
- Confirm minimum TLS version is 1.2 and public network access matches the environment policy.
- Confirm the database SKU, provisioned/serverless compute behavior, zone redundancy, and backup retention/storage redundancy.
- Confirm Transparent Data Encryption is enabled.
- Confirm SQL server and database diagnostic settings send logs and metrics to the shared Log Analytics workspace.
- Confirm no broad firewall rules or SQL login credentials were introduced; disable public access when Private Endpoint networking is ready.

## Target architecture

```text
main.bicep
  |-- modules/globals.bicep (subscription-scoped configuration contract)
  |     |-- modules/shared/naming.bicep
  |     +-- modules/shared/tags.bicep
  |-- Resource Group
  +-- modules/platform.bicep (Resource Group orchestration)
        |-- monitoring (globals)
        |     |-- log-analytics.bicep
        |     +-- application-insights.bicep
        |-- security (globals + monitoring workspace output)
        |     +-- key-vault.bicep (globals diagnostic settings)
        |-- configuration (globals + monitoring workspace output)
        |     +-- app-configuration.bicep (globals diagnostic settings)
        |-- data (globals)
        |-- ai (globals)
        |-- compute (globals)
        +-- networking (globals, future)
```

`globals.bicep` is the shared configuration contract for downstream layers. It
exposes environment, location, application, project, company, resource prefix,
standard tags, default SKUs, monitoring settings, diagnostic settings, allowed
locations, naming outputs, and future feature flags through one `globals` object.

The Resource Group retains a small local bootstrap tag expression in `main.bicep`.
Azure requires Resource Group properties such as `name` and `tags` to be
calculable at the start of a subscription deployment (`BCP120`), before module
outputs are available. All downstream resource and orchestration modules consume
`globals.outputs.globals`; the bootstrap expression is therefore a platform
constraint, not a second downstream configuration contract.

### Why globals improves maintainability

- **One configuration contract:** new layers consume one object instead of
  repeating location, naming, tags, and monitoring parameter lists.
- **Consistent governance:** naming and standard tags remain implemented by the
  existing shared modules and are distributed from one output.
- **Safer changes:** changing a default SKU, diagnostic category, or feature flag
  is localized to globals and its parameter file rather than many modules.
- **Clear dependencies:** Bicep output references create the dependency graph
  without artificial `dependsOn` declarations.
- **Incremental adoption:** existing child resource module contracts remain
  intact; only orchestration boundaries were refactored.

Shared utility modules are separated from Azure resource and layer-orchestration modules:

```text
infrastructure/bicep/modules/
|-- shared/
|   |-- naming.bicep
|   \-- tags.bicep
|-- monitoring.bicep
|-- security.bicep
|-- configuration.bicep
|-- data.bicep
|-- ai.bicep
|-- compute.bicep
|-- networking.bicep
\-- resource modules
```

### Shared module architecture review

`naming.bicep` and `tags.bicep` are cross-cutting utilities, not Azure resource modules. Keeping them under `modules/shared/` makes that contract explicit and prevents resource-oriented module folders from mixing deployment resources with reusable governance helpers. The modules remain parameterized, deterministic, environment-independent, and unchanged in behavior.

Shared modules improve enterprise architecture by:

- Providing one import location for cross-cutting infrastructure policies.
- Preventing duplicate naming and tagging logic across resource modules.
- Making ownership and code review boundaries clear.
- Supporting reuse by future orchestration layers without coupling them to a specific Azure resource.
- Preserving DRY, deterministic naming, mandatory tagging, and CI/CD validation requirements.

### Migration steps

1. Create `modules/shared/`.
2. Move `naming.bicep` and `tags.bicep` into that directory without changing their contracts.
3. Update imports to `./modules/shared/naming.bicep` and `./modules/shared/tags.bicep`.
4. Remove the old root utility files so duplicate implementations cannot be introduced.
5. Rebuild the Bicep entrypoint and run the deployment validation pipeline.

### Validation steps

```powershell
az bicep build --file infrastructure/bicep/main.bicep
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
```

Confirm that:

- No active Bicep source imports `./modules/naming.bicep` or `./modules/tags.bicep`.
- `main.bicep` resolves both utilities from `modules/shared/`.
- Generated names and standard tags remain unchanged for the same parameters.
- Bicep build, validation, what-if, and CI checks pass before deployment.

### Platform validation commands

Run these commands from the repository root before deployment. They validate the
entire platform graph; the build compiles templates and does not execute resource
creation locally.

```powershell
# Compile main, globals, orchestration modules, and all child resource modules.
az bicep build --file infrastructure/bicep/main.bicep

# Run repository validation for one environment.
./infrastructure/bicep/scripts/validate.ps1 -Environment dev

# Preview the ordered platform change set for one environment.
./infrastructure/bicep/scripts/whatif.ps1 -Environment dev
```

Repeat validation and What-If for `qa`, `stage`, and `prod`. Confirm each result
matches the expected layer ordering and that no unapproved resources were added
to `modules/platform.bicep`.

Each populated orchestration module references only resource modules in its responsibility. Shared utilities are referenced by the subscription entrypoint, while monitoring, security, and configuration are populated layers. The remaining empty boundaries avoid speculative infrastructure while preserving the target architecture.

## Updated folder structure

```text
infrastructure/bicep/
|-- main.bicep
|-- bicepconfig.json
|-- environments/ (dev, qa, stage, prod parameter files)
+-- modules/
    |-- globals.bicep
    |-- shared/ (naming and tags)
    +-- orchestration and resource modules
```

## Architectural decisions

1. Keep main.bicep subscription-scoped for Resource Group creation and bootstrap naming/tags.
2. Keep naming and tagging as shared cross-cutting helpers.
3. Move monitoring composition behind monitoring.bicep without rewriting working resource modules.
4. Use Resource Group scope to preserve environment isolation.
5. Do not invent resources without approved modules and parameter contracts.
6. Preserve existing root parameters and outputs to minimize breaking changes.
7. Express dependencies through output references; do not add artificial dependsOn.
8. Keep all environment differences in parameter files.
9. Keep the Resource Group bootstrap expression in `main.bicep` because Azure requires that name to be calculable at deployment start (BCP120). It mirrors the naming service's Resource Group rule; all downstream resource names come from naming outputs.
10. Use `globals.bicep` as the reusable configuration boundary for all orchestration layers.
11. Keep diagnostic categories and monitoring defaults in globals so resource modules do not duplicate policy values.

## Globals validation steps

Run the following commands from the repository root. Replace `dev` with `qa`,
`stage`, or `prod` for the other supported Azure environments.

```powershell
# Compile the complete module graph, including globals, naming, tags, and resource modules.
az bicep build --file infrastructure/bicep/main.bicep

# Run standalone Bicep analyzer rules when the standalone CLI is installed.
bicep lint --file infrastructure/bicep/main.bicep

# If the standalone CLI is unavailable, the validation script uses this build command as its analyzer fallback.
az bicep build --file infrastructure/bicep/main.bicep

# Validate Azure Resource Manager parameter binding without changing resources.
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json

# Preview the globals-driven resource graph without deploying it.
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
```

Confirm that the build has no errors, all environment parameter files still bind,
the expected naming and tags are unchanged, diagnostic settings are controlled by
the globals output, and What-If contains no unintended changes before deployment.

## Centralized naming service

`modules/shared/naming.bicep` is the single source of truth for ECAP resource names. It accepts `applicationName`, `environment`, `location`, `optionalSuffix`, and `resourceGroupPrefix`, and exposes the following outputs:

- `resourceGroupName`
- `appServiceName`
- `appServicePlanName`
- `storageAccountName`
- `sqlServerName`
- `sqlDatabaseName`
- `keyVaultName`
- `azureOpenAIName`
- `aiSearchName`
- `managedIdentityName`
- `logAnalyticsWorkspaceName`
- `applicationInsightsName`
- `appConfigurationName`
- `resourceName`, selected by the `resourceType` parameter for generic consumers

### Naming strategy and rules

1. **Normalize case.** Application, environment, suffix, and prefixes are lowercased so names are deterministic and compatible with case-insensitive Azure naming rules.
2. **Use a shared base.** Names derive from `<application>-<environment>` and optionally append a controlled suffix. This prevents resource modules from independently reconstructing names.
3. **Keep the approved visible convention.** Names use `<resource-type>-<application>-<environment>` wherever the service permits it, matching the Infrastructure and Azure Resource Standards.
4. **Use location in uniqueness.** Location participates in the `uniqueString` input so identical application/environment deployments in different regions receive deterministic, different global names without making every visible name longer.
5. **Add deterministic uniqueness only where required.** App Service, Storage Account, SQL Server, Key Vault, Azure OpenAI, AI Search, and App Configuration receive a six-character `uniqueString` token. This avoids collisions without random names.
6. **Respect Azure length and character limits.** Outputs are truncated to the service limits. Storage Account uses a compact lowercase alphanumeric form; other resources retain readable hyphenated names.
7. **Preserve existing names by default.** With an empty suffix, the existing Resource Group, Log Analytics, and Application Insights names remain `rg-ecap-dev`, `law-ecap-dev`, and `appi-ecap-dev` for the example environment.
8. **Keep suffixes explicit.** An optional suffix supports regional, workload, or migration variants without duplicating naming expressions in consuming modules.

### Example generated names

For `applicationName=ecap`, `environment=dev`, `location=eastus`, and no suffix, where `<token>` is the deterministic location-aware uniqueness token:

```text
Resource Group       rg-ecap-dev
App Service           app-ecap-dev-<token>
App Service Plan      asp-ecap-dev
Storage Account       stecapdev<token>
SQL Server            sql-ecap-dev-<token>
SQL Database          sqldb-ecap-dev
Key Vault             kv-ecap-dev-<token>
Azure OpenAI          aoai-ecap-dev-<token>
Azure AI Search       aisearch-ecap-dev-<token>
Managed Identity      mi-ecap-dev
Log Analytics         law-ecap-dev
Application Insights  appi-ecap-dev
App Configuration     appcfg-ecap-dev-<token>
```

The token is stable for the same subscription, application, environment, location, and suffix. It is not a secret and must not be treated as one.

## Sprint 2 security and configuration foundation

Sprint 2 deploys Azure Key Vault and Azure App Configuration as reusable resource modules. It deliberately does **not** deploy a standalone managed identity. Sprint 3 will enable a system-assigned identity on App Service and pass its principal ID to these modules and future Storage, SQL, and AI Search role assignments.

### Modules

| Module | Purpose | Inputs | Outputs |
| --- | --- | --- | --- |
| `modules/key-vault.bicep` | RBAC-enabled Key Vault with soft delete, configurable purge protection, and diagnostics | `name`, `location`, `tags`, optional `principalId`, optional Log Analytics resource ID, `enablePurgeProtection` | `resourceId`, `name`, `vaultUri` |
| `modules/app-configuration.bicep` | Standard App Configuration store with system-assigned identity, diagnostics, and optional private endpoint | `name`, `location`, `tags`, optional `principalId`, optional Log Analytics resource ID, optional private endpoint subnet resource ID | `endpoint`, `resourceId`, `name` |
| `modules/security.bicep` | Security layer orchestration for Key Vault | Key Vault name, location, tags, optional workload principal, diagnostics workspace, purge protection | Key Vault outputs |
| `modules/configuration.bicep` | Configuration layer orchestration for App Configuration | App Configuration name, location, tags, optional workload principal, diagnostics workspace, private endpoint subnet | App Configuration outputs |

### Security decisions

- Key Vault uses `enableRbacAuthorization: true` and an empty `accessPolicies` collection. Legacy access policies are not used because Azure RBAC provides centralized, auditable least-privilege authorization.
- When `principalId` is supplied, Key Vault receives **Key Vault Secrets User** (`4633458b-17de-408a-b874-0445c86b69e6`), allowing secret read operations without administrative permissions.
- When `principalId` is supplied, App Configuration receives **App Configuration Data Reader** (`516239f1-63e1-4d78-a4de-a74fb236a071`), allowing configuration reads without write or store-management permissions.
- Empty `principalId` skips both role assignments. This is the Sprint 2 default and prevents assigning permissions to a non-workload identity.
- Key Vault is HTTPS-only by Azure service design; all client access uses its HTTPS vault URI. Soft delete is always enabled and purge protection is configurable because it is irreversible once enabled.
- App Configuration local authentication is disabled. Its system-assigned identity is available for Azure-native integrations, while App Service becomes the primary workload identity in Sprint 3.
- App Configuration private endpoint creation is opt-in through `appConfigurationPrivateEndpointSubnetResourceId`; private DNS integration remains a networking concern for the future networking layer.

### Dependencies and outputs

The layers depend on the Resource Group, enterprise naming module, enterprise tags module, and monitoring workspace. References to naming and monitoring outputs create the required deployment ordering without artificial `dependsOn` declarations. Root outputs expose the Key Vault URI/name/ID and App Configuration endpoint/name/ID; no secrets are output.

### Deployment validation

From the repository root, validate and preview an environment deployment:

```bash
az bicep build --file infrastructure/bicep/main.bicep
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub create --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
```

PowerShell equivalents:

```powershell
az bicep build --file infrastructure/bicep/main.bicep
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub create --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
```

Replace `dev` with `qa`, `stage`, or `prod`; use the location and subscription selected by the pipeline. CI/CD should run build, validate, what-if, approval, then create, with production purge protection enabled.

### Azure Portal verification

1. Open the environment Resource Group and confirm the Key Vault and App Configuration names match the naming module outputs.
2. In Key Vault **Properties**, verify soft delete, purge protection (according to the environment file), and RBAC permission model.
3. In Key Vault **Access control (IAM)**, verify only the optional workload principal has Key Vault Secrets User when supplied.
4. In App Configuration **Identity**, verify the system-assigned identity is enabled; in **Access control (IAM)**, verify App Configuration Data Reader only when a principal was supplied.
5. In each resource's **Diagnostic settings**, verify logs and AllMetrics route to the environment Log Analytics workspace.
6. In App Configuration **Networking**, verify the optional private endpoint when a subnet parameter was supplied; otherwise confirm the resource remains public-network enabled for this sprint.

### Future extensibility

To add a resource type, add its approved prefix and constraint-specific expression in `naming.bicep`, add the corresponding typed output, and include it in the `resourceType` allow-list and lookup object. Resource modules should consume naming outputs rather than derive names locally. If a service introduces a new global uniqueness or naming restriction, update only the naming service and its validation documentation.

## Enterprise tagging framework

### Architecture review

`modules/shared/tags.bicep` is the single source of truth for ECAP governance tags. The previous implementation defined the standard dictionary in both `tags.bicep` and `main.bicep`; child-resource duplication has been removed. All resource-group orchestration modules and their child resources receive `tagging.outputs.standardTags`. The Resource Group retains a deployment-start bootstrap projection because Azure does not allow subscription module outputs in its `tags` property (BCP120); that projection mirrors the centralized

Bicep does not implicitly inherit parameters across module boundaries. ECAP implements automatic tag propagation as an explicit contract: `main.bicep` passes the governed dictionary to every orchestration module, and each orchestration module passes the same object to its child resource modules. Resource modules must accept `tags object` and apply it to every taggable resource.

### Tag dictionary

| Tag | Source/default | Governance purpose |
|---|---|---|
| Application | Existing application identifier | Identifies the platform or application for inventory and allocation. |
| Environment | Existing environment | Separates Development, QA, Stage, and Production resources. |
| Owner | Existing owner | Identifies accountable operational ownership. |
| ManagedBy | Existing management system | Identifies automation and management authority. |
| CostCenter | Existing cost allocation identifier | Enables chargeback and showback reporting. |
| BusinessUnit | Existing business unit | Supports organizational cost and inventory grouping. |
| Criticality | Existing criticality classification | Enables risk-based operations and policy decisions. |
| Project | Explicit value, otherwise Application | Groups resources under a delivery or product initiative. |
| Repository | Explicit value, otherwise Application | Links deployed infrastructure to source ownership. |
| Department | Explicit value, otherwise BusinessUnit | Supports organizational accountability and reporting. |
| SupportContact | Explicit value, otherwise Owner | Provides an operational escalation route. |
| Lifecycle | Defaults to `Active` | Supports retirement, archive, and decommission workflows. |
| Version | Existing infrastructure version | Correlates resources with the deployed infrastructure contract. |
| CreatedBy | Existing deployment identity | Records the originating deployment actor or pipeline. |
| DataClassification | Defaults to `Internal` | Drives data handling, security, and retention policy decisions. |
| Compliance | Defaults to `None` | Identifies applicable regulatory or control obligations. |
| BusinessOwner | Explicit value, otherwise Owner | Identifies business accountability for the workload. |
| TechnicalOwner | Explicit value, otherwise Owner | Identifies engineering accountability for operation. |
| Workload | Explicit value, otherwise Application | Classifies the workload for policy and cost analysis. |
| DeploymentDate | Defaults to current ISO date | Supports deployment auditing, age analysis, and lifecycle automation. |

Required/governed keys are merged after `additionalTags`, so callers can add custom metadata but cannot override ECAP governance values accidentally.

## Enterprise Storage Account

### Purpose

The data layer deploys one environment-scoped StorageV2 account as ECAP's shared foundation for Blob, Queue, Table, and File workloads. The account uses the centralized naming and tagging modules and is ready for future private endpoint integration.

### Security and observability defaults

- TLS 1.2 and HTTPS-only traffic are enforced.
- Public blob access and shared-key authorization are disabled by default.
- A system-assigned managed identity is enabled for Azure RBAC integrations.
- Infrastructure encryption and service encryption are enabled.
- Large file shares and public network access are parameterized for environment policy.
- Storage read, write, delete, and metric diagnostics are sent to the existing Log Analytics workspace when diagnostics are enabled.

### Inputs and outputs

The root template exposes `storageLargeFileSharesState`, `storageAllowSharedKeyAccess`, and `storagePublicNetworkAccess`. The module receives its name, location, and tags from `globals`; it also receives the monitoring workspace ID from the platform monitoring module.

The root deployment outputs `storageAccountName`, `storageAccountResourceId`, `blobEndpoint`, `queueEndpoint`, `tableEndpoint`, and `fileEndpoint`. No access keys, SAS tokens, or secrets are output.

### Validation and deployment

Azure CLI:

```powershell
az bicep build --file infrastructure/bicep/main.bicep
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
az deployment sub create --location eastus --template-file infrastructure/bicep/main.bicep --parameters infrastructure/bicep/environments/dev.parameters.json
```

PowerShell deployment wrapper:

```powershell
./infrastructure/bicep/scripts/deploy.ps1 -Environment dev
```

Replace `dev` with `qa`, `stage`, or `prod` and use the target subscription context. Run build, validate, and what-if before an approved deployment.

### Azure Portal verification

1. Open the environment Resource Group and confirm the Storage Account name matches the naming output.
2. In **Configuration**, verify Secure transfer required, Minimum TLS version `1.2`, Allow Blob anonymous access disabled, and Shared key access disabled unless explicitly enabled for the environment.
3. In **Data protection** and **Encryption**, verify StorageV2 encryption and infrastructure encryption.
4. In **Endpoints**, confirm Blob, Queue, Table, and File endpoints are present.
5. In **Identity**, confirm the system-assigned managed identity is enabled.
6. In **Networking**, confirm public network access matches the environment parameter and that private endpoint integration remains available for the networking layer.
7. In **Monitoring > Diagnostic settings**, confirm StorageRead, StorageWrite, StorageDelete, and AllMetrics route to Log Analytics.

### Example usage

The root deployment supplies business context once:

```bicep
module tagging './modules/tags.bicep' = {
  name: 'ecap-tags-${uniqueString(subscription().id, applicationName, environment)}'
  scope: subscription()
  params: {
    application: applicationName
    environment: environment
    owner: owner
    managedBy: managedBy
    costCenter: costCenter
    businessUnit: businessUnit
    criticality: criticality
    createdBy: createdBy
    version: infrastructureVersion
    project: project
    repository: repository
    department: department
    supportContact: supportContact
    lifecycle: lifecycle
    dataClassification: dataClassification
    compliance: compliance
    businessOwner: businessOwner
    technicalOwner: technicalOwner
    workload: workload
    deploymentDate: deploymentDate
    additionalTags: additionalTags
  }
}

resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: resourceGroupName
  location: location
  tags: bootstrapTags
}
```

An orchestration module receives and forwards the same object:

```bicep
param tags object

module resource './resource-module.bicep' = {
  name: 'resource'
  params: {
    tags: tags
  }
}
```

### Governance recommendations

- Enforce the required key set with Azure Policy `modify` or `deny` effects at the management-group or subscription scope.
- Restrict allowed values for `Environment`, `Criticality`, `Lifecycle`, `DataClassification`, and `Compliance` through policy initiatives.
- Require `CostCenter`, `BusinessUnit`, `BusinessOwner`, and `TechnicalOwner` before Production deployment.
- Use Resource Graph and Cost Management dimensions to report spend by Project, Workload, Environment, and CostCenter.
- Alert on missing or stale `SupportContact`, `DeploymentDate`, and `Lifecycle` values.
- Treat `additionalTags` as an extension point, not as a replacement for governed keys.
- Keep tag values free of secrets, credentials, personal data, and high-cardinality telemetry.

Centralized tags improve governance by making ownership, classification, compliance, and lifecycle metadata consistent across the platform. They improve cost management by enabling reliable chargeback/showback, environment filtering, workload allocation, orphan detection, and retirement automation without resource-by-resource manual classification.

### Outputs and future extensibility

The module preserves the `standardTags` object output and adds `requiredTagKeys`, an array suitable for policy and validation tooling. To add a governed tag, add one parameter, one documented fallback if applicable, one entry to `standardTags`, and one key to `requiredTagKeys`. Update the tag dictionary and policy initiative in the same change. Resource modules should not define their own ECAP tag keys.

## Migration steps

1. Build the current and refactored main.bicep templates and confirm the default monitoring names are unchanged.
2. Run what-if for every environment parameter file.
3. Confirm Resource Group, Log Analytics, and Application Insights names, tags, locations, and settings are unchanged when `namingSuffix` is empty.
4. Deploy Development, then promote the same source through QA, Stage, and Production.
5. Use `namingSuffix` only for intentional naming variants and review the resulting names against service limits.
6. Add future resource modules only to their owning orchestration layer and consume naming outputs.

## Validation steps

```powershell
az bicep build --file infrastructure/bicep/main.bicep
az bicep lint --file infrastructure/bicep/main.bicep
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
```

CI/CD must gate deployment on build, lint, parameter validation, what-if, deployment, and smoke validation. Secure outputs must not be logged.

## Compatibility and scope

With the default empty `namingSuffix`, existing Resource Group, Log Analytics, and Application Insights names remain stable. The refactor adds names for future resource types but does not provision new Azure services, change API versions, or alter monitoring settings.
