# ECAP Coding Standards

| Item | Value |
|------|-------|
| Document | Coding Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the coding standards for the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Improve code readability.
- Ensure consistency across the codebase.
- Reduce technical debt.
- Improve maintainability.
- Simplify onboarding.
- Enable effective code reviews.
- Produce production-quality software.

These standards apply to all C#, .NET, Azure, AI and Infrastructure code within ECAP.

---

# 2. General Principles

Every developer shall follow:

- SOLID Principles
- Clean Code
- Clean Architecture
- DRY (Don't Repeat Yourself)
- KISS (Keep It Simple)
- YAGNI (You Aren't Gonna Need It)
- CQRS
- Domain-Driven Design (DDD)

Code should optimise for readability and maintainability rather than cleverness.

---

# 3. Naming Conventions

## Projects

```
Ecap.Api
Ecap.Application
Ecap.Domain
Ecap.Infrastructure
Ecap.Contracts
Ecap.SharedKernel
```

---

## Classes

Use PascalCase.

Good

```
Product
ProductRepository
CreateProductCommand
SearchProductsQuery
ProductCreatedEvent
```

Bad

```
product
Product_class
myProduct
```

---

## Interfaces

Prefix with `I`.

```
IProductRepository
ICurrentUserService
IClock
IChatCompletionProvider
```

---

## Methods

Use PascalCase and verbs.

Good

```
CreateProductAsync()
SearchProductsAsync()
DeleteProductAsync()
```

Bad

```
DoIt()
Run()
Method1()
```

---

## Variables

Use meaningful camelCase names.

Good

```
product
category
productId
searchRequest
```

Bad

```
obj
temp
data
x
```

---

## Constants

Use PascalCase.

```
DefaultPageSize
MaximumRetryCount
```

---

## Enums

Use singular nouns.

```
OrderStatus
PaymentType
ProductState
```

---

# 4. File Organisation

One public class per file.

File name must match the class name.

Example

```
CreateProductCommand.cs

ProductRepository.cs

Product.cs
```

---

# 5. Class Design

Classes should:

- Have a single responsibility.
- Be cohesive.
- Be easy to test.
- Be small and focused.

Avoid "God Classes" with multiple responsibilities.

---

# 6. Method Design

Methods should:

- Perform one task.
- Be easy to understand.
- Have descriptive names.
- Return early when appropriate.
- Avoid excessive nesting.

Aim for methods generally under **30 lines**, unless a longer method clearly improves readability.

---

# 7. Asynchronous Programming

Prefer asynchronous APIs.

Good

```csharp
await repository.GetByIdAsync(id, cancellationToken);
```

Bad

```csharp
repository.GetById(id);

repository.GetByIdAsync(id).Result;

repository.GetByIdAsync(id).Wait();
```

Always propagate `CancellationToken` through async call chains.

---

# 8. Exception Handling

Use exceptions only for exceptional situations.

Do not swallow exceptions.

Good

```csharp
try
{
    await repository.SaveChangesAsync(cancellationToken);
}
catch (SqlException ex)
{
    logger.LogError(ex, "Database update failed.");
    throw;
}
```

Bad

```csharp
catch
{
}
```

---

# 9. Logging

Use structured logging.

Good

```csharp
logger.LogInformation(
    "Product {ProductId} created by {UserId}",
    product.Id,
    userId);
```

Bad

```csharp
logger.LogInformation(
    $"Product {product.Id} created");
```

Never log:

- Passwords
- Access tokens
- API keys
- Connection strings
- Personal information
- Secrets

---

# 10. Dependency Injection

Use constructor injection.

Good

```csharp
public class ProductService
{
    private readonly IProductRepository repository;

    public ProductService(IProductRepository repository)
    {
        this.repository = repository;
    }
}
```

Avoid:

- Service Locator
- Static services
- Manual dependency creation

---

# 11. Repository Rules

Repositories should:

- Encapsulate persistence.
- Return domain entities.
- Be asynchronous.
- Hide EF Core implementation details.

Repositories must not:

- Contain business rules.
- Call external APIs.
- Access HTTP context.

---

# 12. Entity Framework Core

Use:

- Fluent API configuration.
- Migrations.
- AsNoTracking() for read operations.
- Optimistic concurrency where appropriate.
- Cancellation tokens.

Avoid:

- Lazy loading.
- N+1 query problems.
- Raw SQL unless justified.

---

# 13. CQRS Standards

Commands

- Change system state.
- Return minimal responses.
- Publish domain events when required.

Queries

- Never modify data.
- Return DTOs.
- Support pagination, filtering and sorting.

Handlers

- One responsibility.
- No presentation logic.
- No HTTP context usage.

---

# 14. Validation

Use FluentValidation.

Validate:

- Required fields.
- Length.
- Formats.
- Business rules.
- Ranges.

Validation should occur before business logic.

---

# 15. API Standards

Controllers should:

- Be thin.
- Delegate work to MediatR.
- Return appropriate HTTP status codes.
- Return Problem Details for errors.

Controllers must not contain business logic.

---

# 16. Comments

Prefer self-explanatory code.

Write comments only when they add value.

Good examples:

- Business rules
- Complex algorithms
- Non-obvious decisions
- External constraints

Avoid comments that simply restate the code.

---

# 17. Magic Values

Avoid hard-coded values.

Bad

```csharp
if (price > 100)
```

Good

```csharp
if (price > BusinessRules.MaximumDiscountPrice)
```

---

# 18. Configuration

Configuration belongs in:

- appsettings.json
- Azure App Configuration
- Azure Key Vault
- Environment variables

Never hard-code:

- URLs
- Secrets
- Keys
- Connection strings

---

# 19. Testing Expectations

Every feature should include:

- Unit Tests
- Integration Tests
- API Tests (where applicable)

Code should be designed for testability.

---

# 20. Code Review Checklist

Reviewers should verify:

- Correctness.
- Readability.
- Simplicity.
- Performance.
- Security.
- Test coverage.
- Logging.
- Exception handling.
- Documentation updates.

---

# 21. Code Smells

Avoid:

- Long methods.
- Large classes.
- Duplicate logic.
- Deep nesting.
- Primitive obsession.
- Feature envy.
- Excessive parameters.
- Circular dependencies.

---

# 22. Performance Guidelines

Prefer:

- Asynchronous I/O.
- Pagination.
- Efficient LINQ queries.
- Caching where appropriate.
- Batch operations.
- Streaming for large datasets.

Measure performance before optimising.

---

# 23. Security Guidelines

Always:

- Validate input.
- Use parameterised queries.
- Enforce authorisation.
- Protect sensitive data.
- Use Managed Identity where supported.
- Retrieve secrets from Azure Key Vault.

---

# 24. AI Coding Guidelines

AI-related code shall:

- Depend on provider interfaces.
- Avoid vendor-specific logic in business code.
- Log AI requests without exposing sensitive prompts.
- Capture latency and token usage.
- Support prompt versioning.

---

# 25. Git Standards

Branch names:

```
feature/product-search

feature/product-create

bugfix/product-validation
```

Commit format:

```
feat(product): add create product command

fix(product): validate duplicate sku

refactor(product): simplify repository

test(product): add integration tests

docs(product): update API documentation
```

---

# 26. Definition of Done

Code is complete only when:

- Builds successfully.
- Passes all tests.
- Meets coding standards.
- Has no critical warnings.
- Passes code review.
- Documentation is updated.
- CI/CD pipeline succeeds.

---

# 27. References

- ADR-001 – Use CQRS
- ADR-002 – Adopt Clean Architecture
- ADR-003 – Use Azure SQL Database
- ADR-004 – Adopt Azure AI Foundry and Azure OpenAI
- ADR-005 – Use Bicep
- 15-Implementation-Guide.md
- 14-Testing.md
