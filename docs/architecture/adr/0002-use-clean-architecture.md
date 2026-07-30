# ADR-002: Adopt Clean Architecture

| Item | Value |
|------|-------|
| ADR Number | ADR-002 |
| Title | Adopt Clean Architecture |
| Status | Accepted |
| Date | 2026-07-30 |
| Decision Makers | Principal Architect, Development Team |
| Epic | Enterprise Commerce & AI Platform (ECAP) |
| Related Documents | 06-Architecture.md, 09-CQRS.md, 15-Implementation-Guide.md |

---

# 1. Context

The Enterprise Commerce & AI Platform (ECAP) is expected to become a long-lived enterprise platform supporting multiple business domains including:

- Product Catalog
- Inventory
- Orders
- Customers
- Payments
- Search
- Reviews
- AI Platform
- Notifications
- Analytics

The platform will continue evolving over many years.

Enterprise applications typically require:

- Independent business logic
- Multiple user interfaces
- Multiple data stores
- External integrations
- AI capabilities
- Cloud-native deployment
- Long-term maintainability

Traditional layered architectures often introduce tight coupling between presentation, business logic and infrastructure.

Changes to infrastructure frequently impact business logic, making the system harder to evolve and test.

---

# 2. Decision

ECAP will adopt **Clean Architecture** as its primary architectural style.

The solution will separate responsibilities into independent layers with dependencies always pointing toward the Domain.

Core business rules will remain independent of:

- Database technology
- UI framework
- Cloud provider
- AI provider
- Infrastructure implementation

---

# 3. Architecture Overview

```
+------------------------------------------------+
|                  Presentation                  |
| ASP.NET Core API / Blazor / Future Clients     |
+------------------------------------------------+
                     │
                     ▼
+------------------------------------------------+
|                 Application                    |
| CQRS | Use Cases | DTOs | Validation           |
+------------------------------------------------+
                     │
                     ▼
+------------------------------------------------+
|                    Domain                      |
| Entities | Value Objects | Business Rules      |
+------------------------------------------------+
                     ▲
                     │
+------------------------------------------------+
|                Infrastructure                  |
| EF Core | Azure SQL | Blob | Key Vault         |
| Redis | AI Providers | Service Bus             |
+------------------------------------------------+
```

Dependencies always point inward.

---

# 4. Decision Drivers

This decision supports:

- Maintainability
- Testability
- Scalability
- Technology independence
- AI readiness
- Cloud-native design
- Long-term evolution

---

# 5. Dependency Rule

Dependencies shall follow:

```
Presentation
        │
        ▼
Application
        │
        ▼
Domain

Infrastructure
        │
        └──────────────►
Application
```

The Domain layer must never reference:

- Infrastructure
- API
- EF Core
- Azure SDKs
- ASP.NET Core
- UI frameworks

---

# 6. Layer Responsibilities

## Presentation

Responsibilities

- HTTP Endpoints
- Authentication
- Authorization
- Model Binding
- API Documentation

Must NOT contain:

- Business logic
- SQL
- Domain rules

---

## Application

Responsibilities

- CQRS
- Commands
- Queries
- DTOs
- Validators
- Interfaces
- Use Cases
- Domain Event Coordination

Must NOT contain:

- SQL
- Azure SDK logic
- UI logic

---

## Domain

Responsibilities

- Business rules
- Entities
- Value Objects
- Domain Events
- Business invariants

Must NOT depend on any external framework.

---

## Infrastructure

Responsibilities

- Database
- Blob Storage
- Azure SDKs
- Email
- Service Bus
- AI Providers
- Logging

Implements interfaces defined by the Application layer.

---

