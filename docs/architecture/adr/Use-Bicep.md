# ADR-005: Adopt Bicep for Infrastructure as Code

| Item | Value |
|------|-------|
| ADR Number | ADR-005 |
| Title | Adopt Bicep for Infrastructure as Code |
| Status | Accepted |
| Date | 2026-07-30 |
| Decision Makers | Principal Architect, Cloud Architect, DevOps Team |
| Epic | Enterprise Commerce & AI Platform (ECAP) |
| Related Documents | 10-Azure-Resources.md, 12-Deployment.md, 15-Implementation-Guide.md |

---

# 1. Context

The Enterprise Commerce & AI Platform (ECAP) will be deployed across multiple Azure environments including:

- Development
- Test
- QA
- Staging
- Production

The platform consists of numerous Azure resources, including:

- Azure Resource Groups
- Azure App Service
- Azure App Service Plans
- Azure SQL Database
- Azure Storage Account
- Azure Key Vault
- Azure API Management
- Azure Application Insights
- Azure Log Analytics Workspace
- Azure Monitor Alerts
- Azure AI Foundry
- Azure AI Search
- Azure Service Bus
- Azure Cache for Redis

Creating and maintaining these resources manually is:

- Error-prone
- Time-consuming
- Difficult to audit
- Difficult to reproduce
- Inconsistent across environments

Infrastructure must therefore be managed as source code.

---

# 2. Decision

ECAP will adopt **Bicep** as the standard Infrastructure as Code (IaC) language.

All Azure infrastructure shall be:

- Defined using Bicep
- Version controlled in Git
- Peer reviewed
- Automatically deployed through CI/CD
- Parameterised for multiple environments

No production Azure resources shall be created manually unless part of an approved emergency process.

---

# 3. Decision Drivers

This decision supports:

- Infrastructure consistency
- Repeatable deployments
- Source control
- Disaster recovery
- Environment standardisation
- Azure native tooling
- Automation
- Governance

---

# 4. Architecture Overview

```
Developer

     │

     ▼

Git Repository

     │

     ▼

Bicep Templates

     │

     ▼

Azure DevOps / GitHub Actions

     │

     ▼

Azure Resource Manager (ARM)

     │

     ▼

Azure Resources
```

---

# 5. Benefits

## Azure Native

Bicep is Microsoft's recommended Infrastructure as Code language for Azure.

It provides first-class support for Azure Resource Manager (ARM).

---

## Readability

Compared to ARM JSON templates, Bicep is:

- More concise
- Easier to read
- Easier to maintain
- Easier to review

---

## Modularity

Infrastructure can be organised into reusable modules.

Example:

```
infra/

├── main.bicep
├── modules/
│   ├── appservice.bicep
│   ├── sql.bicep
│   ├── keyvault.bicep
│   ├── storage.bicep
│   ├── apim.bicep
│   ├── ai-foundry.bicep
│   ├── ai-search.bicep
│   ├── servicebus.bicep
│   └── monitoring.bicep
```

---

## Version Control

Infrastructure changes:

- Are committed to Git.
- Can be reviewed.
- Can be audited.
- Can be rolled back.

Infrastructure evolves alongside application code.

---

## Repeatability

The same templates are used for:

- Development
- Test
- QA
- Staging
- Production

Only parameter values change.

---

# 6. Consequences

## Positive

- Consistent infrastructure.
- Faster deployments.
- Easier disaster recovery.
- Improved governance.
- Reduced manual errors.

## Negative

- Learning curve for Bicep.
- Additional repository structure.
- Template maintenance.

These trade-offs are acceptable for an enterprise platform.

---

# 7. Alternatives Considered

## Alternative 1 — Manual Azure Portal

Advantages

- Simple for experimentation.
- Quick for individual resources.

Disadvantages

- No version control.
- Difficult to reproduce.
- Error-prone.
- No automated deployments.
- Poor governance.

Decision

Rejected.

---

## Alternative 2 — ARM Templates

Advantages

- Fully supported by Azure.
- Mature platform.

Disadvantages

- Verbose JSON syntax.
- Lower readability.
- Harder maintenance.

Decision

Rejected.

---

## Alternative 3 — Terraform

Advantages

- Multi-cloud support.
- Large ecosystem.
- Strong community.

