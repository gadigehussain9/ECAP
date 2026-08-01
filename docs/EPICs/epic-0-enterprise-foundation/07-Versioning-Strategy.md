
# Versioning Strategy
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Versioning Strategy |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the versioning strategy for the Enterprise Commerce & AI Platform (ECAP).

Versioning ensures that every deployable artifact can be identified, reproduced, audited, and rolled back when necessary.

The strategy applies to:

- Source Code
- APIs
- Database
- Infrastructure
- Pipelines
- AI Models
- Prompts
- Embeddings
- Documentation
- Architecture Decisions

---

# 2. Versioning Principles

ECAP follows these principles:

- Every deployable artifact is versioned.
- Versions are immutable after release.
- Production releases are tagged in Git.
- Infrastructure and application versions are traceable.
- AI artifacts are version controlled.
- Documentation versions align with implementation.

---

# 3. Semantic Versioning

Applications use Semantic Versioning (SemVer):

```
MAJOR.MINOR.PATCH
```

Examples:

```
1.0.0
1.1.0
1.2.3
2.0.0
```

Meaning:

| Part | Description |
|------|-------------|
| MAJOR | Breaking changes |
| MINOR | Backward-compatible features |
| PATCH | Bug fixes |

---

# 4. Application Versioning

Every release increments the application version.

Examples:

```
1.0.0

1.1.0

1.2.0

2.0.0
```

Application version shall be included in:

- Build artifacts
- Release notes
- API metadata
- Deployment logs

---

# 5. API Versioning

REST APIs use URI versioning.

Example:

```
/api/v1/products

/api/v2/products
```

Rules:

- Never introduce breaking changes within the same API version.
- Deprecate older versions before removal.
- Support parallel versions during migration when required.

---

# 6. Database Versioning

Database schema changes are version controlled.

Recommended approach:

- Entity Framework Core Migrations
- Sequential migration history
- Repeatable deployment

Example:

```
001_InitialCreate

002_AddProducts

003_AddCategories

004_AddInventory
```

Rules:

- Never edit an applied migration.
- Create a new migration for every schema change.

---

# 7. Infrastructure Versioning

Bicep templates are version controlled through Git.

Every infrastructure change:

- Pull Request
- Code Review
- Git History
- Release Tag

Breaking infrastructure changes require an ADR.

---

# 8. Pipeline Versioning

Pipeline YAML files are stored in Git.

Changes require:

- Pull Request
- Review
- Successful validation

Pipeline templates are reusable and evolve independently of application code.

---

# 9. AI Model Versioning

Every AI model deployment shall be documented.

Track:

- Model Name
- Model Version
- Deployment Name
- Azure Region
- Deployment Date

Example:

| Model | Version |
|--------|----------|
| GPT-4.1 | 2026-07 |
| Text Embedding | 3-large |

If a model is upgraded, document the impact and validation results.

---

# 10. Prompt Versioning

Prompts are source code.

Prompt files shall reside under:

```
docs/AI/prompts/
```

Example:

```
ProductSummary_v1.md

ProductSummary_v2.md

RecommendationPrompt_v1.md
```

Every prompt update requires:

- Pull Request
- Review
- Evaluation

---

# 11. Embedding Versioning

Embedding generation shall record:

- Embedding Model
- Chunking Strategy
- Chunk Size
- Overlap
- Embedding Date

Changes to any of these require re-indexing and validation.

---

# 12. Documentation Versioning

Enterprise documentation is maintained in Git.

Major architectural changes require updates to:

- Handbook
- ADRs
- Standards
- Diagrams

Documentation version should reflect implementation status.

---

# 13. Architecture Decision Versioning

Each ADR has its own lifecycle.

States include:

- Proposed
- Accepted
- Superseded
- Deprecated

Superseded ADRs remain in the repository for historical reference.

---

# 14. Git Tagging Strategy

Production releases are tagged.

Examples:

```
v1.0.0

v1.1.0

v1.2.0
```

Tags represent immutable production releases.

---

# 15. Release Naming

Release names should be meaningful.

Example:

```
v1.0.0 – Enterprise Foundation

v1.1.0 – Product Catalog

v1.2.0 – Azure AI Platform

v2.0.0 – Commerce Platform
```

---

# 16. Traceability Matrix

Every production deployment shall identify:

- Git Commit
- Git Tag
- Application Version
- API Version
- Database Migration
- Infrastructure Version
- AI Model Version
- Prompt Version
- Pipeline Version

This enables complete deployment traceability.

---

# 17. Rollback Strategy

Rollback requires:

- Previous Git Tag
- Previous Application Artifact
- Previous Database Backup (if required)
- Previous Infrastructure Version
- Previous Prompt Version
- Previous AI Model Deployment

Rollback procedures shall be tested periodically.

---

# 18. Definition of Done

The Versioning Strategy is successfully implemented when:

- Semantic Versioning is applied consistently.
- APIs are versioned.
- Database migrations are version controlled.
- Infrastructure is versioned through Git.
- AI models and prompts are versioned.
- Production releases are tagged.
- Every deployment is traceable and reproducible.

---

# 19. Future Enhancements

Future improvements may include:

- Automated release notes
- GitHub Releases
- Azure DevOps release dashboards
- Automated changelog generation
- AI-assisted release summaries
- Automated dependency version tracking
