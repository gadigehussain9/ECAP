# ECAP Infrastructure Validation

## Bicep validation

```powershell
az bicep build --file infrastructure/bicep/main.bicep
# az bicep build performs compiler validation; run the Bicep linter in CI if installed.
az deployment sub validate --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
az deployment sub what-if --location eastus --template-file infrastructure/bicep/main.bicep --parameters @infrastructure/bicep/environments/dev.parameters.json
```

Repeat with `qa`, `stage`, and `prod`. Review what-if for unexpected resource replacement, public network changes, role changes, and lock changes before deployment.

## Azure CLI verification

```powershell
az deployment sub show --name <deployment-name> --query properties.provisioningState -o tsv
az resource list --resource-group <resource-group> --query "[].{name:name,type:type,location:location}" -o table
az webapp identity show --resource-group <resource-group> --name <app-name>
az role assignment list --assignee <principal-id> --all --query "[].{role:roleDefinitionName,scope:scope}" -o table
az monitor diagnostic-settings list --resource <resource-id>
az group lock list --resource-group <resource-group> -o table
```

## PowerShell verification

```powershell
Get-AzSubscriptionDeployment -Name <deployment-name> | Select-Object ProvisioningState
Get-AzResource -ResourceGroupName <resource-group> | Select-Object Name, ResourceType, Location
(Get-AzWebApp -ResourceGroupName <resource-group> -Name <app-name>).Identity
Get-AzRoleAssignment -ObjectId <principal-id> | Select-Object RoleDefinitionName, Scope
Get-AzResourceLock -ResourceGroupName <resource-group>
```

## Portal checklist

- Resource Group: verify name, location, tags, and optional lock state.
- App Service: verify HTTPS-only, TLS 1.2, managed identity, health check, endpoint settings, and diagnostics.
- Storage: verify TLS 1.2, HTTPS-only, shared-key disabled, blob protection, network ACLs, and Blob Data Contributor.
- SQL: verify Entra administrator, TLS, public access decision, database encryption, backups, and contained user access.
- Key Vault: verify RBAC authorization, soft delete, purge protection in production, network decision, and audit diagnostics.
- App Configuration: verify local auth disabled, endpoint, RBAC Data Reader, and diagnostics.
- Azure OpenAI and AI Search: verify local authentication settings, endpoints, RBAC, diagnostics, and approved public/private network posture.
- Monitoring: verify Application Insights connection, Log Analytics workspace, resource diagnostics, and alert readiness.

## Security verification

Confirm that source, parameter files, generated templates, and App Service settings contain no passwords, API keys, SQL logins, access tokens, or secret-bearing connection strings. Confirm role assignments are deterministic and resource-scoped. Record any public endpoint or missing private networking as an explicit production exception.

## Validation result

The current Bicep graph compiles successfully with a non-blocking provider type metadata warning for `Microsoft.Search/searchServices@2024-06-01`. The warning does not prevent deployment but should be monitored as the Azure CLI/Bicep type registry is updated.
