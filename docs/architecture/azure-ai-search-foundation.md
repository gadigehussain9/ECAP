# Azure AI Search Foundation

## Purpose

US-017 provisions Azure AI Search as the reusable ECAP search platform for full-text, semantic, vector, hybrid, product, knowledge-base, RAG, recommendation, and agent workloads. This sprint provisions infrastructure only; no indexes, indexers, data sources, skillsets, or application authentication code are deployed.

## Architecture

The existing layered orchestration is preserved:

```text
main.bicep -> platform.bicep -> ai.bicep -> azure-ai-search.bicep
```

`ai.bicep` composes Azure OpenAI and Azure AI Search. `azure-ai-search.bicep` owns the Search service, network posture, authentication settings, tags, and diagnostics. Future index resources can be added as separate modules without redesigning this service boundary.

## Inputs

The centralized `main.bicep` and `globals.bicep` contract supports:

- `azureAISearchName` - optional explicit name; empty uses the enterprise naming module.
- `azureAISearchSkuName` - service SKU.
- `azureAISearchReplicaCount` and `azureAISearchPartitionCount` - capacity settings.
- `azureAISearchPublicNetworkAccess` - `enabled` for the current sprint or `disabled` after private networking is ready.
- `azureAISearchSemanticSearch` - `disabled`, `free`, or `standard`, subject to SKU and regional availability.
- `azureAISearchAuthOptions` - `aad` or `aadOrApiKey`; the environments use `aad`.
- `azureAISearchDisableLocalAuth` - defaults to `true` to favor Microsoft Entra ID and RBAC.

All environments provide explicit capacity, network, semantic, and authentication settings so service choices are reviewable and environment-independent.

## Outputs

The root deployment exposes:

- `azureAISearchResourceId`
- `azureAISearchName`
- `azureAISearchEndpoint`
- `azureAISearchLocation`
- `azureAISearchReplicaCount`
- `azureAISearchPartitionCount`

## Dependencies and monitoring

The module reuses shared ECAP naming, tags, globals, platform orchestration, and the Log Analytics workspace from monitoring. Diagnostic settings enable `OperationLogs`, `QueryLogs`, and `AllMetrics` through the centralized diagnostic configuration. Supported categories must be verified against the target Search API/resource provider before production deployment.

Azure OpenAI embeddings from US-016 provide the future vector-generation dependency. This story does not create vector fields or indexes; future EPIC 2 modules will own index schemas, embedding dimensions, semantic configurations, skillsets, and data-source contracts.

## Security and networking

Azure AI Search is configured for Microsoft Entra ID authentication and Azure RBAC readiness. Local API-key authentication is disabled by default. No API keys are generated, embedded, or emitted. Runtime identities should receive only the required Search data-plane roles at the narrowest scope.

Public network access and an explicit network ACL structure are configurable. Private endpoints, private DNS zones, and network restrictions are intentionally not deployed in this sprint. Future network work must validate private DNS resolution and workload connectivity before changing public access to `disabled`.

## Future search capabilities

The service boundary supports future:

- Product, inventory, knowledge, documentation, support, and AI memory indexes.
- Full-text, semantic, vector, hybrid, filtered, faceted, scored, suggested, and autocomplete queries.
- Indexers, data sources, skillsets, AI enrichment, knowledge stores, and semantic/vector configurations.
- RAG grounding with security trimming, evaluation datasets, and prompt-flow/agent orchestration.

## Validation and deployment

### Azure CLI

```bash
az bicep build --file infrastructure/bicep/main.bicep

az deployment sub validate \
  --name ecap-dev-ai-search-validation \
  --location eastus \
  --template-file infrastructure/bicep/main.bicep \
  --parameters @infrastructure/bicep/environments/dev.parameters.json

az deployment sub what-if \
  --name ecap-dev-ai-search-whatif \
  --location eastus \
  --template-file infrastructure/bicep/main.bicep \
  --parameters @infrastructure/bicep/environments/dev.parameters.json

az deployment sub create \
  --name ecap-dev-ai-search \
  --location eastus \
  --template-file infrastructure/bicep/main.bicep \
  --parameters @infrastructure/bicep/environments/dev.parameters.json
```

### PowerShell

```powershell
./infrastructure/bicep/scripts/deploy.ps1 -Environment dev
```

For a direct what-if:

```powershell
az deployment sub what-if `
  --name ecap-dev-ai-search-whatif `
  --location eastus `
  --template-file infrastructure/bicep/main.bicep `
  --parameters '@infrastructure/bicep/environments/dev.parameters.json'
```

## Azure Portal verification checklist

1. Confirm the Search service name, region, SKU, replicas, partitions, and enterprise tags.
2. Confirm public network access and network rules match the environment configuration.
3. Confirm Microsoft Entra authentication/RBAC settings and local-auth posture.
4. Confirm the endpoint is present and no API key was added to source control or outputs.
5. Confirm Diagnostic Settings target the shared Log Analytics workspace.
6. Confirm no indexes were created by US-017.
7. For future private networking, verify private endpoint and DNS resolution before disabling public access.
