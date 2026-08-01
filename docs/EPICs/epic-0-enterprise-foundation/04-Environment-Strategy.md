
# Environment Strategy
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Environment Strategy |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the enterprise environment strategy for the Enterprise Commerce & AI Platform (ECAP).

It standardizes how infrastructure, applications, AI services, configuration, deployments, and monitoring are organized across multiple environments.

The objective is to ensure every environment behaves consistently while remaining independently deployable.

---

# 2. Environment Principles

The ECAP platform follows these principles:

- Every environment is isolated.
- Infrastructure is deployed using Bicep.
- Deployments are fully automated.
- Configuration is environment specific.
- Secrets are never stored in source control.
- The same application binaries are promoted through environments.
- Differences between environments are configuration only.

---

# 3. Environment Topology

The platform supports the following environments.

| Environment | Purpose |
|-------------|----------|
| Local | Developer workstation |
| Development | Daily development and integration |
| QA | Functional and regression testing |
| Stage/UAT | User acceptance and pre-production validation |
| Production | Live production environment |

---

# 4. Environment Responsibilities

## Local

Purpose

Developer productivity.

Characteristics

- Local SQL Server or Azure SQL
- Local Azurite (optional)
- Local configuration
- Debugging
- Unit testing

Infrastructure

Not deployed using Bicep.

---

## Development

Purpose

Continuous integration.

Characteristics

- Frequent deployments
- Shared environment
- Used by developers
- Automatic deployment

Infrastructure

Deployed entirely using Bicep.

---

## QA

Purpose

System testing.

Characteristics

- Integration testing
- Functional testing
- API validation
- AI validation

Infrastructure

Independent Resource Group.

---

## Stage / UAT

Purpose

Production simulation.

Characteristics

- Release candidate validation
- User acceptance testing
- Performance verification
- Deployment rehearsal

Should closely mirror Production.

---

## Production

Purpose

Serve business users.

Characteristics

- Highest availability
- Manual approval before deployment
- Monitoring enabled
- Alerts enabled
- Backup enabled

---

# 5. Azure Subscription Strategy

Recommended approach

| Environment | Subscription |
|-------------|--------------|
| Local | N/A |
| Development | Development Subscription |
| QA | QA Subscription |
| Stage | Stage Subscription |
| Production | Production Subscription |

For learning purposes a single Azure subscription may host all environments using separate Resource Groups.

---

# 6. Resource Group Strategy

Each environment owns an independent Resource Group.

Example

```
rg-ecap-dev

rg-ecap-qa

rg-ecap-stage

rg-ecap-prod
```

No resource sharing between environments.

---

# 7. Resource Naming Standards

Every Azure resource follows a predictable naming convention.

Example

```
rg-ecap-dev

kv-ecap-dev

appi-ecap-dev

log-ecap-dev

sql-ecap-dev

stecapdev

search-ecap-dev

aoai-ecap-dev

appcfg-ecap-dev
```

Benefits

- Easy identification
- Automation friendly
- Cost reporting
- Governance

---

# 8. Parameter File Strategy

Every environment has its own parameter file.

```
infrastructure/

└── bicep/

    ├── main.bicep

    └── environments/

        ├── dev.parameters.json

        ├── qa.parameters.json

        ├── stage.parameters.json

        └── prod.parameters.json
```

Only parameter values change.

Infrastructure code remains identical.

---

# 9. Configuration Strategy

Application configuration shall be externalized.

Configuration hierarchy

```
appsettings.json

↓

appsettings.Environment.json

↓

Azure App Configuration

↓

Environment Variables

↓

Azure Key Vault
```

The highest priority source overrides lower priority sources.

---

# 10. Secret Management

Secrets shall never exist in:

- Source code
- GitHub
- Bicep parameter files
- Pipeline YAML

Secrets shall reside in Azure Key Vault.

Examples

- SQL passwords
- API Keys
- Storage Keys
- OpenAI Keys
- Certificates

Whenever possible, applications should authenticate using Managed Identity instead of secrets.

---

# 11. AI Environment Strategy

Each environment owns independent AI resources.

Development

- Azure OpenAI
- Azure AI Search
- Test prompts

QA

- Stable prompts
- Evaluation datasets

Stage

- Production candidate prompts
- Final validation

Production

- Approved prompts
- Production AI deployments
- Production indexes

AI resources must never be shared across environments.

---

# 12. Database Strategy

Each environment owns its own database.

Example

```
ecap-dev

ecap-qa

ecap-stage

ecap-prod
```

No cross-environment database access.

---

# 13. Monitoring Strategy

Each environment has independent monitoring.

Resources

- Application Insights
- Log Analytics
- Azure Monitor

Production additionally includes:

- Alerts
- Dashboards
- Availability tests

---

# 14. CI/CD Promotion Strategy

Deployment flow

```
Feature Branch
        │
        ▼
Build
        │
        ▼
Development
        │
        ▼
QA
        │
 Manual Approval
        ▼
Stage/UAT
        │
 Manual Approval
        ▼
Production
```

Application artifacts are promoted without rebuilding.

---

# 15. Infrastructure Deployment Strategy

Every environment is deployed from the same Bicep modules.

```
main.bicep

↓

Environment Parameter File

↓

Azure Deployment

↓

Validation

↓

Smoke Tests
```

The only differences are:

- Resource names
- SKUs
- Capacity
- Configuration values

---

# 16. Validation Strategy

After every deployment the following validations are required.

Infrastructure

- Resource creation
- Naming validation
- Diagnostic settings
- RBAC

Application

- Health endpoint
- Configuration validation
- Database connectivity

AI

- OpenAI deployment
- AI Search
- Embedding model
- Prompt execution

---

# 17. Cost Optimization

Development

Lowest SKU.

QA

Lower-cost SKU.

Stage

Production-equivalent where feasible.

Production

Business-approved SKU.

This minimizes operational cost while preserving deployment consistency.

---

# 18. Disaster Recovery

An environment shall be recoverable by executing:

- Bicep deployment
- Database migration
- Configuration deployment
- Application deployment

No manual Azure Portal configuration should be required.

---

# 19. Definition of Done

The Environment Strategy is successfully implemented when:

- All environments deploy successfully.
- Parameter files are environment specific.
- Infrastructure is identical across environments.
- Secrets are stored in Key Vault.
- Configuration is externalized.
- Pipelines promote deployments automatically.
- AI resources are isolated.
- Monitoring is operational.

---

# 20. Future Enhancements

Future platform improvements may include:

- Separate Azure subscriptions per environment
- Private Endpoints
- Virtual Networks
- Network Security Groups
- Azure Firewall
- Azure Front Door
- Traffic Manager
- Geo-redundant deployments
- Blue/Green deployments
- Canary releases
- Multi-region production deployment
