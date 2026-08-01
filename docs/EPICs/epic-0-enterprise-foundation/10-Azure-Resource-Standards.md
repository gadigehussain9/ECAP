
# Azure Resource Standards
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Azure Resource Standards |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the Azure Resource Standards for the Enterprise Commerce & AI Platform (ECAP).

Its purpose is to ensure Azure resources are:

- Consistent
- Secure
- Governed
- Reusable
- Observable
- Cost Optimized
- Environment Independent

These standards apply to every Azure resource deployed by ECAP.

---

# 2. Design Principles

All Azure resources shall follow these principles:

- Infrastructure as Code
- Least Privilege
- Managed Identity First
- Secure by Default
- Observability by Default
- Environment Isolation
- Reusable Infrastructure
- Cost Awareness
- Consistent Naming
- Automated Deployment

---

# 3. Supported Azure Services

The platform currently standardizes the following services.

## Compute

- App Service
- App Service Plan

Future

- Azure Container Apps
- AKS

---

## Data

- Azure SQL Database

Future

- Cosmos DB
- Azure Database for PostgreSQL

---

## AI

- Azure OpenAI
- Azure AI Search

Future

- Azure AI Foundry
- Azure AI Content Safety
- Azure AI Document Intelligence

---

## Storage

- Storage Account

---

## Security

- Managed Identity
- Key Vault

---

## Configuration

- Azure App Configuration

---

## Monitoring

- Application Insights
- Log Analytics
- Azure Monitor

---

# 4. Resource Naming Convention

Resource names shall follow this format.

```
<resource-type>-<application>-<environment>
```

Examples

```
rg-ecap-dev

asp-ecap-dev

app-ecap-api-dev

sql-ecap-dev

kv-ecap-dev

appi-ecap-dev

law-ecap-dev

aoai-ecap-dev

aisearch-ecap-dev

stecapdev

appcfg-ecap-dev

mi-ecap-dev
```

Naming must be deterministic and environment aware.

---

# 5. Resource Group Standards

Each environment shall have a dedicated Resource Group.

Example

```
rg-ecap-dev

rg-ecap-qa

rg-ecap-stage

rg-ecap-prod
```

Resources shall never be shared across environments.

---

# 6. Location Standards

All resources within an environment should use the same Azure region unless business requirements dictate otherwise.

Preferred region:

- East US (learning)
- Central India (India deployments)
- West Europe (future expansion)

Document any regional exceptions.

---

# 7. Tagging Standards

Every Azure resource shall include the following tags.

| Tag | Example |
|-----|---------|
| Application | ECAP |
| Environment | Dev |
| Owner | Architecture |
| ManagedBy | Bicep |
| CostCenter | Engineering |
| BusinessUnit | Commerce |
| Criticality | Medium |
| CreatedBy | Azure DevOps |
| Version | 1.0.0 |

Tags are mandatory for all supported resource types.

---

# 8. App Service Standards

App Service shall:

- Use Managed Identity
- Enforce HTTPS Only
- Disable FTP deployment
- Enable Always On (where supported)
- Enable Health Check endpoint
- Send diagnostics to Application Insights

Configuration shall be externalized.

---

# 9. Azure SQL Standards

Azure SQL shall:

- Use Azure AD authentication where possible
- Enable automated backups
- Enforce TLS
- Restrict firewall rules
- Store connection information in Key Vault or App Configuration
- Apply EF Core migrations through CI/CD

No connection strings with passwords shall be committed to source control.

---

# 10. Azure OpenAI Standards

Azure OpenAI deployments shall:

- Use approved model deployments
- Record deployment names
- Version prompts
- Record model versions
- Capture token usage
- Capture latency metrics

Prompt changes require version updates and evaluation.

---

# 11. Azure AI Search Standards

Indexes shall:

- Follow naming conventions
- Use documented schemas
- Version breaking schema changes
- Record embedding model version
- Record chunking strategy

Index rebuilds should be automated where feasible.

---

# 12. Key Vault Standards

Key Vault shall:

- Store all secrets
- Restrict access using RBAC
- Use Managed Identity
- Enable soft delete
- Enable purge protection (Production)
- Log access events

Secrets shall never be stored in source control.

---

# 13. App Configuration Standards

Configuration shall include:

- Feature Flags
- Environment Settings
- Application Settings
- AI Configuration
- External Service Configuration

Secrets shall remain in Key Vault.

---

# 14. Storage Account Standards

Storage Accounts shall:

- Enforce HTTPS
- Disable public blob access unless required
- Enable diagnostic logs
- Use lifecycle management policies where appropriate
- Restrict access through RBAC

---

# 15. Managed Identity Standards

Managed Identity is the preferred authentication mechanism.

Applications should authenticate using Managed Identity for:

- Key Vault
- Azure SQL
- Storage
- Azure AI Search
- App Configuration

Avoid client secrets unless no alternative exists.

---

# 16. Monitoring Standards

All Azure resources shall send diagnostics to Log Analytics.

Application telemetry shall be sent to Application Insights.

Monitoring includes:

- Availability
- Performance
- Failures
- Dependency Calls
- AI Metrics
- Infrastructure Metrics

---

# 17. Diagnostic Settings

Where supported, enable:

- Audit Logs
- Metrics
- Resource Logs

Diagnostic data shall be retained according to the environment's retention policy.

---

# 18. RBAC Standards

Assign permissions using Azure RBAC.

Preferred assignment order:

1. Managed Identity
2. Azure AD Group
3. Service Principal (only if required)

Avoid assigning roles directly to individual users.

---

# 19. Resource Locks

Production resources should use Azure Resource Locks.

Types:

- CanNotDelete
- ReadOnly (where appropriate)

Development resources should remain unlocked to simplify experimentation.

---

# 20. Cost Optimization

Development:

- Lowest suitable SKU

QA:

- Cost-effective SKU

Stage:

- Similar to Production where practical

Production:

- Business-approved SKU

Regularly review Azure Advisor recommendations and budget alerts.

---

# 21. Backup and Recovery

Critical resources shall support:

- Automated backups
- Recovery procedures
- Infrastructure recreation via Bicep
- Database restore testing

Recovery processes should be validated periodically.

---

# 22. Compliance

Azure resources shall comply with:

- Naming Standards
- Tagging Standards
- Security Standards
- Monitoring Standards
- Bicep Standards
- CI/CD Standards

Any deviation requires an approved ADR.

---

# 23. Definition of Done

An Azure resource implementation is complete when:

- Provisioned through Bicep
- Naming conventions applied
- Mandatory tags applied
- Managed Identity configured where supported
- Diagnostic settings enabled
- RBAC assigned
- Monitoring enabled
- Documentation updated
- Successfully deployed through CI/CD

---

# 24. Future Enhancements

Future governance improvements may include:

- Azure Policy
- Management Groups
- Subscription Governance
- Landing Zones
- Private Endpoints
- Microsoft Defender for Cloud
- Azure Security Center recommendations
- Cost anomaly detection
- Policy as Code
- Resource compliance dashboards