Disadvantages

- ECAP is Azure-only.
- Additional tooling and state management.
- Less direct integration with Azure features compared to Bicep.

Decision

Rejected for this project.

Terraform may be evaluated for future multi-cloud initiatives.

---

# 8. Repository Structure

```
infra/

├── main.bicep
├── main.parameters.json

├── modules/
│   ├── appservice.bicep
│   ├── appserviceplan.bicep
│   ├── sqlserver.bicep
│   ├── sqldatabase.bicep
│   ├── storage.bicep
│   ├── keyvault.bicep
│   ├── apim.bicep
│   ├── applicationinsights.bicep
│   ├── loganalytics.bicep
│   ├── ai-foundry.bicep
│   ├── ai-search.bicep
│   ├── redis.bicep
│   ├── servicebus.bicep
│   └── monitor.bicep

└── environments/
    ├── dev.parameters.json
    ├── test.parameters.json
    ├── qa.parameters.json
    ├── stage.parameters.json
    └── prod.parameters.json
```

---

# 9. Deployment Standards

Infrastructure deployments shall:

- Be automated.
- Be idempotent.
- Use parameter files.
- Validate before deployment.
- Fail fast on errors.
- Produce deployment logs.

---

# 10. Security

Sensitive values shall never be hard-coded.

Secrets shall be retrieved from:

- Azure Key Vault
- Managed Identity
- Secure pipeline variables

Parameter files shall not contain passwords or connection strings.

---

# 11. Environment Strategy

Each environment will have independent resources.

```
Development

↓

Test

↓

QA

↓

Staging

↓

Production
```

Every environment shall have:

- Separate Resource Group
- Separate Database
- Separate Storage Account
- Separate Key Vault
- Separate Monitoring

Production resources shall never be shared with non-production environments.

---

# 12. CI/CD Integration

Infrastructure deployment pipeline:

```
Git Commit

↓

Pull Request

↓

Build Validation

↓

Bicep Lint

↓

What-If Validation

↓

Approval (where required)

↓

Deploy Infrastructure

↓

Deploy Application

↓

Smoke Tests
```

Infrastructure deployment is executed before application deployment.

---

# 13. Governance

Infrastructure shall comply with:

- Azure Policies
- Resource tagging standards
- Naming conventions
- Least privilege access
- Cost management
- Security baselines

---

# 14. Disaster Recovery

Infrastructure can be recreated using:

- Bicep templates
- Parameter files
- Source-controlled configuration

This reduces Recovery Time Objective (RTO) and improves operational resilience.

---

# 15. Future Evolution

Future enhancements may include:

- Deployment Stacks
- Azure Verified Modules (AVM)
- Private Endpoints by default
- Deployment Rings
- Multi-region deployments
- Blue/Green infrastructure
- Landing Zone integration

---

# 16. Risks

Potential risks:

- Misconfigured parameters.
- Accidental deletion.
- Drift from manual changes.
- Template complexity.

Mitigation:

- Pull Request reviews.
- Azure What-If validation.
- Resource locks.
- Azure Policy.
- Automated testing of templates.

---

# 17. Compliance

This decision aligns with:

- Azure Well-Architected Framework
- Microsoft Azure Bicep Best Practices
- Infrastructure as Code principles
- DevOps practices
- Clean Architecture deployment standards

---

# 18. Review Criteria

This ADR should be reviewed if:

- ECAP expands beyond Azure.
- Multi-cloud support becomes a requirement.
- Azure introduces a successor to Bicep.
- Infrastructure deployment requirements change significantly.

---

# 19. Status History

| Date | Status | Notes |
|------|--------|-------|
| 2026-07-30 | Accepted | Initial Infrastructure as Code decision for ECAP |

---

# 20. Related ADRs

- ADR-001 – Use CQRS
- ADR-002 – Adopt Clean Architecture
- ADR-003 – Adopt Azure SQL Database
- ADR-004 – Adopt Azure AI Foundry and Azure OpenAI

---

# 21. Summary

ECAP adopts **Bicep** as the standard Infrastructure as Code language for all Azure resources.

This decision ensures infrastructure is repeatable, version controlled, secure and automated, enabling consistent deployments across all environments while aligning with Microsoft's recommended Azure practices.
