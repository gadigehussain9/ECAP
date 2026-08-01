# ECAP Bicep Foundation

This directory contains the EPIC 0 Sprint 1 Azure foundation. It is the environment-independent entry point for the first infrastructure layer and follows the approved ECAP Bicep, resource naming, environment, security, and observability standards.

## Layout

```text
bicep/
├── main.bicep
├── bicepconfig.json
├── environments/
│   └── dev.parameters.json
└── modules/
    ├── application-insights.bicep
    ├── log-analytics.bicep
    ├── naming.bicep
    └── tags.bicep
```

## Architecture decisions

### Subscription-scoped entry point

`main.bicep` targets the subscription scope because an environment requires an isolated Resource Group. It creates the Resource Group and deploys the monitoring resources into it. This keeps Resource Group ownership explicit while allowing later modules to be added without changing the deployment contract.

The Resource Group name and bootstrap tags are calculated directly in `main.bicep`. Azure requires these values to be available at the start of a subscription deployment, so they cannot depend on outputs from helper modules. The naming and tagging modules are still deployed at subscription scope and their outputs are used by the downstream monitoring composition.

### Single-responsibility modules

Each module owns one concern:

- `naming.bicep` derives deterministic, environment-aware names.
- `tags.bicep` produces the mandatory ECAP governance tags.
- `log-analytics.bicep` provisions the Log Analytics workspace.
- `application-insights.bicep` provisions workspace-based Application Insights.

Modules accept resource-specific settings as parameters and return only identifiers and downstream values. Dependencies are expressed through module output references rather than artificial `dependsOn` declarations.

### Standard names and tags

Names use the approved `<resource-type>-<application>-<environment>` convention. The required tags from the Bicep and Azure Resource standards are generated centrally and applied to the Resource Group, workspace, and Application Insights resource. Additional tags are supported, while required tags take precedence over conflicting additional values.

### Monitoring design

Application Insights uses the Log Analytics workspace through `WorkspaceResourceId`, which provides a workspace-based monitoring model suitable for centralized querying and Azure Monitor integration. Retention, SKU, public network access, resource kind, and application type are parameters so the same modules can be used by Development, QA, Stage, and Production parameter files.

### Security and secret handling

No secrets are stored in this repository or in the example parameter file. The Application Insights connection string is marked as a secure output for downstream deployment composition. Deployment automation must avoid writing secure outputs to logs. Future application resources should use managed identity and external secret stores in accordance with the ECAP security standards.

### Azure Verified Module alignment

The custom modules follow the relevant Azure Verified Module practices: explicit typed parameters, descriptions, allowed values, validation constraints, standard tags, minimal outputs, implicit dependencies, and secure output handling. Custom modules are used for this sprint because the repository has not selected pinned Azure Verified Module registry versions. Resource modules can be replaced with pinned AVM modules later without changing the environment parameter contract.

## Validation

From the repository root:

```powershell
az bicep build --file infrastructure/bicep/main.bicep
```

To validate the subscription deployment without changing Azure resources:

```powershell
az deployment sub validate `
  --location eastus `
  --template-file infrastructure/bicep/main.bicep `
  --parameters @infrastructure/bicep/environments/dev.parameters.json
```

To preview changes:

```powershell
az deployment sub what-if `
  --location eastus `
  --template-file infrastructure/bicep/main.bicep `
  --parameters @infrastructure/bicep/environments/dev.parameters.json
```

A deployment requires a subscription with permission to create Resource Groups, Log Analytics workspaces, and Application Insights components. Add QA, Stage, and Production parameter files without changing the modules.
