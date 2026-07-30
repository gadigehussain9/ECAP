# ECAP Git Standards

| Item | Value |
|------|-------|
| Document | Git Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the Git workflow and source control standards for the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Maintain a clean Git history.
- Enable collaborative development.
- Improve code quality.
- Support CI/CD automation.
- Simplify releases.
- Reduce merge conflicts.

These standards apply to all contributors.

---

# 2. Branching Strategy

ECAP uses a **feature branch workflow**.

```
main
 │
 ├── feature/product-catalog
 ├── feature/product-search
 ├── feature/create-order
 ├── feature/ai-chat
 ├── bugfix/product-validation
 ├── hotfix/payment-timeout
 └── docs/api-standards
```

## Branch Types

| Branch | Purpose |
|---------|----------|
| main | Production-ready code |
| feature/* | New features |
| bugfix/* | Non-critical bug fixes |
| hotfix/* | Production fixes |
| docs/* | Documentation changes |
| refactor/* | Code improvements |
| chore/* | Maintenance tasks |
| spike/* | Research or proof of concept |

---

# 3. Branch Naming

Use lowercase with hyphens.

Good

```
feature/product-catalog
feature/create-product
feature/ai-shopping-assistant

bugfix/product-search

hotfix/payment-timeout

docs/testing-standards
```

Avoid

```
Feature1

MyBranch

NewCode

temp
```

---

# 4. Commit Standards

Commits should:

- Be small.
- Be focused.
- Build successfully.
- Represent a single logical change.

Do not combine unrelated work in one commit.

---

# 5. Commit Message Format

Use the Conventional Commits specification.

```
<type>(<scope>): <description>
```

Examples

```
feat(product): add create product command

feat(ai): add embedding provider

fix(product): validate duplicate sku

refactor(api): simplify controller

docs(architecture): add ADR-004

test(product): add validator tests

perf(search): optimise query

build(ci): update GitHub workflow

chore(deps): update NuGet packages
```

---

# 6. Commit Types

| Type | Purpose |
|------|----------|
| feat | New functionality |
| fix | Bug fix |
| docs | Documentation |
| test | Tests |
| refactor | Internal improvement |
| perf | Performance improvement |
| build | Build changes |
| ci | CI/CD updates |
| chore | Maintenance |
| revert | Revert a previous commit |

---

# 7. Pull Requests

Every code change must be submitted through a Pull Request.

A Pull Request should:

- Address a single feature or fix.
- Include a clear description.
- Reference related work items.
- Pass automated checks.
- Be reviewed before merging.

Direct commits to `main` are not permitted.

---

# 8. Pull Request Template

Each Pull Request should include:

- Summary
- Business purpose
- Technical changes
- Testing performed
- Screenshots (if UI changes)
- Breaking changes
- Related ADRs
- Related issues

---

# 9. Code Review

Every Pull Request requires at least one reviewer.

Reviewers should verify:

- Coding standards
- Architecture compliance
- Security
- Performance
- Logging
- Testing
- Documentation
- Backward compatibility

---

# 10. Merge Strategy

Use **Squash and Merge** for feature branches.

Benefits:

- Cleaner Git history
- One commit per feature
- Easier rollback
- Easier release notes

Merge commits should be avoided unless there is a specific requirement.

---

# 11. Protected Branches

The `main` branch shall be protected.

Protection rules include:

- Pull Request required
- Minimum one approval
- Successful build required
- Successful tests required
- No unresolved conversations
- No force pushes
- No direct commits

---

# 12. CI/CD Requirements

Every Pull Request triggers:

- Restore dependencies
- Build
- Unit tests
- Integration tests
- Architecture tests
- Static code analysis
- Security scanning
- Code coverage validation

The Pull Request cannot be merged if mandatory checks fail.

---

# 13. Versioning

ECAP follows Semantic Versioning.

```
MAJOR.MINOR.PATCH
```

Example

```
1.0.0

1.1.0

1.1.1

2.0.0
```

Rules:

- MAJOR → Breaking changes
- MINOR → New backward-compatible features
- PATCH → Backward-compatible bug fixes

---

# 14. Release Strategy

Release flow

```
Developer

↓

Feature Branch

↓

Pull Request

↓

Code Review

↓

CI Validation

↓

Merge to main

↓

Release Pipeline

↓

Production
```

Releases should be tagged.

Example

```
v1.0.0

v1.1.0

v2.0.0
```

---

# 15. Git Tags

Use annotated tags for releases.

Examples

```
v1.0.0

v1.1.0

v2.0.0
```

Tags should correspond to production deployments.

---

# 16. Conflict Resolution

Developers should:

- Pull latest changes regularly.
- Resolve conflicts locally.
- Test after resolving conflicts.
- Avoid large, long-lived branches.

---

# 17. Repository Structure

```
.github/
docs/
infra/
src/
tests/
```

Do not commit:

- Build output
- Secrets
- User-specific IDE files
- Temporary files
- Generated binaries

Ensure `.gitignore` is kept up to date.

---

# 18. Large Files

Avoid committing large binary files.

Use:

- Azure Blob Storage
- Release artifacts
- Git LFS (only if approved)

---

# 19. Security

Never commit:

- Passwords
- API keys
- Certificates
- Connection strings
- Access tokens
- Private keys
- Customer data

Enable secret scanning in the repository where available.

---

# 20. Documentation

Documentation updates should accompany:

- New features
- API changes
- Architecture changes
- Infrastructure changes
- AI capabilities

Documentation is part of the Definition of Done.

---

# 21. Branch Cleanup

Feature branches should be deleted after merging.

Inactive branches should be reviewed and removed periodically.

---

# 22. Best Practices

- Commit early and often.
- Keep commits atomic.
- Rebase feature branches regularly if appropriate.
- Write meaningful commit messages.
- Review before merging.
- Keep branches short-lived.
- Never bypass branch protection.

---

# 23. References

- Coding Standards
- API Standards
- Testing Standards
- Security Standards
- Logging Standards
- ADR-002 – Adopt Clean Architecture
- Conventional Commits Specification
- Semantic Versioning (SemVer)
- GitHub Flow
