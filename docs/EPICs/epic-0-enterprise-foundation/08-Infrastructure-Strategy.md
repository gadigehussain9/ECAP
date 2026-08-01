
# Infrastructure Strategy
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Infrastructure Strategy |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the Infrastructure Strategy for the Enterprise Commerce & AI Platform (ECAP).

The objective is to establish a repeatable, secure, scalable, and fully automated cloud infrastructure using Infrastructure as Code (IaC).

Every Azure resource shall be provisioned through Bicep templates.

Manual Azure Portal configuration is discouraged except for learning, troubleshooting, or emergency recovery.

---

# 2. Infrastructure Principles

ECAP infrastructure follows these principles.

- Infrastructure as Code
- Immutable Infrastructure
- Automation First
- Cloud Native
- Security by Design
- Reusable Modules
- Environment Isolation
- Version Controlled
- Observable by Default
- Cost Aware

---

# 3. Target Azure Architecture

The ECAP platform consists of the following logical layers.

```
Internet

        │

        ▼

Azure Front Door (Future)

        │

        ▼

API Management

        │

        ▼

App Service

        │

        ▼

Application Layer

        │

        ▼

Azure SQL Database

Azure AI Search

Azure OpenAI

Storage Account

Key Vault

App Configuration

Application Insights

Log Analytics
```

Networking enhancements such as Application Gateway, Private Endpoints, and Hub-Spoke networking are planned for future enterprise iterations.

---

# 4. Infrastructure Components

The platform infrastructure includes:

Core

- Resource Group
- Managed Identity
- Storage Account

Application

- App Service
- App Service Plan

Data

- Azure SQL Database

AI

- Azure OpenAI
- Azure AI Search

Configuration

- Azure App Configuration

Secrets

- Azure Key Vault

Monitoring

- Application Insights
- Log Analytics

Networking (Future)

- Virtual Network
- Private Endpoints
- Application Gateway
- Azure Firewall
- Front Door

---

# 5. Infrastructure Layout

```
infrastructure/

└── bicep/

    ├── main.bicep

    ├── modules/

    │      app-service.bicep

    │      app-service-plan.bicep

    │      storage-account.bicep

    │      sql.bicep

    │      key-vault.bicep

    │      app-configuration.bicep

    │      azure-openai.bicep

    │      ai-search.bicep

    │      application-insights.bicep

    │      log-analytics.bicep

    │      managed-identity.bicep

    ├── environments/

    │      dev.parameters.json

    │      qa.parameters.json

    │      stage.parameters.json

    │      prod.parameters.json

    └── scripts/
```

Each Azure resource shall have its own reusable Bicep module.

---

# 6. Deployment Model

Infrastructure deployment follows this sequence.

```
Developer

        │

        ▼

GitHub

        │

        ▼

Azure DevOps Pipeline

        │

        ▼

Bicep Validation

        │

        ▼

What-If Deployment

        │

        ▼

Infrastructure Deployment

        │

        ▼

Validation

        │

        ▼

Application Deployment
```

---

# 7. Infrastructure Layering

Infrastructure is deployed in logical layers.

Layer 1

Resource Group

Managed Identity

Log Analytics

---

Layer 2

Key Vault

Storage

App Configuration

Application Insights

---

Layer 3

Azure SQL

Azure AI Search

Azure OpenAI

---

Layer 4

App Service Plan

App Service

---

Layer 5

Application Deployment

Database Migration

AI Configuration

---

# 8. Resource Dependencies

Example dependency chain.

```
Resource Group

↓

Log Analytics

↓

Application Insights

↓

Key Vault

↓

Managed Identity

↓

App Service

↓

Application Deployment
```

Dependencies shall be expressed through Bicep rather than manual sequencing.

---

# 9. Naming Standards

Example naming convention.

```
rg-ecap-dev

asp-ecap-dev

app-ecap-api-dev

sql-ecap-dev

kv-ecap-dev

stecapdev

appi-ecap-dev

law-ecap-dev

aoai-ecap-dev

aisearch-ecap-dev

appcfg-ecap-dev

mi-ecap-dev
```

Naming shall remain consistent across environments.

---

# 10. Tagging Strategy

Every Azure resource shall include standard tags.

Required tags.

```
Application = ECAP

Environment = Dev

Owner = Architecture

CostCenter = Engineering

ManagedBy = Bicep

BusinessUnit = Commerce

Criticality = Medium
```

Tags enable governance, cost reporting, and automation.

---

# 11. Managed Identity Strategy

Applications shall authenticate using Managed Identity wherever supported.

Examples.

- Azure SQL
- Key Vault
- Storage
- Azure AI Search
- Azure App Configuration

Secrets should only be used when no Managed Identity option exists.

---

# 12. Network Strategy

Phase 1

Public endpoints

HTTPS only

Firewall rules where applicable

---

Phase 2

Virtual Network

Private Endpoints

Private DNS

Network Security Groups

Application Gateway

Front Door

Hub-Spoke Networking

---

# 13. Security Baseline

Infrastructure security includes.

- Azure RBAC
- Managed Identity
- Key Vault
- HTTPS Only
- Diagnostic Settings
- TLS
- Secure Defaults

---

# 14. Monitoring

Every resource shall send diagnostics to Log Analytics.

Application telemetry shall be sent to Application Insights.

Monitoring includes.

- Availability
- Performance
- Failures
- Dependency Calls
- AI Metrics
- Infrastructure Metrics

---

# 15. Disaster Recovery

Infrastructure recovery consists of.

- Bicep Deployment
- Database Restore
- Configuration Restore
- Application Deployment

No manual Azure Portal recreation should be required.

---

# 16. Cost Management

Infrastructure shall use appropriate SKUs.

Development

Lowest practical SKU

QA

Lower-cost SKU

Stage

Production-like where practical

Production

Business-approved SKU

Budgets and cost alerts should be configured.

---

# 17. CI/CD Integration

Infrastructure deployments are executed from Azure DevOps.

Pipeline stages.

```
Validate

↓

What-If

↓

Deploy Infrastructure

↓

Validate Resources

↓

Deploy Application

↓

Smoke Tests
```

Infrastructure deployment failures stop the pipeline.

---

# 18. Definition of Done

Infrastructure Strategy is successfully implemented when.

- Infrastructure is fully automated.
- Every Azure resource has a reusable Bicep module.
- Environment parameter files exist.
- Resource naming standards are followed.
- Tags are applied.
- Managed Identity is used where supported.
- Monitoring is enabled.
- Infrastructure is reproducible.
- No manual deployment steps are required.

---

# 19. Future Enhancements

Future infrastructure improvements include.

- Hub-Spoke Networking
- Private Endpoints
- Azure Firewall
- Azure Front Door
- Azure Traffic Manager
- Availability Zones
- Multi-Region Deployment
- Blue-Green Deployments
- Canary Releases
- Kubernetes (AKS)
- Azure Container Apps
- Terraform interoperability
