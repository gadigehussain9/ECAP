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

## Migration steps

1. Build the current and refactored main.bicep templates.
2. Run what-if for every environment parameter file.
3. Confirm Resource Group, Log Analytics, and Application Insights names, tags, locations, and settings are unchanged.
4. Deploy Development, then promote the same source through QA, Stage, and Production.
5. Keep the root template path and parameter names unchanged.
6. Add future resource modules only to their owning orchestration layer.

## Validation steps

```powershell
az bicep build --file infrastructure/bicep/main.bicep
az bicep lint --file infrastructure/bicep/main.bicep
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
```

CI/CD must gate deployment on build, lint, parameter validation, what-if, deployment, and smoke validation. Secure outputs must not be logged.

## Compatibility and scope

No resources are renamed, no API versions or monitoring settings change, and no new Azure services are added. The refactor changes only composition boundaries; future layers remain empty until their resource modules are approved.
