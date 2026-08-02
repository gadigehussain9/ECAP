# ECAP Platform Security Review

## Scope

This review covers the EPIC 0 Bicep platform: Resource Group bootstrap, naming and tags, App Service, managed identity, RBAC, Storage, Azure SQL, Key Vault, App Configuration, Application Insights, Log Analytics, Azure OpenAI, Azure AI Search, networking contracts, and diagnostic settings.

## Security status

| Control | Status | Evidence |
|---|---|---|
| HTTPS-only and TLS 1.2 | Ready | App Service, Storage, and SQL enforce HTTPS/TLS settings. |
| Secretless application access | Ready | App Service uses system-assigned managed identity and Entra authentication flags. |
| RBAC and least privilege | Ready | `modules/rbac.bicep` assigns resource-scoped data-plane roles only. |
| Key Vault authorization | Ready | RBAC authorization is enabled; legacy access policies are not used. |
| Embedded secrets and API keys | Ready | No passwords, SQL logins, or service API keys are defined in Bicep parameters/settings. |
| Diagnostics | Ready | Existing monitoring and resource diagnostic modules target the shared Log Analytics workspace. |
| Public networking | Accepted limitation | Public access remains enabled for the current sprint; private networking contracts are retained for a future change. |

## Identity and RBAC

The App Service system-assigned identity is the workload identity. It receives Storage Blob Data Contributor, Key Vault Secrets User, App Configuration Data Reader, Search Index Data Contributor, and Cognitive Services OpenAI User at the individual resource scope. Azure SQL is prepared for Microsoft Entra authentication; database-contained user grants remain an application/database deployment responsibility.

## Configuration and monitoring

Endpoint settings are applied after dependent resources are deployed, preventing orchestration cycles. Application Insights and resource diagnostics use the existing monitoring layer. Health checks are configured on the App Service and are ready for future alert rules.

## Azure Policy readiness

Resources use centralized names, tags, allowed SKU parameters, allowed locations, explicit TLS values, diagnostic settings contracts, and future private endpoint placeholders. Policies are not deployed by this story. Optional Resource Group locks support `CanNotDelete` and `ReadOnly`, but the default is disabled so normal CI/CD remains functional.

## Known risks

- Public endpoints remain enabled until private endpoints, VNet Integration, and Private DNS are delivered together.
- Azure AI Search's provider type may produce a Bicep type metadata warning; deployment validation remains required.
- SQL database-contained user provisioning and future alert thresholds require workload-specific decisions.

## Recommendations

1. Use federated GitHub Actions or managed deployment identities rather than service-principal secrets.
2. Add private endpoints, VNet Integration, Private DNS, and restrictive network ACLs before production data is onboarded.
3. Add Azure Policy assignments for locations, tags, TLS, diagnostics, and approved SKUs.
4. Add action/metric alerts for App Service health, SQL failures, Key Vault access anomalies, AI throttling, and Search availability.
