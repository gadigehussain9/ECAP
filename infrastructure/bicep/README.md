# ECAP Bicep Foundation

## Architecture review

The original subscription-scoped main.bicep created the environment Resource Group and directly composed the existing naming, tagging, Log Analytics, and Application Insights modules. The refactor retains subscription bootstrap responsibilities and delegates Resource Group composition to layer orchestrators.

The requested docs/handbook/epic-0-enterprise-foundation/ and docs/standards/ paths are absent. The authoritative sources used are docs/EPICs/epic-0-enterprise-foundation/ and docs/architecture/adr/.

## Target architecture

```text
main.bicep
  |-- naming.bicep and tags.bicep (subscription bootstrap)
  |-- Resource Group
  +-- monitoring.bicep
  |     |-- log-analytics.bicep
  |     +-- application-insights.bicep
  |-- security.bicep
  |-- configuration.bicep
  |-- data.bicep
  |-- ai.bicep
  |-- compute.bicep
  +-- networking.bicep (future)
```

Each populated orchestration module references only resource modules in its responsibility. Monitoring is the only populated layer because no approved security, configuration, data, AI, compute, or networking resource modules currently exist. The empty boundaries avoid speculative infrastructure while preserving the target architecture.

## Updated folder structure

```text
infrastructure/bicep/
|-- main.bicep
|-- bicepconfig.json
|-- environments/ (dev, qa, stage, prod parameter files)
+-- modules/ (shared helpers, orchestration modules, resource modules)
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

## Centralized naming service

`modules/naming.bicep` is the single source of truth for ECAP resource names. It accepts `applicationName`, `environment`, `location`, `optionalSuffix`, and `resourceGroupPrefix`, and exposes the following outputs:

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

`modules/tags.bicep` is the single source of truth for ECAP governance tags. The previous implementation defined the standard dictionary in both `tags.bicep` and `main.bicep`; child-resource duplication has been removed. All resource-group orchestration modules and their child resources receive `tagging.outputs.standardTags`. The Resource Group retains a deployment-start bootstrap projection because Azure does not allow subscription module outputs in its `tags` property (BCP120); that projection mirrors the centralized contract and is not a second consumer-defined tag policy.

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
