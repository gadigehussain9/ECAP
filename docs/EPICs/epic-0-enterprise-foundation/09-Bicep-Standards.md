
# Bicep Standards
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Bicep Standards |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the enterprise Bicep development standards for the Enterprise Commerce & AI Platform (ECAP).

The objective is to ensure that all Azure infrastructure is:

- Repeatable
- Maintainable
- Secure
- Modular
- Reusable
- Version Controlled
- Environment Independent

These standards apply to every Infrastructure as Code implementation within ECAP.

---

# 2. Guiding Principles

Infrastructure shall be:

- Infrastructure as Code
- Declarative
- Modular
- Idempotent
- Reusable
- Environment Agnostic
- Secure by Default
- Version Controlled
- Automated through CI/CD

---

# 3. Repository Structure

```
infrastructure/

└── bicep/

    ├── main.bicep

    ├── modules/

    ├── environments/

    ├── scripts/

    └── README.md
```

Each Azure resource shall be implemented as an independent module.

---

# 4. Layered Architecture

Infrastructure is organized into deployment layers.

```
main.bicep

↓

Monitoring

↓

Security

↓

Configuration

↓

Data

↓

AI

↓

Compute

↓

Application Deployment
```

Each layer references reusable modules.

---

# 5. Module Standards

Each module shall manage one logical Azure resource.

Examples

```
storage-account.bicep

key-vault.bicep

sql-server.bicep

azure-openai.bicep

ai-search.bicep

application-insights.bicep
```

Modules shall not contain unrelated resources.

---

# 6. File Naming Standards

Use lowercase with hyphens.

Examples

```
storage-account.bicep

azure-openai.bicep

managed-identity.bicep

log-analytics.bicep

app-service.bicep
```

Avoid abbreviations unless they are Azure-standard.

---

# 7. Parameter Standards

Every configurable value shall be passed as a parameter.

Examples

- Environment
- Location
- Resource Name
- SKU
- Tags

Hardcoded values are discouraged except where Azure requires fixed values.

---

# 8. Variable Standards

Variables shall only be used for:

- Derived names
- Resource identifiers
- Shared expressions

Business configuration shall not be stored in variables.

---

# 9. Output Standards

Modules shall expose only necessary outputs.

Examples

- Resource ID
- Resource Name
- Principal ID
- Endpoint
- Connection Information (never secrets)

Outputs should support downstream modules.

---

# 10. Resource Naming

Resource names shall follow ECAP naming conventions.

Examples

```
rg-ecap-dev

kv-ecap-dev

sql-ecap-dev

appi-ecap-dev

aoai-ecap-dev
```

Naming shall be deterministic.

---

# 11. Tagging

Every resource shall include standard tags.

Required tags:

```
Application

Environment

Owner

ManagedBy

CostCenter

BusinessUnit

Criticality
```

Tags are passed from the root deployment.

---

# 12. Secure Parameters

Sensitive values shall use secure parameters where supported.

Examples

- Passwords
- Secrets
- Client Secrets
- API Keys

Sensitive values shall never appear in:

- Git
- Logs
- Pipeline output

---

# 13. Existing Resources

Use `existing` resources only when integrating with infrastructure that is intentionally managed outside the current deployment.

Examples:

- Existing Virtual Network
- Existing Log Analytics Workspace
- Existing Key Vault

Document the ownership of every existing resource.

---

# 14. Dependency Management

Dependencies shall be expressed through Bicep resource references.

Avoid artificial ordering.

Use `dependsOn` only when an implicit dependency cannot be inferred.

---

# 15. Environment Strategy

The same Bicep modules shall deploy all environments.

Only parameter files differ.

```
dev.parameters.json

qa.parameters.json

stage.parameters.json

prod.parameters.json
```

No environment-specific Bicep modules.

---

# 16. Validation

Infrastructure shall be validated before deployment.

Validation includes:

- Bicep build
- Bicep lint
- Azure What-If
- Parameter validation

Pipeline execution shall stop if validation fails.

---

# 17. CI/CD Integration

Every infrastructure deployment follows:

```
Restore

↓

Build

↓

Bicep Lint

↓

What-If

↓

Deploy

↓

Validate

↓

Smoke Test
```

---

# 18. Error Handling

Deployment failures shall:

- Stop the pipeline
- Produce meaningful logs
- Return deployment outputs
- Preserve deployment history

---

# 19. Security Standards

Infrastructure shall implement:

- Managed Identity
- Azure RBAC
- HTTPS Only
- Diagnostic Settings
- Key Vault integration
- Least Privilege

Security shall be enabled by default.

---

# 20. Monitoring Standards

Resources shall enable diagnostics where supported.

Telemetry shall be sent to:

- Log Analytics
- Application Insights
- Azure Monitor

---

# 21. Version Control

Every infrastructure change requires:

- Pull Request
- Review
- Build Validation
- What-If Validation
- Git History

Manual Azure Portal changes should be avoided.

---

# 22. Documentation

Every module shall include:

- Purpose
- Parameters
- Outputs
- Dependencies
- Example usage

Complex deployments should include architecture diagrams.

---

# 23. Definition of Done

A Bicep implementation is complete when:

- Module is reusable.
- Validation succeeds.
- Deployment is idempotent.
- Naming standards are followed.
- Tags are applied.
- Secure parameters are used.
- Diagnostics are enabled.
- Documentation is updated.
- CI/CD deployment succeeds.

---

# 24. Future Enhancements

Future improvements may include:

- Azure Verified Modules (AVM)
- Deployment Stacks
- Template Specs
- Private Endpoint modules
- Landing Zone integration
- Policy as Code
- Drift detection
- Automated compliance validation
