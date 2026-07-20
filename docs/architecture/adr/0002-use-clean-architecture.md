# 2. Use Clean Architecture

Date: 2026-07-20

## Status

Accepted

## Context

We need an architectural pattern that provides clear separation of concerns, testability, and maintainability for our enterprise e-commerce platform.

## Decision

We will implement Clean Architecture (also known as Hexagonal Architecture or Ports and Adapters) with the following layers:

1. **Core** (innermost)
   - `SharedKernel`: Domain primitives (Entity, ValueObject, Result, Guard)
   - `Domain`: Business entities, value objects, domain services, repository interfaces
   - `Application`: Use cases, CQRS handlers, DTOs, application services

2. **Infrastructure** (outer)
   - `Infrastructure.Persistence`: EF Core, DbContext, repository implementations
   - `Infrastructure.Identity`: Authentication/Authorization (JWT, Identity)
   - `Infrastructure.ExternalServices`: Third-party integrations (email, payment)
   - `Infrastructure.Messaging`: Event bus implementations (RabbitMQ, Azure Service Bus)

3. **Presentation** (outermost)
   - `Api`: ASP.NET Core Web API, controllers, middleware

### Dependency Rules
- Core layers depend only on themselves (Domain → SharedKernel, Application → Domain)
- Infrastructure depends on Core (implements interfaces from Application/Domain)
- Presentation depends on Infrastructure (for DI) and Application (for use cases)

### Benefits
- **Testability**: Core business logic can be tested without external dependencies
- **Independence**: Business rules don't depend on UI, database, or external agencies
- **Flexibility**: Easy to swap infrastructure implementations (e.g., change database)
- **Maintainability**: Clear boundaries make code easier to understand and modify

## Consequences

### Positive
- High testability through dependency injection and interface abstraction
- Business logic remains stable as technology changes
- Multiple teams can work on different layers simultaneously
- Easy to add new features without affecting existing code

### Negative
- More initial setup complexity compared to traditional layered architecture
- Requires discipline to maintain architectural boundaries
- May seem over-engineered for simple CRUD applications

### Mitigation
- Use ArchitectureTests to enforce dependency rules automatically
- Document architectural decisions in ADRs
- Provide clear examples and templates for new features
