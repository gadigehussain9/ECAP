# EPIC-01: Enterprise Product Catalog

# Azure Resources

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | Azure Resources |
| Version | 1.0 |
| Status | Approved |
| Owner | Cloud Solution Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the Azure services required for the Product Catalog module.

The goal is to build a secure, scalable, cloud-native, AI-ready solution using Microsoft Azure services following the Azure Well-Architected Framework.

All infrastructure will be provisioned using Infrastructure as Code (Bicep).

---

# 2. Architecture Principles

The Azure architecture follows these principles:

- Cloud Native
- Infrastructure as Code
- Zero Trust Security
- Least Privilege Access
- High Availability
- Scalability
- Cost Optimisation
- Observability
- AI Readiness

---

# 3. High-Level Azure Architecture

```
                        Internet
                            │
                            ▼
                 Azure Front Door (Future)
                            │
                            ▼
                  Azure API Management
                            │
                            ▼
                     Azure App Service
                            │
        ┌─────────────┬─────────────┬─────────────┐
        ▼             ▼             ▼
 Azure SQL      Azure Blob     Azure Cache
  Database       Storage        for Redis
        │
        ▼
 Azure Key Vault
        │
        ▼
 Application Insights
        │
        ▼
 Azure Monitor

Future Integrations

Azure Service Bus
Azure AI Search
Azure OpenAI
Azure Cosmos DB
Event Grid
```

---

# 4. Azure Resource Inventory

| Resource | Purpose | Required |
|----------|---------|----------|
| Resource Group | Logical container | Yes |
| App Service Plan | Compute hosting | Yes |
| App Service | Host Product API | Yes |
| API Management | API Gateway | Yes |
| Azure SQL Database | Product data | Yes |
| Blob Storage | Product images | Yes |
| Key Vault | Secrets | Yes |
| Application Insights | Telemetry | Yes |
| Azure Monitor | Monitoring | Yes |
| Managed Identity | Secure authentication | Yes |
| App Configuration | Centralised configuration | Recommended |
| Redis Cache | Performance optimisation | Recommended |
| Service Bus | Asynchronous messaging | Future |
| Azure AI Search | Semantic search | Future |
| Azure OpenAI | AI capabilities | Future |
| Cosmos DB | AI workloads | Future |

---

# 5. Resource Details

## Resource Group

Purpose

Groups all Product Catalog resources.

Naming

```
rg-ecap-dev
rg-ecap-test
rg-ecap-prod
```

---

## Azure App Service

Purpose

Hosts the ASP.NET Core Product Catalog API.

Configuration

- .NET Runtime
- HTTPS Only
- Always On
- Health Checks
- Managed Identity Enabled

Scaling

- Scale Up
- Scale Out

---

## Azure API Management

Purpose

Single entry point for all APIs.

Responsibilities

- Authentication
- Authorization
- Rate Limiting
- Request Validation
- Response Transformation
- Header Manipulation
- API Versioning
- Analytics

Future

Expose AI APIs securely.

---

## Azure SQL Database

Purpose

Stores transactional Product Catalog data.

Configuration

- Automatic Backups
- Geo Restore
- Transparent Data Encryption
- Read Scale (future)

---

## Azure Blob Storage

Purpose

Stores product images and documents.

Containers

```
product-images
product-documents
```

Features

- Versioning
- Soft Delete
- Lifecycle Policies

---

## Azure Key Vault

Purpose

Securely stores:

- Connection Strings
- API Keys
- Certificates
- Secrets

Access

Managed Identity only.

---

## Application Insights

Purpose

Application telemetry.

Collects

- Requests
- Dependencies
- Exceptions
- Availability
- Performance
- Custom Events

---

## Azure Monitor

Purpose

Centralised monitoring.

Capabilities

- Alerts
- Dashboards
- Metrics
- Log Analytics

---

## Azure App Configuration

Purpose

Centralised configuration management.

Examples

- Feature Flags
- Application Settings
- Environment Configuration

---

## Azure Cache for Redis

Purpose

Improve read performance.

Candidate Data

