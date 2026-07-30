# EPIC-01: Enterprise Product Catalog

# CQRS Design

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | CQRS Design |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines how Command Query Responsibility Segregation (CQRS) is implemented in the Product Catalog.

CQRS separates write operations from read operations, allowing each side of the application to evolve independently while keeping business logic simple and maintainable.

This document serves as the implementation blueprint for developers.

---

# 2. Why CQRS?

Traditional CRUD applications often mix business logic, validation and data access into a single service.

As applications grow this leads to:

- Large service classes
- Difficult testing
- Tight coupling
- Duplicate logic
- Poor scalability

CQRS solves these problems by separating writes from reads.

---

# 3. CQRS Principles

Commands

- Change application state
- Never return domain entities
- Publish domain events
- Execute business rules
- Validate input

Queries

- Never modify data
- Optimised for reading
- Return DTOs
- Support filtering
- Support pagination
- Support sorting

---

# 4. Request Flow

```
HTTP Request

        │

        ▼

Authentication

        │

        ▼

Authorization

        │

        ▼

Endpoint

        │

        ▼

MediatR

        │

        ▼

Pipeline Behaviours

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

Response
```

---

# 5. Folder Structure

```
Application

└── Products

    ├── Commands

    │     ├── CreateProduct

    │     │      ├── CreateProductCommand.cs

    │     │      ├── CreateProductCommandHandler.cs

    │     │      ├── CreateProductValidator.cs

    │     │      └── CreateProductResponse.cs

    │

    │     ├── UpdateProduct

    │     ├── DeleteProduct

    │

    ├── Queries

    │     ├── GetProductById

    │     ├── SearchProducts

    │     ├── GetProducts

    │

    └── Common
```

---

# 6. Commands

Commands modify state.

Current Commands

- CreateProductCommand
- UpdateProductCommand
- DeleteProductCommand

Future Commands

- ArchiveProductCommand
- ActivateProductCommand
- UploadProductImageCommand
- ImportProductsCommand
- GenerateProductDescriptionCommand (AI)
- GenerateSeoMetadataCommand (AI)

---

# 7. Queries

Queries retrieve information.

Current Queries

- GetProductByIdQuery
- SearchProductsQuery
- GetProductsQuery

Future Queries

- SearchProductsSemanticQuery
- GetRecommendationsQuery
- CompareProductsQuery
- SearchByImageQuery
- SearchByVoiceQuery

---

# 8. Command Lifecycle

Every command follows the same sequence.

```
Endpoint

↓

Create Command

↓

Validation

↓

Business Rules

↓

Handler

↓

Repository

↓

Save Changes

↓

Publish Domain Event

↓

Return Response
```

---

# 9. Query Lifecycle

```
Endpoint

↓

Create Query

↓

Validation

↓

Handler

↓

Read Repository

↓

Mapping

↓

DTO

↓

Response
```

---

# 10. Validators

Every Command and Query must have a validator.

Example validation:

CreateProductCommand

- Product Name required
- SKU required
- SKU unique
- Category exists
- Price > 0

SearchProductsQuery

- Page > 0
- PageSize within limits
- Sort field valid

---

# 11. Handlers

Handlers orchestrate business use cases.

Handlers should:

- Call domain methods
- Coordinate repositories
- Publish events
- Return DTOs
- Never contain UI logic

Handlers should NOT:

- Build SQL
- Access HttpContext
- Call unrelated features
- Contain presentation logic

---

# 12. DTOs

Queries return DTOs.

Commands return lightweight responses.

Domain entities should never be exposed directly to clients.

Example

```
ProductDto

↓

API Response

↓

Client
```

---

# 13. MediatR Pipeline Behaviours

Every request passes through common pipeline behaviours.

Current

- Validation
- Logging
- Performance Monitoring
- Exception Handling

Future

- Authorization
- Caching
- Audit Logging
- Metrics
- Retry
- Idempotency

---

# 14. Transaction Boundary

One command equals one transaction.

```
Create Product

↓

Repository

↓

SaveChanges()

↓

Commit
```

If an exception occurs the transaction is rolled back.

---

# 15. Domain Events

Commands publish domain events.

Examples

- ProductCreated
- ProductUpdated
- ProductDeleted

Future consumers

- Search Service
- Notification Service
- Analytics
- Inventory
- AI Platform

---

# 16. Error Handling

Commands return business-friendly errors.

Examples

Validation Failed

Duplicate SKU

Category Not Found

Product Already Deleted

Queries return:

404

400

403

401

500

Problem Details (RFC 7807) should be used consistently.

---

# 17. Performance

Queries should:

- Use projections
- Return DTOs
- Support pagination
- Avoid unnecessary joins

Commands should:

- Modify only required fields
- Avoid unnecessary reads
- Minimise transaction duration

---

# 18. Security

Commands require authentication.

Sensitive operations require role-based authorization.

Examples

Create Product

ProductAdmin

Delete Product

ProductAdmin

Search Products

Public or Authenticated depending on API

---

# 19. AI Readiness

Future AI features naturally fit into CQRS.

Commands

- GenerateDescriptionCommand
- GenerateSeoMetadataCommand
- GenerateEmbeddingCommand

Queries

- SemanticSearchQuery
- RecommendationQuery
- ProductComparisonQuery

No architectural changes are required to support these future capabilities.

---

# 20. CQRS Traceability

| Requirement | Story | API | Command/Query |
|-------------|-------|-----|---------------|
| FR-001 | US-001 | POST /products | CreateProductCommand |
| FR-002 | US-002 | PUT /products/{id} | UpdateProductCommand |
| FR-003 | US-003 | GET /products/{id} | GetProductByIdQuery |
| FR-004 | US-004 | GET /products | SearchProductsQuery |
| FR-005 | US-005 | DELETE /products/{id} | DeleteProductCommand |

---

# 21. Best Practices

- One handler per use case.
- One validator per request.
- Keep handlers focused.
- Never expose domain entities.
- Publish domain events after successful business operations.
- Use asynchronous operations throughout.
- Keep commands and queries independent.

---

# 22. Anti-Patterns

Avoid:

- Fat handlers
- Business logic inside controllers
- Repositories calling other repositories
- Commands returning entities
- Queries modifying state
- Shared DTOs for unrelated features
- Bypassing validation

---

# 23. References

- 05-Domain-Model.md
- 06-Architecture.md
- 07-Database.md
- 08-REST-API.md
- 10-Azure-Resources.md
