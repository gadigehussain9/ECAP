# EPIC-01: Enterprise Product Catalog

# Observability

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | Observability |
| Version | 1.0 |
| Status | Approved |
| Owner | Site Reliability Engineer |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the observability strategy for the Enterprise Product Catalog.

Observability enables engineering teams to understand the health, behaviour and performance of the application through logs, metrics and traces.

The goal is to detect issues quickly, reduce Mean Time To Detect (MTTD) and Mean Time To Recover (MTTR), and provide actionable insights into production systems.

---

# 2. Observability Goals

The Product Catalog shall provide:

- End-to-end request tracing.
- Structured logging.
- Application metrics.
- Infrastructure metrics.
- Distributed tracing.
- Health monitoring.
- Performance monitoring.
- Alerting.
- Dashboards.
- Production diagnostics.

---

# 3. Pillars of Observability

The observability strategy is based on three pillars:

## Logs

Capture application events.

Examples

- Product Created
- Product Updated
- Product Deleted
- Authentication Failure
- Validation Failure

---

## Metrics

Measure application health.

Examples

- Request Count
- Error Rate
- Response Time
- CPU Usage
- Memory Usage
- Database Connections

---

## Traces

Track request flow across components.

Example

```
Browser

↓

API Management

↓

App Service

↓

MediatR

↓

Repository

↓

Azure SQL

↓

Response
```

---

# 4. Azure Services

| Service | Purpose |
|----------|---------|
| Application Insights | Application telemetry |
| Azure Monitor | Metrics & alerts |
| Log Analytics | Central log storage |
| Azure Dashboard | Visual dashboards |
| Azure Service Health | Azure platform events |

---

# 5. Logging Strategy

All application logs shall be structured.

Recommended fields:

- Timestamp
- CorrelationId
- RequestId
- UserId
- Environment
- ServiceName
- OperationName
- LogLevel
- Duration
- Result
- Exception (if any)

---

# 6. Log Levels

| Level | Usage |
|--------|-------|
| Trace | Detailed diagnostics |
| Debug | Development troubleshooting |
| Information | Business events |
| Warning | Recoverable issues |
| Error | Request failures |
| Critical | Service unavailable |

---

# 7. Business Events

Important business events should be logged.

Examples

- ProductCreated
- ProductUpdated
- ProductDeleted
- ProductArchived
- ProductActivated

Each event should include:

- ProductId
- SKU
- UserId
- Timestamp
- CorrelationId

---

# 8. Correlation IDs

Every request shall have a Correlation ID.

The Correlation ID must flow through:

```
Client

↓

API Management

↓

ASP.NET Core

↓

MediatR

↓

Repository

↓

Azure SQL

↓

Application Insights
```

This enables end-to-end troubleshooting.

---

# 9. Distributed Tracing

Distributed tracing shall capture:

- Request duration
- Dependency duration
- Database calls
- External API calls
- Azure SDK calls

Every dependency should appear in a single trace.

---

# 10. Application Metrics

Key metrics:

- Total Requests
- Successful Requests
- Failed Requests
- Requests Per Second
- Average Response Time
- 95th Percentile Latency
- 99th Percentile Latency

---

# 11. Infrastructure Metrics

Monitor:

- CPU
- Memory
- Disk
- Network
- App Service Instance Count
- SQL DTU/vCore Usage
- Storage Capacity

---

# 12. Dependency Monitoring

Track:

- Azure SQL
- Blob Storage
- Key Vault
- Redis Cache
- Azure AI Services (future)

Metrics:

- Availability
- Latency
- Failure Rate

---

# 13. Health Checks

Endpoints

```
GET /health
GET /health/live
GET /health/ready
```

Checks

- Database connectivity
- Blob Storage connectivity
- Key Vault access
- Configuration availability

---

# 14. Alerting Strategy

Alerts should be configured for:

- High error rate
- Increased latency
- Failed deployments
- Database unavailable
- High CPU
- High memory
- Storage failures
- Authentication failures

Alerts should notify the operations team.

---

# 15. Dashboards

Recommended dashboards:

## Executive Dashboard

- Availability
- SLA
- Error Rate

---

## Engineering Dashboard

- Request Rate
- Response Time
- Exceptions
- Dependency Failures

---

## Operations Dashboard

- Infrastructure Health
- CPU
- Memory
- Database Health
- Storage Health

---

# 16. KQL Examples

## Failed Requests

```kusto
requests
| where success == false
| order by timestamp desc
```

---

## Slow Requests

```kusto
requests
| where duration > 2s
| project timestamp, name, duration
```

---

## Exceptions

```kusto
exceptions
| order by timestamp desc
```

---

## Top API Operations

```kusto
requests
| summarize Count = count() by name
| order by Count desc
```

---

# 17. Performance Monitoring

Monitor:

- API latency
- Database query duration
- Repository execution time
- MediatR handler execution time
- External dependency latency

Long-running operations should be investigated.

---

# 18. SLA, SLI and SLO

## SLA (Service Level Agreement)

Availability commitment to consumers.

Example

99.9% API availability.

---

## SLI (Service Level Indicator)

Measured values.

Examples

- Availability
- Response time
- Error rate

---

## SLO (Service Level Objective)

Internal targets.

Examples

- 95% of requests < 500 ms
- Error rate < 1%
- API availability > 99.9%

---

# 19. Incident Response

When an incident occurs:

1. Detect alert.
2. Verify impact.
3. Identify root cause.
4. Mitigate issue.
5. Restore service.
6. Conduct post-incident review.
7. Record lessons learned.

---

# 20. AI Observability (Future)

Future AI workloads should capture:

- Prompt execution time
- Token usage
- Model latency
- AI request failures
- Content filter events
- Embedding generation duration

These metrics will be collected alongside standard application telemetry.

---

# 21. Traceability Matrix

| Capability | Azure Service |
|------------|---------------|
| Logging | Application Insights |
| Metrics | Azure Monitor |
| Tracing | Application Insights |
| Queries | Log Analytics |
| Dashboards | Azure Dashboard |
| Alerts | Azure Monitor Alerts |

---

# 22. Best Practices

- Use structured logging.
- Never log secrets or personal data.
- Propagate Correlation IDs.
- Monitor business KPIs as well as technical metrics.
- Keep alerts actionable to reduce alert fatigue.
- Review telemetry regularly to improve reliability.

---

# 23. References

- 10-Azure-Resources.md
- 11-Security.md
- 12-Deployment.md
- 14-Testing.md
