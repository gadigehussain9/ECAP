# EPIC-01: Enterprise Product Catalog

# Implementation Guide

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | Implementation Guide |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the engineering standards and implementation guidelines for the Product Catalog module.

Every feature must follow the same architecture, coding standards, testing approach and deployment process.

The objective is to ensure consistency, maintainability, scalability and high code quality across the ECAP platform.

---

# 2. Development Workflow

Every feature shall follow this lifecycle:

```
Business Requirement
        │
        ▼
User Story
        │
        ▼
Acceptance Criteria
        │
        ▼
Domain Model
        │
        ▼
REST API Design
        │
        ▼
Command / Query
        │
        ▼
Validator
        │
        ▼
Handler
        │
        ▼
Repository
        │
        ▼
Database
        │
        ▼
Domain Event
        │
        ▼
Unit Tests
        │
        ▼
Integration Tests
        │
        ▼
Deployment
```

No step should be skipped.

---

# 3. Solution Structure

```
src/

├── Ecap.Api
├── Ecap.Application
├── Ecap.Domain
├── Ecap.Infrastructure
├── Ecap.Contracts
├── Ecap.SharedKernel

tests/

├── Ecap.UnitTests
├── Ecap.IntegrationTests
├── Ecap.ApiTests
├── Ecap.PerformanceTests
```

---

# 4. Clean Architecture Rules

Dependencies must always point inward.

```
API

↓

Application

↓

Domain

↑

Infrastructure
```

Rules:

- Domain depends on nothing.
- Application depends only on Domain.
- Infrastructure depends on Application and Domain.
- API depends on Application.

---

# 5. Folder Structure

```
Application

└── Products

    ├── Commands
    ├── Queries
    ├── Validators
    ├── DTOs
    ├── Events
    ├── Interfaces
    └── Mapping
```

---

# 6. Feature Development Checklist

Every new feature must include:

- Business Requirement
- User Story
- Acceptance Criteria
- API Endpoint
- Command or Query
- Validator
- Handler
- Repository
- Domain Event
- Unit Tests
- Integration Tests
- Documentation

---

# 7. Coding Standards

General principles:

- Follow SOLID principles.
- Follow Clean Code practices.
- Prefer composition over inheritance.
- Keep methods small and focused.
- Use asynchronous programming.
- Avoid duplicate code.

---

# 8. Naming Conventions

### Classes

- Product
- ProductRepository
- CreateProductCommand
- CreateProductCommandHandler
- ProductCreatedEvent

### Interfaces

Prefix with `I`.

Examples:

- IProductRepository
- IClock
- ICurrentUserService

### Methods

Use verbs:

- CreateProductAsync()
- SearchProductsAsync()
- DeleteProductAsync()

### Variables

Use meaningful names.

Avoid:

```
data
obj
temp
x
```

Prefer:

```
product
category
searchRequest
productId
```

---

# 9. CQRS Standards

Commands:

- One responsibility.
- Modify state.
- Return lightweight responses.

Queries:

- Read only.
- Return DTOs.
- No side effects.

Handlers:

- One handler per request.
- No presentation logic.
- No HTTP context access.

---

# 10. Validation Standards

Use FluentValidation.

Validate:

- Required fields
- Length
- Format
- Business rules
- Ranges

Validation should occur before business logic execution.

---

# 11. Exception Handling

Use global exception handling.

Return RFC 7807 Problem Details.

Do not expose:

- Stack traces
- SQL details
- Internal exceptions
- Secrets

---

# 12. Logging Standards

Use structured logging.

Log:

- Business events
- Errors
- Warnings
- Performance information

Never log:

- Passwords
- Tokens
- Secrets
- Personal information

Include:

- CorrelationId
- UserId
- RequestId

---

# 13. Dependency Injection

Register services through extension methods.

Example:

```
services.AddApplication();
services.AddInfrastructure();
services.AddApi();
```

Avoid service registration directly in `Program.cs`.

---

# 14. Repository Standards

Repositories should:

- Encapsulate persistence.
- Return domain entities.
- Be asynchronous.
- Avoid business logic.

Repositories should not:

- Call external APIs.
- Perform validation.
- Access HTTP context.

---

# 15. EF Core Guidelines

- Use migrations.
- Configure entities with Fluent API.
- Avoid lazy loading.
- Use `AsNoTracking()` for read-only queries.
- Use optimistic concurrency where required.

---

# 16. API Standards

- Version all APIs.
- Use RESTful resource names.
- Return appropriate HTTP status codes.
- Support pagination.
- Support filtering.
- Support sorting.
- Use consistent error responses.

---

# 17. Security Standards

Every feature must:

- Require authentication where applicable.
- Enforce authorization policies.
- Validate input.
- Use Managed Identity for Azure resources.
- Retrieve secrets from Azure Key Vault.

---

# 18. Observability Standards

Every feature shall:

- Log important business events.
- Emit metrics.
- Support distributed tracing.
- Include Correlation IDs.
- Expose health checks where applicable.

---

# 19. Testing Standards

Every feature requires:

- Unit Tests
- Integration Tests
- API Tests (where applicable)

Coverage targets:

- Domain: 95%
- Application: 90%
- Overall: 90%+

---

# 20. Git Workflow

Branch naming:

```
feature/product-create
feature/product-search
bugfix/product-validation
hotfix/security-fix
```

Commit message format:

```
feat(product): add create product command

fix(product): validate duplicate SKU

refactor(product): simplify search handler

test(product): add validator tests

docs(product): update API documentation
```

---

# 21. Pull Request Checklist

Every Pull Request should verify:

- Code builds successfully.
- Unit tests pass.
- Integration tests pass.
- No compiler warnings.
- Documentation updated.
- Security review completed.
- Code reviewed by another developer.

---

# 22. Definition of Done

A feature is considered complete when:

- Business requirements are implemented.
- Acceptance criteria are satisfied.
- Code review is approved.
- Tests pass.
- Documentation is updated.
- Deployment succeeds.
- Monitoring is configured.
- No critical defects remain.

---

# 23. AI Readiness

Future AI features must:

- Follow the same Clean Architecture principles.
- Use provider abstractions.
- Avoid vendor lock-in.
- Log AI interactions.
- Support prompt versioning.
- Validate AI responses.

---

# 24. Common Anti-Patterns

Avoid:

- Fat controllers
- Fat handlers
- God services
- Static dependencies
- Business logic in repositories
- Direct database access from API
- Returning EF entities from endpoints
- Synchronous I/O
- Hard-coded configuration

---

# 25. References

- 06-Architecture.md
- 08-REST-API.md
- 09-CQRS.md
- 10-Azure-Resources.md
- 11-Security.md
- 12-Deployment.md
- 13-Observability.md
- 14-Testing.md