# 7. Solution Structure

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
```

---

# 8. Benefits

## Separation of Concerns

Each layer has one clear responsibility.

---

## Independent Business Logic

Business rules remain independent from frameworks.

---

## Testability

Domain and Application layers can be tested without Azure resources or databases.

---

## Technology Independence

Infrastructure can change without affecting business logic.

Examples:

- Azure SQL → Cosmos DB
- Azure OpenAI → Other LLM providers
- REST → GraphQL

---

## AI Readiness

AI capabilities become infrastructure concerns.

Application interacts only through interfaces such as:

- IChatCompletionProvider
- IEmbeddingProvider
- IVectorSearchProvider

---

## Cloud Readiness

Azure services are isolated within Infrastructure.

The business logic remains cloud-agnostic.

---

# 9. Consequences

## Positive

- High maintainability.
- Excellent testability.
- Clear architecture.
- Better onboarding.
- Easier technology upgrades.
- Supports long-term growth.

## Negative

- More projects.
- More interfaces.
- Slightly higher learning curve.
- Additional abstraction.

These trade-offs are acceptable for an enterprise platform.

---

# 10. Alternatives Considered

## Alternative 1 — Layered Architecture

Structure:

Controller

↓

Service

↓

Repository

Advantages

- Simple.
- Familiar.
- Fewer projects.

Disadvantages

- Coupled business logic.
- Large services.
- Difficult testing.

Decision

Rejected.

---

## Alternative 2 — Traditional N-Tier Architecture

Advantages

- Well known.
- Easy for small systems.

Disadvantages

- Business logic leaks into infrastructure.
- Harder to evolve.

Decision

Rejected.

---

## Alternative 3 — Vertical Slice Architecture Only

Advantages

- Feature-oriented.
- Excellent with CQRS.

Disadvantages

- Without Clean Architecture, dependency boundaries become weaker.

Decision

Partially adopted.

Vertical Slice organisation will be used **inside the Application layer** while Clean Architecture governs the overall solution.

---

# 11. Implementation Guidelines

Developers shall:

- Keep Domain framework-independent.
- Define interfaces in Application.
- Implement interfaces in Infrastructure.
- Keep Controllers thin.
- Place business rules in Domain.
- Use CQRS for use cases.
- Follow dependency inversion.

---

# 12. Technology Mapping

| Layer | Technologies |
|--------|--------------|
| Presentation | ASP.NET Core, Swagger |
| Application | MediatR, FluentValidation |
| Domain | Plain C# |
| Infrastructure | EF Core, Azure SDKs, Azure SQL, Blob Storage, Redis, Key Vault |
| Testing | xUnit, FluentAssertions |

---

# 13. Risks

Potential risks:

- Over-abstraction.
- Excessive interfaces.
- Business logic leaking into controllers.
- Infrastructure dependencies introduced into Domain.

Mitigation:

- Code reviews.
- Architecture validation.
- ADR compliance.
- Dependency analysis.

---

# 14. Compliance

This decision aligns with:

- SOLID Principles
- Clean Architecture (Robert C. Martin)
- Domain-Driven Design (DDD)
- Azure Well-Architected Framework
- Microsoft .NET Best Practices

---

# 15. Review Criteria

This ADR should be reviewed if:

- A different architectural style is adopted.
- Microservices require different boundaries.
- Platform requirements change significantly.
- The dependency rule can no longer be maintained.

---

# 16. Status History

| Date | Status | Notes |
|------|--------|-------|
| 2026-07-30 | Accepted | Initial architectural decision for ECAP |

---

# 17. Related ADRs

- ADR-001 – Use CQRS
- ADR-003 – Use Azure SQL Database
- ADR-004 – Use Azure API Management
- ADR-005 – Use Bicep for Infrastructure as Code

---

# 18. Summary

ECAP adopts **Clean Architecture** to ensure long-term maintainability, testability and technology independence.

The architecture enforces clear separation of responsibilities, keeps business logic independent of infrastructure and cloud services, and provides a strong foundation for future AI capabilities, event-driven architecture and cloud-native deployment.

Clean Architecture will serve as the architectural backbone for all current and future ECAP modules.
