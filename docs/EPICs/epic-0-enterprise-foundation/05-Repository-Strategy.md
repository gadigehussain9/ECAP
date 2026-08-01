# Repository Strategy
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Repository Strategy |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the repository organization, directory structure, ownership, and governance standards for the Enterprise Commerce & AI Platform (ECAP).

A consistent repository structure improves:

- Developer productivity
- Code discoverability
- Maintainability
- Reusability
- Automation
- CI/CD
- Documentation
- Architecture consistency

Every future module shall follow this strategy.

---

# 2. Repository Principles

The ECAP repository follows these principles:

- Documentation First
- Architecture Driven Development
- Infrastructure as Code
- Reusable Components
- Modular Design
- Convention over Configuration
- Git as the Source of Truth
- Automation First

---

# 3. Repository Layout

```
ECAP/

│
├── .github/
│   ├── prompts/
│   ├── workflows/
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── CODEOWNERS
│
├── azure-pipelines/
│   ├── templates/
│   ├── build.yml
│   ├── release-dev.yml
│   ├── release-qa.yml
│   ├── release-stage.yml
│   └── release-prod.yml
│
├── infrastructure/
│   ├── bicep/
│   │   ├── modules/
│   │   ├── environments/
│   │   ├── scripts/
│   │   ├── main.bicep
│   │   └── README.md
│   │
│   └── terraform/
│       └── (Future)
│
├── docs/
│   ├── handbook/
│   ├── architecture/
│   ├── standards/
│   ├── AI/
│   ├── diagrams/
│   └── decisions/
│
├── src/
│   ├── Ecap.Api
│   ├── Ecap.Application
│   ├── Ecap.Domain
│   ├── Ecap.Infrastructure
│   ├── Ecap.Persistence
│   ├── Ecap.AI
│   ├── Ecap.AI.Abstractions
│   ├── Ecap.AI.AzureOpenAI
│   ├── Ecap.SharedKernel
│   └── Modules/
│
├── tests/
│   ├── UnitTests
│   ├── IntegrationTests
│   ├── ArchitectureTests
│   ├── PerformanceTests
│   └── AI.Tests
│
├── scripts/
│
├── tools/
│
├── samples/
│
├── README.md
│
└── LICENSE
```

---

# 4. Repository Ownership

Every folder has a clear responsibility.

## src/

Contains production application code only.

No documentation.

No deployment scripts.

---

## tests/

Contains all automated tests.

Including:

- Unit Tests
- Integration Tests
- Architecture Tests
- AI Tests
- Performance Tests

---

## docs/

Contains all project documentation.

No source code.

No executable files.

---

## infrastructure/

Contains Infrastructure as Code.

Including:

- Bicep
- Parameter Files
- Deployment Scripts

Infrastructure must never exist outside this folder.

---

## azure-pipelines/

Contains all Azure DevOps YAML definitions.

Reusable templates are preferred.

---

## .github/

Contains GitHub-specific configuration.

Examples:

- Pull Request templates
- Issue templates
- Copilot prompts
- Repository settings

---

# 5. Module Organization

Every business module shall use the same structure.

Example

```
ProductCatalog/

├── API
├── Application
├── Domain
├── Infrastructure
├── Persistence
└── Tests
```

Future modules:

- Inventory
- Orders
- Billing
- Shipping
- Notifications

shall follow the same pattern.

---

# 6. Documentation Organization

Documentation shall be categorized.

```
docs/

├── handbook/
├── architecture/
├── standards/
├── AI/
├── diagrams/
└── decisions/
```

Every document shall have:

- Version
- Status
- Owner
- Last Updated

---

# 7. Architecture Decisions

Architecture decisions shall be recorded using ADRs.

Location

```
docs/

architecture/

adr/
```

Examples

- ADR-001 Use CQRS
- ADR-002 Clean Architecture
- ADR-003 Azure SQL
- ADR-004 Azure OpenAI
- ADR-005 Bicep

Future architectural changes require a new ADR.

---

# 8. Infrastructure Organization

Infrastructure is organized as:

```
bicep/

├── modules/

├── environments/

├── scripts/

└── main.bicep
```

Every Azure resource shall have its own reusable module.

Examples

- key-vault.bicep
- storage-account.bicep
- app-service.bicep
- azure-openai.bicep
- ai-search.bicep

---

# 9. AI Organization

AI capabilities are isolated from business modules.

```
Ecap.AI

↓

Chat

Embeddings

Search

RAG

Prompts

Evaluation

Telemetry

Security
```

Business modules consume abstractions.

Business modules shall never directly reference Azure SDKs.

---

# 10. Standards Organization

Enterprise standards are maintained under:

```
docs/

standards/
```

Examples

- Coding Standards
- Logging Standards
- Security Standards
- Testing Standards
- API Standards

---

# 11. Version Control

Everything is version controlled.

Including:

- Source Code
- Bicep
- Pipelines
- Documentation
- AI Prompts
- ADRs
- Architecture

No manual configuration should exist outside version control.

---

# 12. Repository Governance

Repository governance includes:

- Pull Request Reviews
- Branch Protection
- Required Build Validation
- Required Tests
- Code Review
- Documentation Review

---

# 13. Naming Standards

Project names shall follow a consistent convention.

Examples

```
Ecap.Api

Ecap.Application

Ecap.Domain

Ecap.Infrastructure

Ecap.Persistence

Ecap.AI

Ecap.SharedKernel
```

Folders use PascalCase for projects and lowercase where appropriate for infrastructure and documentation.

---

# 14. Definition of Done

Repository strategy is successfully implemented when:

- Folder structure is standardized.
- Documentation locations are consistent.
- Infrastructure resides only under infrastructure/.
- Pipelines reside only under azure-pipelines/.
- Business modules follow the standard module structure.
- AI components are isolated.
- Standards are documented.
- Repository governance is enforced.

---

# 15. Future Enhancements

Future improvements may include:

- GitHub Actions support
- Dev Containers
- Multi-repository strategy
- Internal NuGet package feed
- Shared engineering templates
- Automated documentation generation
- Enterprise package management
