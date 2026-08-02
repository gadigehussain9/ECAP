
# ECAP - EPIC 0 - Sprint 3 - US-019 Managed Identity & Enterprise Configuration

## Role

You are a Principal Azure Cloud Architect and Security Architect implementing the Enterprise Commerce & AI Platform (ECAP).

Generate production-quality enterprise infrastructure.

Do NOT generate tutorial code.

Reuse existing ECAP architecture, naming, monitoring, networking, and security standards.

Only implement Managed Identity, Azure RBAC integration, and enterprise configuration.

---

# Before Implementation

Review the repository.

Read:

## Enterprise Foundation

docs/EPICs/epic-0-enterprise-foundation/

## Product Catalog

docs/EPICs/epic-01-product-catalog/

## Architecture

docs/architecture/

docs/architecture/adr/

Especially review:

- Use-Bicep.md
- Use-Azure-OpenAI.md
- Use-Azure-SQL.md

## Development Standards

docs/development/

Review:

- security-standards.md
- coding-standards.md
- logging-standards.md

## AI Standards

docs/AI/

Analyze the existing implementation.

Reuse existing modules.

Do NOT rewrite working infrastructure.

---

# Business Objective

Implement enterprise authentication and configuration without secrets.

The application must securely communicate with Azure resources using Managed Identity and Azure RBAC wherever supported.

The infrastructure should eliminate hardcoded credentials and prepare the platform for production deployment.

---

# Existing Architecture

Maintain the existing layered architecture.

main.bicep

↓

platform.bicep

↓

identity.bicep

↓

rbac.bicep

Do not change orchestration.

---

# Managed Identity

Enable System Assigned Managed Identity for:

- Azure App Service

Expose:

- Principal ID
- Client ID
- Tenant ID

Outputs must be reusable by downstream modules.

---

# Azure RBAC

Assign least-privilege roles to the App Service Managed Identity.

Prepare role assignments for:

## Azure Storage

Recommended:

- Storage Blob Data Contributor

---

## Azure Key Vault

Recommended:

- Key Vault Secrets User

Use Azure RBAC.

Do not use legacy access policies unless absolutely required.

---

## Azure App Configuration

Recommended:

- App Configuration Data Reader

---

## Azure AI Search

Recommended:

- Search Index Data Contributor (or the minimum role appropriate for future indexing/querying)

---

## Azure OpenAI

Assign the minimum Azure RBAC role required for application access where supported.

---

## Azure SQL

Prepare for Microsoft Entra authentication.

Do not generate SQL logins.

Document how the application will connect using Managed Identity.

---

# Configuration

Configure App Service settings to reference:

- Azure OpenAI Endpoint
- Azure AI Search Endpoint
- Azure SQL Server
- Storage Account
- Key Vault URI
- App Configuration Endpoint
- Application Insights Connection String

Do not store secrets.

Use Key Vault references where applicable.

---

# Security

Follow ECAP security standards.

Support:

- Managed Identity
- Azure RBAC
- Microsoft Entra ID
- Key Vault references
- Secretless authentication

No passwords.

No connection strings containing credentials.

No API keys in application settings.

---

# Networking

Current Sprint:

Public networking is acceptable.

Prepare for:

- Private Endpoint integration
- VNet Integration
- Private DNS

Do not deploy them yet.

---

# Monitoring

Reuse existing monitoring modules.

Log:

- Managed Identity configuration
- Role assignment deployment
- Deployment diagnostics

---

# Outputs

Expose:

Managed Identity Principal ID

Managed Identity Client ID

Managed Identity Tenant ID

Assigned RBAC roles

Configuration Endpoints

---

# Integration

Update only where required.

Integrate with:

- app.bicep
- platform.bicep
- identity.bicep
- rbac.bicep
- main.bicep

Maintain layered architecture.

---

# Validation

Generate:

Azure CLI deployment command

PowerShell deployment command

Bicep validation command

What-If deployment command

Azure Portal verification checklist

Verification steps for:

- Managed Identity
- RBAC assignments
- Key Vault access
- App Configuration access
- Storage access
- Azure OpenAI access
- Azure AI Search access

---

# Documentation

Update documentation where required.

Document:

Purpose

Managed Identity strategy

RBAC strategy

Configuration strategy

Security considerations

Future production deployment

Do not duplicate existing documentation.

---

# Future Readiness

Design the implementation to support:

- User Assigned Managed Identities
- Multiple App Services
- Background Workers
- Function Apps
- AKS migration
- Container Apps evaluation

No redesign should be required.

---

# Deliverables

Generate:

- identity.bicep
- rbac.bicep
- Required updates to app.bicep
- Required updates to platform.bicep
- Required outputs
- Parameter updates
- Documentation updates

Reuse existing modules wherever possible.

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ ECAP Architecture Standards

✓ Azure Resource Standards

✓ Security Standards

✓ Least Privilege Access

✓ Managed Identity Best Practices

✓ Azure RBAC Best Practices

✓ Secretless Authentication

✓ Enterprise Naming

✓ Enterprise Tags

✓ Environment Independence

✓ Documentation Updated

Before generating code:

1. Explain the proposed identity architecture.
2. Explain why Managed Identity is preferred over secrets.
3. Explain every RBAC role assignment.
4. Explain how this prepares ECAP for production.
5. Explain how future microservices can reuse this implementation.

Generate production-ready enterprise infrastructure only.

Do not generate tutorial examples.
