# EPIC-01: Enterprise Product Catalog

# REST API Design

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | REST API Design |
| Version | 1.0 |
| Status | Draft |
| Owner | API Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the REST API standards and endpoints for the Enterprise Product Catalog.

The API provides a consistent, secure and versioned interface for interacting with Product Catalog resources.

It serves as the contract between client applications and the Product Catalog service.

---

# 2. API Design Principles

The Product Catalog API shall follow these principles:

- Resource-oriented design
- RESTful conventions
- Stateless communication
- JSON payloads
- Consistent naming
- Versioned APIs
- Standard HTTP status codes
- Idempotent operations where applicable
- Consistent error responses
- OpenAPI documentation

---

# 3. Base URL

```
https://api.ecap.com/v1/products
```

API Management (APIM) will expose this endpoint externally.

---

# 4. Resource Model

Primary Resources

- Products
- Categories
- Brands

Sub Resources

- Images
- Specifications
- Metadata

---

# 5. API Endpoints

## Create Product

POST /v1/products

Purpose

Creates a new product.

Business Requirement

FR-001

User Story

US-001

Command

CreateProductCommand

Response

201 Created

---

## Get Product

GET /v1/products/{productId}

Purpose

Retrieves a product.

Business Requirement

FR-003

User Story

US-003

Query

GetProductByIdQuery

Response

200 OK

404 Not Found

---

## Search Products

GET /v1/products

Supported Query Parameters

search

categoryId

brandId

status

page

pageSize

sortBy

sortDirection

Business Requirement

FR-004

User Story

US-004

Query

SearchProductsQuery

---

## Update Product

PUT /v1/products/{productId}

Business Requirement

FR-002

Command

UpdateProductCommand

---

## Delete Product

DELETE /v1/products/{productId}

Business Requirement

FR-005

Command

DeleteProductCommand

Behaviour

Soft Delete

---

## Get Categories

GET /v1/categories

---

## Create Category

POST /v1/categories

---

## Get Brands

GET /v1/brands

---

## Create Brand

POST /v1/brands

---

# 6. Request Example

## Create Product

POST /v1/products

```json
{
  "sku": "LAP-1001",
  "name": "Gaming Laptop",
  "description": "High performance gaming laptop",
  "categoryId": "category-id",
  "brandId": "brand-id",
  "price": 79999,
  "currency": "INR"
}
```

---

# 7. Response Example

```json
{
  "productId": "9c9ef67d",
  "sku": "LAP-1001",
  "name": "Gaming Laptop",
  "status": "Draft",
  "createdOn": "2026-07-30T10:30:00Z"
}
```

---

# 8. Standard HTTP Status Codes

| Status | Meaning |
|---------|----------|
| 200 | Success |
| 201 | Created |
| 204 | No Content |
| 400 | Validation Error |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 409 | Conflict |
| 422 | Business Rule Violation |
| 500 | Internal Server Error |

---

# 9. Standard Error Response

The API follows RFC 7807 (Problem Details).

Example:

```json
{
  "type": "https://api.ecap.com/errors/validation",
  "title": "Validation Failed",
  "status": 400,
  "detail": "SKU already exists.",
  "traceId": "00-a1b2c3..."
}
```

---

# 10. Pagination

Search APIs shall support pagination.

Query Parameters

page

pageSize

Example

GET /v1/products?page=1&pageSize=20

Response

```json
{
  "page": 1,
  "pageSize": 20,
  "totalRecords": 2450,
  "totalPages": 123,
  "items": []
}
```

---

# 11. Filtering

Supported filters

- Category
- Brand
- Status
- Price Range
- Created Date

Example

GET /v1/products?brandId=123&status=Active

---

# 12. Sorting

Supported fields

- Name
- Price
- CreatedOn
- UpdatedOn

Example

GET /v1/products?sortBy=price&sortDirection=asc

---

# 13. Authentication

Authentication

Microsoft Entra ID

Bearer JWT Token

Example

Authorization: Bearer {token}

---

# 14. Authorization

Example Roles

- ProductAdmin
- CategoryManager
- MarketingManager
- ProductViewer

Permissions should be enforced using role-based authorization.

---

# 15. Idempotency

The following operations are idempotent:

- GET
- PUT
- DELETE

POST operations are not idempotent.

Future enhancement:

Support Idempotency-Key header for create operations.

---

# 16. API Versioning

Current Version

v1

Future Versions

v2

v3

Versioning Strategy

URL Versioning

Example

/v1/products

/v2/products

---

# 17. OpenAPI Standards

Every endpoint shall include:

- Summary
- Description
- Request Schema
- Response Schema
- Error Responses
- Security Requirements
- Example Requests
- Example Responses

Swagger/OpenAPI shall be automatically generated.

---

# 18. Traceability

| API | Requirement | Story | CQRS |
|------|-------------|--------|-------|
| POST /products | FR-001 | US-001 | CreateProductCommand |
| PUT /products/{id} | FR-002 | US-002 | UpdateProductCommand |
| GET /products/{id} | FR-003 | US-003 | GetProductByIdQuery |
| GET /products | FR-004 | US-004 | SearchProductsQuery |
| DELETE /products/{id} | FR-005 | US-005 | DeleteProductCommand |

---

# 19. Future API Enhancements

Future APIs include:

- Product Recommendations
- AI Product Assistant
- Product Comparison
- Semantic Search
- Image Search
- Voice Search
- Bulk Product Import
- Bulk Product Export
- Event Streaming APIs
- GraphQL Gateway

---

# 20. API Design Guidelines

The Product Catalog API shall:

- Use nouns instead of verbs.
- Use plural resource names.
- Avoid exposing database schema.
- Return meaningful HTTP status codes.
- Validate all requests.
- Provide consistent error responses.
- Be backward compatible whenever possible.
- Remain implementation independent.

---

# 21. References

- 05-Domain-Model.md
- 06-Architecture.md
- 07-Database.md
- 09-CQRS.md
- 10-Azure-Resources.md