- Categories
- Brands
- Frequently accessed products

---

# 6. Identity & Security

Authentication

Microsoft Entra ID

Authorization

Role-Based Access Control (RBAC)

Authentication between Azure resources

Managed Identity

Secret Management

Azure Key Vault

Network Security

- HTTPS Only
- TLS 1.2+
- Private Endpoints (Production)
- Firewall Rules

---

# 7. Environment Strategy

Environments

- Development
- Test
- QA
- Staging
- Production

Each environment has:

- Separate Resource Group
- Separate Database
- Separate Key Vault
- Separate Storage Account
- Separate Monitoring

---

# 8. Infrastructure as Code

Provisioning Tool

Bicep

Folder Structure

```
infra/

├── modules/

├── environments/

│      ├── dev
│      ├── test
│      ├── qa
│      ├── stage
│      └── prod

└── main.bicep
```

Infrastructure should be fully repeatable.

---

# 9. Monitoring Strategy

Application Insights

Tracks

- API response times
- Failures
- Exceptions
- Dependency calls
- Availability

Azure Monitor

Tracks

- CPU
- Memory
- Disk
- Network
- Alerts

---

# 10. Logging Strategy

Every request should include:

- Correlation ID
- Request ID
- User ID
- Timestamp
- Environment
- Service Name

Logs should be searchable using KQL.

---

# 11. Backup & Disaster Recovery

Azure SQL

- Automated Backups
- Point-in-Time Restore

Blob Storage

- Soft Delete
- Versioning

Key Vault

- Soft Delete
- Purge Protection

---

# 12. Cost Optimisation

Development

- Lower SKU
- Auto Shutdown (where applicable)

Production

- Autoscaling
- Reserved Capacity (where appropriate)
- Cost Alerts
- Budget Monitoring

---

# 13. Future AI Architecture

Future Azure services

Azure OpenAI

Purpose

- Product Description Generation
- AI Shopping Assistant
- Chat Experience

Azure AI Search

Purpose

- Semantic Search
- Hybrid Search
- Vector Search

Azure Cosmos DB

Purpose

- AI conversation history
- Session storage
- Flexible documents

Azure Service Bus

Purpose

- Event-driven integration

---

# 14. Azure Resource Dependencies

```
API Management

        │

        ▼

App Service

        │

        ├──────── Azure SQL

        ├──────── Blob Storage

        ├──────── Key Vault

        ├──────── Redis

        ├──────── App Configuration

        └──────── Application Insights
```

---

# 15. Naming Standards

| Resource | Example |
|----------|---------|
| Resource Group | rg-ecap-dev |
| App Service | app-ecap-product-dev |
| App Service Plan | asp-ecap-dev |
| SQL Server | sql-ecap-dev |
| SQL Database | sqldb-product-dev |
| Storage Account | stecapproductdev |
| Key Vault | kv-ecap-dev |
| API Management | apim-ecap-dev |
| App Configuration | appcfg-ecap-dev |
| Redis | redis-ecap-dev |

---

# 16. Traceability Matrix

| Azure Resource | Business Capability |
|---------------|---------------------|
| API Management | Secure API Gateway |
| App Service | Product API Hosting |
| Azure SQL | Product Storage |
| Blob Storage | Product Images |
| Key Vault | Secret Management |
| App Insights | Telemetry |
| Azure Monitor | Monitoring |
| Redis | Caching |
| Azure AI Search | Semantic Search (Future) |
| Azure OpenAI | AI Features (Future) |

---

# 17. Azure Well-Architected Alignment

| Pillar | Implementation |
|---------|----------------|
| Reliability | Health Checks, Backups, Geo Restore |
| Security | Entra ID, RBAC, Managed Identity, Key Vault |
| Cost Optimisation | Right-sized SKUs, Autoscaling, Budgets |
| Operational Excellence | Bicep, Monitoring, Alerts |
| Performance Efficiency | Redis, SQL Indexing, Scaling |

---

# 18. References

- 06-Architecture.md
- 07-Database.md
- 08-REST-API.md
- 09-CQRS.md
- 11-Security.md
