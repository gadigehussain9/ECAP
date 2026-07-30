# ECAP Logging Standards

| Item | Value |
|------|-------|
| Document | Logging Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the logging standards for the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Improve production diagnostics
- Simplify troubleshooting
- Support distributed tracing
- Improve observability
- Enable proactive monitoring
- Support auditing
- Reduce Mean Time To Resolution (MTTR)

These standards apply to all applications, APIs, background services, AI services and infrastructure components.

---

# 2. Logging Principles

Logging must be:

- Structured
- Consistent
- Actionable
- Secure
- Correlated
- Minimal but sufficient
- Machine readable

Logs should help answer:

- What happened?
- When did it happen?
- Where did it happen?
- Why did it happen?
- Who initiated it?
- How can it be investigated?

---

# 3. Logging Framework

ECAP uses:

- Microsoft.Extensions.Logging
- OpenTelemetry
- Azure Application Insights
- Azure Monitor
- Log Analytics

Application code must never depend directly on a specific logging vendor.

---

# 4. Log Levels

Use log levels consistently.

| Level | Purpose |
|--------|----------|
| Trace | Detailed diagnostic information |
| Debug | Development diagnostics |
| Information | Normal business operations |
| Warning | Recoverable problems |
| Error | Failed operations |
| Critical | System unavailable or data loss |

---

# 5. When to Log

## Information

Log:

- API requests
- Business operations
- Background job execution
- Domain events
- Startup and shutdown

Example

```
Product created.
Order submitted.
Payment completed.
```

---

## Warning

Log:

- Validation warnings
- Retry attempts
- Slow dependencies
- Missing optional data
- Rate limiting

---

## Error

Log:

- Exceptions
- Database failures
- AI service failures
- External service failures
- Authentication failures

---

## Critical

Log:

- Application startup failure
- Database unavailable
- Key Vault unavailable
- Azure outage affecting ECAP
- Data corruption
- Unrecoverable failures

---

# 6. Structured Logging

Always use structured logging.

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
    $"Product {product.Id} created.");
```

Benefits:

- Searchable
- Filterable
- Queryable
- Better analytics

---

# 7. Correlation

Every request must include:

```
X-Correlation-ID
```

Every log entry should include:

- CorrelationId
- TraceId
- SpanId
- UserId (when available)
- RequestId

Correlation must propagate across:

- API
- Service Bus
- Background jobs
- AI services
- External APIs

---

# 8. Contextual Information

Include relevant business context.

Examples:

- ProductId
- OrderId
- CustomerId
- PaymentId
- VendorId
- AIRequestId

Do not include unnecessary data.

---

# 9. Exception Logging

Always log the exception object.

Good

```csharp
logger.LogError(
    exception,
    "Failed to create product {ProductId}",
    productId);
```

Avoid

```csharp
logger.LogError(
    exception.Message);
```

---

# 10. Sensitive Data

Never log:

- Passwords
- JWT tokens
- API keys
- Client secrets
- Connection strings
- Credit card numbers
- CVV
- Personal health information
- Raw prompts containing confidential data
- Embedding vectors

Mask sensitive values when required.

---

# 11. HTTP Logging

Log:

- HTTP method
- Route
- Status code
- Duration
- Correlation ID

Do not log:

- Authorization headers
- Cookies
- Request bodies containing sensitive information

---

# 12. Database Logging

Log:

- Query execution time
- Connection failures
- Deadlocks
- Timeout exceptions

Do not log:

- SQL containing sensitive values
- Credentials

---

# 13. AI Logging

Log:

- Model name
- Prompt version
- Completion latency
- Token usage
- Completion status
- Content filter results
- Correlation ID

Do not log:

- Sensitive prompts
- Confidential documents
- Secrets supplied to AI
- Full AI responses containing sensitive information

---

# 14. Performance Logging

Log when operations exceed thresholds.

Recommended defaults:

| Operation | Threshold |
|-----------|-----------|
| API request | >500 ms |
| Database query | >200 ms |
| External API | >1000 ms |
| AI completion | >3000 ms |

Thresholds may be adjusted based on production telemetry.

---

# 15. Distributed Tracing

All services shall support distributed tracing.

Trace propagation includes:

- API Gateway
- API
- Application
- Database
- Azure Service Bus
- Azure AI Foundry
- External APIs

Use the W3C Trace Context standard.

---

# 16. Background Jobs

Log:

- Job started
- Job completed
- Duration
- Retry count
- Failures

Every execution must have a correlation ID.

---

# 17. Audit Logging

Audit logs are separate from application logs.

Audit:

- User sign-in
- Administrative actions
- Product changes
- Price changes
- Role changes
- Permission changes
- AI configuration changes

Audit logs must be immutable.

---

# 18. Retention

Recommended retention:

| Environment | Retention |
|-------------|-----------|
| Development | 30 days |
| Test | 30 days |
| QA | 60 days |
| Production | 180 days |

Retention should comply with organisational and regulatory requirements.

---

# 19. Monitoring

Monitor:

- Error rate
- Exception count
- Response time
- Database latency
- AI latency
- Token usage
- Service Bus failures
- Cache misses
- Failed authentications

Create alerts for critical thresholds.

---

# 20. Logging Checklist

Every feature should log:

- Start of operation
- Successful completion
- Errors
- Execution time
- Correlation ID
- Business identifier (where applicable)

---

# 21. Kusto (KQL) Readiness

Logs should support efficient KQL queries.

Example investigations:

- Failed requests
- Slow endpoints
- AI latency
- Authentication failures
- Database timeouts
- Service Bus retries

Use consistent property names to simplify querying.

---

# 22. Best Practices

- Use structured logging.
- Log exceptions with stack traces.
- Include business context.
- Avoid duplicate logs.
- Do not over-log.
- Use the correct log level.
- Protect sensitive information.
- Propagate correlation IDs.
- Prefer telemetry over verbose logging.

---

# 23. References

- ADR-004 – Adopt Azure AI Foundry and Azure OpenAI
- Coding Standards
- API Standards
- Security Standards
- OpenTelemetry Specification
- Azure Monitor Documentation
- Azure Application Insights Documentation
