# ECAP API Standards

| Item | Value |
|------|-------|
| Document | API Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | Principal Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the API design standards for ECAP.

All HTTP APIs must follow consistent REST principles to ensure they are:

- Predictable
- Secure
- Maintainable
- Discoverable
- Versioned
- Easy to consume
- Enterprise ready

These standards apply to all internal and external APIs.

---

# 2. API Design Principles

Every API should be:

- Resource-oriented
- Stateless
- Idempotent where applicable
- Versioned
- Secure by default
- Observable
- Backward compatible
- Well documented

---

# 3. Base URL

```
https://api.ecap.com/api/v1
```

Development

```
https://dev-api.ecap.com/api/v1
```

Test

```
https://test-api.ecap.com/api/v1
```

Future API versions

```
/api/v2
/api/v3
```

---

# 4. Resource Naming

Use plural nouns.

Good

```
/products
/orders
/customers
/categories
```

Bad

```
/getProducts
/createProduct
/productList
```

Resources represent nouns, not actions.

---

# 5. HTTP Methods

| Method | Purpose | Idempotent |
|---------|----------|------------|
| GET | Retrieve data | Yes |
| POST | Create resource | No |
| PUT | Replace resource | Yes |
| PATCH | Partial update | No |
| DELETE | Delete resource | Yes |

Examples

```
GET /products

GET /products/{id}

POST /products

PUT /products/{id}

PATCH /products/{id}

DELETE /products/{id}
```

---

# 6. HTTP Status Codes

| Code | Meaning |
|------|----------|
| 200 | OK |
| 201 | Created |
| 202 | Accepted |
| 204 | No Content |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 422 | Unprocessable Entity |
| 429 | Too Many Requests |
| 500 | Internal Server Error |
| 503 | Service Unavailable |

Return the most appropriate status code.

---

# 7. Resource Identifiers

Use GUIDs by default.

Example

```
GET /products/6aefdfb8-58a9-41a2-b64e-7bb43b4fcbcb
```

Avoid exposing database identity values unless there is a business requirement.

---

# 8. Request Body

POST

```json
{
  "sku": "IPHONE-16-BLK",
  "name": "iPhone 16",
  "price": 99999,
  "categoryId": "..."
}
```

Use camelCase JSON properties.

---

# 9. Response Body

Successful response

```json
{
  "id": "...",
  "sku": "IPHONE-16-BLK",
  "name": "iPhone 16",
  "price": 99999
}
```

Responses should be DTOs.

Never expose EF Core entities.

---

# 10. Pagination

Collections must support pagination.

Example

```
GET /products?page=1&pageSize=20
```

Response

```json
{
  "items": [],
  "page": 1,
  "pageSize": 20,
  "totalCount": 1000,
  "totalPages": 50
}
```

Default page size: **20**

Maximum page size: **100**

---

# 11. Filtering

Example

```
GET /products?category=Mobiles
```

Multiple filters

```
GET /products?brand=Apple&category=Mobiles
```

Filtering must be server-side.

---

# 12. Sorting

Example

```
GET /products?sort=name
```

Descending

```
GET /products?sort=-price
```

Allow sorting only on approved fields.

---

# 13. Searching

Example

```
GET /products?search=iphone
```

Search should support:

- Partial matching
- Case-insensitive matching

Future enhancements:

- Semantic search
- Vector search
- AI-assisted search

---

# 14. Versioning

Use URL versioning.

```
/api/v1/products

/api/v2/products
```

Breaking changes require a new API version.

Non-breaking changes should remain within the current version.

---

# 15. Validation

Validate all inputs.

Examples

- Required fields
- Length
- Range
- Format
- Business rules

Return **400 Bad Request** for validation failures.

---

# 16. Error Handling

Return **RFC 7807 Problem Details**.

Example

```json
{
  "type": "https://api.ecap.com/errors/validation",
  "title": "Validation Failed",
  "status": 400,
  "detail": "SKU already exists.",
  "traceId": "..."
}
```

Do not expose:

- Stack traces
- SQL errors
- Internal exception messages

---

# 17. Authentication

All protected APIs require:

- Microsoft Entra ID JWT access token

Example

```
Authorization: Bearer <token>
```

Authentication should be enforced by Azure API Management where appropriate, with application-level authorization as defence in depth.

---

# 18. Authorization

Use policy-based authorization.

Examples

```
Catalog.Read

Catalog.Write

Orders.Read

Orders.Write
```

Avoid role checks directly in controllers.

---

# 19. Idempotency

Support idempotency for operations where duplicate requests are possible.

Examples

```
POST /orders
POST /payments
```

Use an `Idempotency-Key` header for applicable operations.

---

# 20. Correlation ID

Every request should include:

```
X-Correlation-ID
```

If absent, the API generates one.

The value must flow through logs, telemetry and downstream services.

---

# 21. API Documentation

Every endpoint must include:

- Summary
- Description
- Request schema
- Response schema
- Status codes
- Authentication requirements
- Example requests
- Example responses

Swagger/OpenAPI documentation must be generated automatically.

---

# 22. API Lifecycle

Every API follows:

```
Design

↓

Review

↓

Implementation

↓

Testing

↓

Deployment

↓

Monitoring

↓

Versioning

↓

Retirement
```

---

# 23. Performance

Recommended targets:

- Average response time < 300 ms
- 95th percentile < 500 ms
- 99th percentile < 1 second

Large responses must be paginated.

Compression should be enabled.

---

# 24. Security

APIs must:

- Validate all input
- Enforce HTTPS
- Require authentication
- Apply authorization
- Support rate limiting
- Validate content type
- Protect against injection attacks
- Never expose sensitive information

---

# 25. API Management

All public APIs are published through Azure API Management.

Responsibilities include:

- Authentication
- JWT validation
- Rate limiting
- Quotas
- Request transformation
- Response transformation
- Caching (where appropriate)
- Header enrichment
- Centralised logging

Business logic remains inside ECAP services.

---

# 26. AI APIs

Future AI endpoints

```
POST /ai/chat

POST /ai/recommendations

POST /ai/embeddings

POST /ai/search
```

AI endpoints must:

- Capture token usage
- Log latency
- Support prompt versioning
- Enforce content safety
- Record correlation IDs

---

# 27. API Deprecation

Deprecated APIs must:

- Be documented
- Provide a migration path
- Announce retirement dates
- Include deprecation response headers where appropriate

Support periods should follow organisational release policies.

---

# 28. Best Practices

- Use nouns, not verbs.
- Keep controllers thin.
- Return DTOs only.
- Support pagination.
- Use asynchronous programming.
- Use cancellation tokens.
- Emit structured logs.
- Validate all inputs.
- Document every endpoint.
- Keep APIs backward compatible whenever possible.

---

# 29. References

- ADR-001 – Use CQRS
- ADR-002 – Adopt Clean Architecture
- ADR-004 – Adopt Azure AI Foundry and Azure OpenAI
- Microsoft REST API Guidelines
- RFC 9110 – HTTP Semantics
- RFC 7807 – Problem Details for HTTP APIs
