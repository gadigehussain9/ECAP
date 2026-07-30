# ECAP Testing Standards

| Item | Value |
|------|-------|
| Document | Testing Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the testing standards for the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Deliver reliable software
- Prevent regressions
- Improve maintainability
- Detect defects early
- Support continuous delivery
- Build confidence in production deployments

Testing is the responsibility of every developer.

---

# 2. Testing Principles

ECAP follows these principles:

- Shift Left Testing
- Test Pyramid
- Automation First
- Repeatable Tests
- Fast Feedback
- Independent Tests
- Deterministic Results
- Production-like Test Environments

---

# 3. Testing Pyramid

```
                 E2E Tests
               --------------
             Integration Tests
          -----------------------
              Unit Tests
---------------------------------------
```

Recommended distribution:

| Test Type | Target Percentage |
|------------|------------------:|
| Unit Tests | 70% |
| Integration Tests | 20% |
| End-to-End/API Tests | 10% |

---

# 4. Test Types

## Unit Tests

Purpose

- Verify business logic.
- Validate domain rules.
- Execute quickly.
- Run without external dependencies.

Examples

- Domain entities
- Value objects
- Validators
- Command handlers (using mocks)
- Utility classes

---

## Integration Tests

Purpose

Verify interactions with infrastructure.

Examples

- EF Core
- Azure SQL
- Azure Storage
- Azure Service Bus
- Azure AI Search
- Azure OpenAI (test environment or mocked provider)
- Repository implementations

---

## API Tests

Purpose

Verify REST endpoints.

Validate:

- Routing
- Authentication
- Authorization
- Validation
- Serialization
- Status codes
- Problem Details responses

---

## End-to-End Tests

Purpose

Validate complete business workflows.

Examples

- Create Product
- Place Order
- Cancel Order
- Checkout
- AI Product Recommendation

E2E tests should focus on critical business journeys.

---

## Performance Tests

Measure:

- Response time
- Throughput
- Scalability
- Resource utilisation

Performance tests should run before major releases.

---

## Security Tests

Validate:

- Authentication
- Authorization
- Input validation
- Injection protection
- Rate limiting
- Access control

Security testing should be part of every release cycle.

---

# 5. Testing Tools

| Area | Tool |
|------|------|
| Unit Testing | xUnit |
| Assertions | FluentAssertions |
| Mocking | NSubstitute (preferred) or Moq |
| API Testing | ASP.NET Core Test Host |
| Integration Testing | Testcontainers / SQL Test Database |
| Code Coverage | Coverlet |
| Performance | k6 |
| Load Testing | Azure Load Testing |
| Static Analysis | Roslyn Analyzers |
| Security Scanning | GitHub Advanced Security / Microsoft Defender for DevOps (where available) |

---

# 6. Project Structure

```
tests/

├── Ecap.Domain.UnitTests
├── Ecap.Application.UnitTests
├── Ecap.Infrastructure.IntegrationTests
├── Ecap.Api.IntegrationTests
├── Ecap.EndToEndTests
├── Ecap.ArchitectureTests
└── Ecap.PerformanceTests
```

---

# 7. Unit Testing Standards

Each unit test should:

- Test one behaviour.
- Follow the Arrange-Act-Assert pattern.
- Be isolated.
- Be repeatable.
- Execute in milliseconds.

Example

```csharp
[Fact]
public async Task CreateProduct_Should_Return_ProductId()
{
    // Arrange

    // Act

    // Assert
}
```

---

# 8. Naming Convention

Preferred format:

```
Method_Should_ExpectedResult_When_Condition
```

Examples

```
CreateProduct_Should_CreateProduct_When_RequestIsValid

DeleteProduct_Should_ReturnNotFound_When_ProductDoesNotExist

ReserveInventory_Should_ThrowException_When_QuantityIsNegative
```

---

# 9. Assertions

Use FluentAssertions.

Good

```csharp
result.Should().NotBeNull();

result.Name.Should().Be("Laptop");

result.Products.Should().HaveCount(10);
```

Avoid:

```csharp
Assert.True(result != null);
```

unless no equivalent assertion exists.

---

# 10. Mocking

Mock only external dependencies.

Mock:

- Repository interfaces
- Time providers
- AI providers
- External APIs
- Messaging

Do not mock:

- Domain entities
- Value objects
- Simple DTOs

---

# 11. Test Data

Prefer builders or factories.

Examples

```
ProductBuilder

CustomerBuilder

OrderBuilder
```

Avoid duplicated object creation across tests.

---

# 12. Test Isolation

Tests must:

- Not depend on execution order.
- Not share mutable state.
- Clean up after execution.
- Be runnable in parallel where appropriate.

---

# 13. Database Testing

Integration tests should use:

- Dedicated test databases
- Disposable databases
- Testcontainers where practical

Do not run tests against production databases.

---

# 14. API Testing

Verify:

- HTTP status codes
- Response body
- Validation
- Authentication
- Authorization
- Pagination
- Filtering
- Sorting
- Problem Details responses

---

# 15. AI Testing

Validate:

- Prompt execution
- Token usage recording
- Timeout handling
- Retry behaviour
- Provider abstraction
- Content filter handling
- Fallback behaviour

Do not rely on live LLM responses for deterministic unit tests.

---

# 16. Architecture Tests

Automated architecture tests shall verify:

- Domain does not reference Infrastructure.
- Domain does not reference ASP.NET Core.
- Application does not reference Azure SDKs.
- Controllers do not access repositories directly.
- Commands have handlers.
- Queries have handlers.

Recommended tools:

- NetArchTest
- ArchUnitNET

---

# 17. Code Coverage

Recommended minimums:

| Layer | Minimum |
|--------|---------:|
| Domain | 95% |
| Application | 90% |
| Infrastructure | 80% |
| API | 80% |

Coverage is a quality indicator, not the sole measure of test quality.

---

# 18. CI/CD Quality Gates

Every Pull Request must:

- Build successfully
- Pass all tests
- Meet coverage thresholds
- Pass static analysis
- Pass architecture tests
- Pass security scanning

Deployments must stop if mandatory quality gates fail.

---

# 19. Performance Targets

Recommended targets:

| Operation | Target |
|-----------|--------|
| Unit Test | <100 ms |
| Integration Test | <5 s |
| API Test | <2 s |
| Critical API (95th percentile) | <500 ms |

Performance budgets should be reviewed periodically.

---

# 20. Definition of Done

A feature is complete only when:

- Unit tests are implemented.
- Integration tests are added where required.
- API tests are updated.
- Critical paths have end-to-end coverage.
- Logging is verified.
- Security requirements are validated.
- Documentation is updated.
- CI/CD pipeline passes.

---

# 21. Anti-Patterns

Avoid:

- Sleeping in tests.
- Random test data without a fixed seed.
- Tests depending on current time (inject a clock instead).
- Shared databases between parallel test runs.
- Network calls in unit tests.
- Ignoring flaky tests.

---

# 22. Best Practices

- Write tests with the feature.
- Keep tests readable.
- Test behaviour, not implementation details.
- Prefer integration tests over excessive mocking.
- Keep tests deterministic.
- Review tests during code review.

---

# 23. References

- ADR-001 – Use CQRS
- ADR-002 – Adopt Clean Architecture
- ADR-004 – Adopt Azure AI Foundry and Azure OpenAI
- Coding Standards
- API Standards
- Security Standards
- Logging Standards
- Microsoft Testing Best Practices
- xUnit Documentation
- FluentAssertions Documentation
