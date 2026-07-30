# EPIC-01: Enterprise Product Catalog

# Architecture

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | Architecture |
| Version | 1.0 |
| Status | Draft |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the architecture for the Enterprise Product Catalog.

The objective is to build a maintainable, scalable, cloud-native and AI-ready application that follows modern enterprise engineering practices.

The architecture must support future business growth without requiring significant redesign.

---

# 2. Architecture Goals

The architecture must:

- Be easy to understand.
- Be easy to maintain.
- Be independently testable.
- Support modular development.
- Minimise coupling.
- Maximise cohesion.
- Be cloud-native.
- Be AI-ready.
- Scale horizontally.
- Follow SOLID principles.

---

# 3. Architectural Principles

The Product Catalog follows these principles:

- Clean Architecture
- Vertical Slice Architecture
- CQRS
- Domain-Driven Design
- SOLID Principles
- Dependency Injection
- Event-Driven Design
- API First
- Cloud Native
- Security by Design
- Observability by Design

---

# 4. High-Level Architecture

```

```
                 Client
                    │
                    ▼
             Azure API Management
                    │
                    ▼
            ASP.NET Core Web API
                    │
         ┌──────────┴──────────┐
         │                     │
 Commands (Write)        Queries (Read)
         │                     │
         ▼                     ▼
     MediatR Handler      MediatR Handler
         │                     │
         ▼                     ▼
   Domain Services      Query Services
         │                     │
         ▼                     ▼
     Repository Layer
         │
         ▼
      Database
```

```

---

# 5. Clean Architecture

The solution is divided into four primary layers.

```

```
Presentation

↓

Application

↓

Domain

↓

Infrastructure

```

```

---

## Presentation Layer

Responsibilities:

- HTTP APIs
- Authentication
- Authorization
- Request Validation
- API Versioning
- Swagger

Technologies:

- ASP.NET Core
- Minimal API / Controllers

---

## Application Layer

Contains application use cases.

Responsibilities:

- Commands
- Queries
- MediatR Handlers
- DTOs
- Validators
- Mapping
- Interfaces

Business workflows are orchestrated here.

---

## Domain Layer

Contains pure business logic.

Responsibilities:

- Entities
- Aggregate Roots
- Value Objects
- Domain Events
- Domain Services
- Business Rules

This layer has **no dependency** on ASP.NET Core, EF Core or Azure.

---

## Infrastructure Layer

Contains technical implementations.

Responsibilities:

- EF Core
- Cosmos DB
- Blob Storage
- Azure SDKs
- Repository Implementations
- External Services
- Logging
- Email Providers

Infrastructure depends on the Domain—not the other way around.

---

# 6. Vertical Slice Architecture

Instead of organising code by technical layers only, features are organised by business capability.

Example:

```

```
Product

├── Create
│   ├── Command
│   ├── Validator
│   ├── Handler
│   └── Endpoint
│
├── Update
├── Delete
├── Search
└── GetById

```

```

Benefits:

- Better feature isolation.
- Easier maintenance.
- Smaller pull requests.
- Simpler testing.
- Faster onboarding.

---

# 7. CQRS

Command Query Responsibility Segregation separates writes from reads.

### Commands

Modify data.

Examples:

- Create Product
- Update Product
- Delete Product

Commands change system state.

---

### Queries

Read data.

Examples:

- Get Product
- Search Products
- Get Categories

Queries never modify state.

---

# 8. MediatR

Every request passes through MediatR.

```

```
API

↓

Command

↓

Validator

↓

Handler

↓

Repository

↓

Database

```

```

Advantages:

- Loose coupling.
- Easy testing.
- Centralised pipeline behaviours.
- Logging.
- Validation.
- Performance monitoring.

---

# 9. Validation

All requests are validated before business logic executes.

Validation includes:

- Required fields.
- Business rules.
- SKU uniqueness.
- Category existence.
- Price validation.

FluentValidation will be used.

Invalid requests never reach the Domain Layer.

---

# 10. Repository Pattern

Repositories abstract data access from business logic.

Example interfaces:

- IProductRepository
- ICategoryRepository
- IBrandRepository

Repositories expose business-oriented methods instead of database-specific operations.

---

# 11. Unit of Work

The Unit of Work coordinates multiple repository operations within a single transaction.

Responsibilities:

- Commit changes.
- Rollback on failure.
- Maintain transactional consistency.

---

# 12. Domain Events

Business events are raised within the Domain Layer.

Examples:

- ProductCreated
- ProductUpdated
- ProductDeleted

Future subscribers:

- Search Index
- Notification Service
- Analytics
- AI Platform
- Audit Service

This keeps the Product Catalog decoupled from downstream systems.

---

# 13. Dependency Injection

All infrastructure dependencies are injected through interfaces.

Example:

```

```
IProductRepository

↓

ProductRepository

```

```

Benefits:

- Loose coupling.
- Testability.
- Replaceable implementations.

---

# 14. Error Handling

A consistent error handling strategy shall be used.

Common responses:

- Validation Error
- Not Found
- Conflict
- Unauthorized
- Forbidden
- Internal Server Error

Problem Details (RFC 7807) should be used for API error responses.

---

# 15. Logging & Observability

Every request should include:

- Correlation ID
- Request ID
- User ID (when authenticated)
- Execution Time
- Status Code

Application Insights will collect:

- Logs
- Metrics
- Traces
- Exceptions

---

# 16. Security Architecture

Authentication:

- Microsoft Entra ID
- JWT Bearer Tokens

Authorization:

- Role-Based Access Control (RBAC)

Secrets:

- Azure Key Vault

Transport:

- HTTPS only

---

# 17. AI Extension Points

The architecture is designed to support future AI capabilities without redesign.

Future AI integration points include:

- Product Embeddings
- AI Product Description Generation
- Semantic Search
- Vector Search
- AI Shopping Assistant
- Product Recommendations

The Product Catalog acts as the trusted knowledge source for the AI Platform.

---

# 18. Azure Architecture

Target Azure services:

- Azure App Service
- Azure API Management
- Azure SQL Database (or Cosmos DB where appropriate)
- Azure Blob Storage
- Azure Key Vault
- Azure Monitor
- Application Insights
- Azure App Configuration
- Azure Service Bus (future)
- Azure AI Search (future)

Infrastructure will be provisioned using Bicep templates.

---

# 19. Architecture Decision Summary

| Decision | Reason |
|----------|--------|
| Clean Architecture | Separation of concerns |
| Vertical Slice | Feature isolation |
| CQRS | Independent read/write models |
| MediatR | Loose coupling |
| FluentValidation | Centralised validation |
| Repository Pattern | Data abstraction |
| Unit of Work | Transaction consistency |
| Domain Events | Decoupled communication |
| Azure-First | Cloud-native platform |
| AI-Ready Design | Future extensibility |

---

# 20. Architecture Constraints

- Domain layer must not reference Infrastructure.
- Business rules must reside in the Domain Layer.
- APIs must not access the database directly.
- Every write operation shall use a Command.
- Every read operation shall use a Query.
- Cross-cutting concerns shall be implemented using MediatR pipeline behaviours or middleware.
- Infrastructure implementations shall be replaceable without changing business logic.

---

# 21. References

- 01-Vision.md
- 02-Business-Requirements.md
- 03-User-Stories.md
- 04-Acceptance-Criteria.md
- 05-Domain-Model.md
- 07-Database.md
- 08-REST-API.md
- 09-CQRS.md
