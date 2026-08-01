
# Branching Strategy
## EPIC 0 – Enterprise Platform Foundation

| Item | Value |
|------|-------|
| Document | Branching Strategy |
| Epic | EPIC 0 |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-08-02 |

---

# 1. Purpose

This document defines the Git branching strategy for the Enterprise Commerce & AI Platform (ECAP).

A consistent branching strategy enables:

- Parallel development
- Safe releases
- Hotfix deployments
- Better collaboration
- Automated CI/CD
- Predictable software delivery

---

# 2. Branching Model

ECAP adopts a simplified Git Flow model.

```
main
│
├── develop
│     │
│     ├── feature/product-catalog
│     ├── feature/inventory
│     ├── feature/orders
│     ├── feature/azure-openai
│     ├── feature/rag
│     └── feature/ci-cd
│
├── release/v1.0.0
│
└── hotfix/v1.0.1
```

---

# 3. Branch Purpose

| Branch | Purpose |
|---------|----------|
| main | Production-ready code |
| develop | Integration branch |
| feature/* | Feature development |
| release/* | Release preparation |
| hotfix/* | Production fixes |

---

# 4. Main Branch

Purpose

- Stable
- Production-ready
- Protected

Rules

- No direct commits
- Pull Request required
- Successful build required
- Successful tests required
- Code review required

---

# 5. Develop Branch

Purpose

Daily integration.

All completed features merge into Develop.

Rules

- Pull Request required
- Build validation required
- Unit tests required

---

# 6. Feature Branches

Naming Convention

```
feature/<feature-name>
```

Examples

```
feature/product-catalog

feature/inventory

feature/orders

feature/azure-openai

feature/rag

feature/semantic-search

feature/bicep

feature/pipelines
```

Rules

- One feature per branch
- Small commits
- Frequently synchronize with Develop

---

# 7. Release Branches

Naming Convention

```
release/v1.0.0
```

Purpose

- Final testing
- Bug fixes
- Documentation updates
- Release notes

Only stabilization work is allowed.

---

# 8. Hotfix Branches

Naming Convention

```
hotfix/v1.0.1
```

Purpose

Urgent production fixes.

Hotfixes merge into:

- main
- develop

---

# 9. Branch Protection Rules

The following branches are protected:

- main
- develop

Protection includes:

- Pull Request required
- Build validation
- Required reviewers
- No force push
- No branch deletion

---

# 10. Pull Request Process

Every Pull Request shall include:

- Description
- Linked work item
- Testing evidence
- Architecture impact
- Documentation updates
- ADR updates (if applicable)

---

# 11. Commit Standards

Commit messages follow Conventional Commits.

Examples

```
feat(product): add product search

feat(ai): add Azure OpenAI provider

fix(api): resolve validation issue

refactor(domain): simplify aggregate logic

docs(epic0): update environment strategy

test(product): add unit tests

build(ci): update pipeline

chore: update dependencies
```

---

# 12. Merge Strategy

Preferred merge method:

- Squash and Merge

Benefits:

- Cleaner history
- One commit per feature
- Easier rollback
- Easier release notes

---

# 13. CI/CD Integration

Every Pull Request triggers:

- Restore
- Build
- Unit Tests
- Architecture Tests
- Static Analysis
- Bicep Validation

Only successful builds may merge.

---

# 14. Release Process

```
feature/*
      │
      ▼
develop
      │
      ▼
release/v1.0.0
      │
      ▼
QA
      │
      ▼
Stage
      │
      ▼
Production
      │
      ▼
main
```

---

# 15. Hotfix Process

```
main
   │
   ▼
hotfix/v1.0.1
   │
   ▼
Production
   │
   ├────────► main
   │
   └────────► develop
```

---

# 16. Version Tags

Every production release receives a Git tag.

Examples

```
v1.0.0

v1.1.0

v1.2.0

v2.0.0
```

Tags are immutable.

---

# 17. Branch Lifecycle

Feature Branch

```
Create

↓

Develop

↓

Push

↓

Pull Request

↓

Code Review

↓

Merge

↓

Delete
```

Release Branch

```
Create

↓

QA

↓

Bug Fixes

↓

Production

↓

Merge

↓

Delete
```

Hotfix Branch

```
Create

↓

Fix

↓

Production

↓

Merge Back

↓

Delete
```

---

# 18. Best Practices

- Keep branches short-lived.
- Commit frequently.
- Rebase regularly with Develop.
- Avoid large Pull Requests.
- Delete merged branches.
- Never commit secrets.
- Keep documentation updated with code changes.

---

# 19. Definition of Done

The branching strategy is successfully implemented when:

- Branch naming conventions are followed.
- Protected branches are configured.
- Pull Requests are mandatory.
- CI validation is enforced.
- Releases are tagged.
- Hotfixes follow the defined process.
- Repository history remains clean and traceable.
