# Azure OpenAI Foundation

## Purpose

The ECAP Azure OpenAI foundation provisions one enterprise `Microsoft.CognitiveServices/accounts` resource and reusable child deployment modules for chat and embeddings. It is the shared provider foundation for Product Catalog AI, RAG, semantic search, recommendations, and agents.

The implementation is composed through the existing subscription-scoped `main.bicep` and resource-group-scoped `platform.bicep` layers. It does not provision API keys or store secrets.

## Module contract

### Inputs

The following parameters are available on `main.bicep` and can be overridden in each environment parameter file:

- `azureOpenAIName` - optional explicit account name; empty uses the enterprise naming module.
- `azureOpenAIPublicNetworkAccess` - `Enabled` until private endpoint networking is ready, then `Disabled`.
- `azureOpenAIDisableLocalAuth` - defaults to `true`; use Microsoft Entra ID and Azure RBAC rather than API keys.
- `azureOpenAIChatDeploymentName`, `azureOpenAIChatModelName`, `azureOpenAIChatModelVersion`.
- `azureOpenAIEmbeddingDeploymentName`, `azureOpenAIEmbeddingModelName`, `azureOpenAIEmbeddingModelVersion`.
- `azureOpenAISkuName`, `azureOpenAIDeploymentSkuName`, and `azureOpenAIDeploymentCapacity`.

Model names and versions are deliberately environment parameters because Azure OpenAI model availability and deployment SKU availability vary by region and subscription.

### Outputs

The root deployment exposes:

- `azureOpenAIResourceId`
- `azureOpenAIName`
- `azureOpenAIEndpoint`
- `chatDeploymentName`
- `embeddingDeploymentName`

The account receives a system-assigned managed identity. Consumers should be granted the minimum required Azure OpenAI data-plane RBAC role through their workload identity. No API key is emitted by the template.

## Dependencies

- Shared naming and tags from `modules/globals.bicep`.
- The Log Analytics workspace from `modules/monitoring.bicep`.
- Existing platform composition in `modules/platform.bicep`.
- `Microsoft.CognitiveServices/accounts@2024-10-01` and its deployments child resource.

Diagnostic settings send Audit, RequestResponse, Trace, and AllMetrics to the shared Log Analytics workspace when `diagnosticSettingsEnabled` is true.

## Network and private endpoint transition

The account is initially public-network enabled to match the current platform network posture. The account network ACL object is explicit and is the extension point for future restrictions. After the platform private endpoint and private DNS modules are available, set `azureOpenAIPublicNetworkAccess` to `Disabled` and add the corresponding private endpoint integration without changing model deployment consumers.

## Security considerations

- Microsoft Entra ID and Azure RBAC are the preferred authentication path.
- Local authentication is disabled by default.
- The system-assigned identity supports future application workload integration.
- API keys, connection strings, and secrets are not embedded in Bicep or parameter files.
- Diagnostic request/response logging must be reviewed against data classification and retention requirements before production use.
- Model deployment names are stable application contracts; model versions remain environment-configurable for controlled upgrades.

## Validation and deployment

### Azure CLI

```bash
az deployment sub validate \
  --location eastus \
  --template-file infrastructure/bicep/main.bicep \
  --parameters @infrastructure/bicep/environments/dev.parameters.json

az deployment sub create \
  --name ecap-dev-azure-openai \
  --location eastus \
  --template-file infrastructure/bicep/main.bicep \
  --parameters @infrastructure/bicep/environments/dev.parameters.json
```

### PowerShell

The repository deployment script performs authentication, subscription, parameter, and Bicep validation before deployment:

```powershell
./infrastructure/bicep/scripts/deploy.ps1 -Environment dev
```

### Azure Portal verification checklist

1. Open the resource group for the selected environment.
2. Verify the Cognitive Services resource kind is `OpenAI`, its region matches the environment, and enterprise tags are present.
3. Verify the system-assigned managed identity is enabled.
4. Verify local authentication is disabled unless an approved exception is documented.
5. Verify the chat and embedding deployments exist with the configured model names and versions.
6. Verify the endpoint is present and no API key was added to source control or parameter files.
7. Open **Monitoring > Diagnostic settings** and verify the Azure OpenAI diagnostic setting targets the shared Log Analytics workspace.
8. Confirm network access matches the environment posture; when private endpoint networking is enabled, verify public access is disabled and private DNS resolves the endpoint.

## Future AI provider integration

The AI module exposes provider-neutral deployment outputs while keeping Azure OpenAI-specific resource creation isolated in `ai.bicep` and `azure-openai-deployment.bicep`. Future providers can be added as separate modules behind the same platform layer without rewriting existing data, monitoring, security, or compute modules.
