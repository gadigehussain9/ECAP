# EPIC-01: Enterprise Product Catalog

# Database Design

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | Database Design |
| Version | 1.0 |
| Status | Draft |
| Owner | Data Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the logical and physical database design for the Enterprise Product Catalog.

The objective is to provide a scalable, maintainable, secure and AI-ready data model while keeping the domain independent from the underlying database technology.

The design supports Azure SQL for the initial implementation but can evolve to Cosmos DB or other data stores without changing the business domain.

---

# 2. Database Goals

The database must:

- Maintain data integrity.
- Support high-performance queries.
- Scale with business growth.
- Support auditing.
- Support soft delete.
- Support optimistic concurrency.
- Support future AI capabilities.
- Be cloud-ready.

---

# 3. Database Selection

## Current Database

Azure SQL Database

Reason:

- Strong ACID transactions.
- Relational integrity.
- Mature tooling.
- Excellent EF Core support.
- Easy reporting.
- Familiar to enterprise teams.

---

## Future Databases

Future Epics may introduce:

- Azure Cosmos DB
- Azure AI Search
- Azure Blob Storage
- Azure Data Lake
- Microsoft Fabric

The architecture must support polyglot persistence where appropriate.

---

# 4. High-Level Data Model

```

Category
    │
    │
    │1
    │
    │*
Product
    │
    ├──────── ProductImage
    │
    ├──────── ProductSpecification
    │
    ├──────── ProductMetadata
    │
    └──────── Brand

```

---

# 5. Core Tables

## Product

Purpose

Stores master product information.

Primary Key

ProductId

Important Columns

- ProductId
- SKU
- Name
- Description
- BrandId
- CategoryId
- Status
- Price
- Currency
- CreatedOn
- CreatedBy
- UpdatedOn
- UpdatedBy
- IsDeleted
- RowVersion

---

## Category

Purpose

Stores product categories.

Columns

- CategoryId
- ParentCategoryId
- Name
- Description
- DisplayOrder

Supports future hierarchical categories.

---

## Brand

Purpose

Stores manufacturer information.

Columns

- BrandId
- Name
- Description
- Website

---

## ProductImage

Purpose

Stores image metadata.

Columns

- ProductImageId
- ProductId
- ImageUrl
- ThumbnailUrl
- DisplayOrder
- AltText

Image files themselves are stored in Azure Blob Storage.

---

## ProductSpecification

Purpose

Stores technical specifications.

Examples

RAM

Processor

Weight

Dimensions

Storage

Screen Size

Battery

---

## ProductMetadata

Purpose

Stores SEO and search information.

Examples

MetaTitle

MetaDescription

Keywords

Tags

---

# 6. Relationships

Product

- belongs to one Category
- belongs to one Brand
- has many Images
- has many Specifications
- has one Metadata record

Category

- may have a Parent Category
- may contain many Products

Brand

- may contain many Products

---

# 7. Keys

Primary Keys

- ProductId
- CategoryId
- BrandId
- ProductImageId
- ProductSpecificationId
- ProductMetadataId

Foreign Keys

Product

→ Category

→ Brand

ProductImage

→ Product

ProductSpecification

→ Product

ProductMetadata

→ Product

---

# 8. Constraints

Business constraints include:

- SKU must be unique.
- Product Name is required.
- Category is required.
- Brand is optional.
- Price cannot be negative.
- Status must be valid.
- Deleted products cannot be modified.

---

# 9. Indexing Strategy

Indexes should be created on:

Product

- SKU (Unique)
- Name
- CategoryId
- BrandId
- Status
- CreatedOn

Category

- ParentCategoryId
- Name

Brand

- Name

Metadata

- Keywords

Additional indexes should be introduced based on production query patterns.

---

# 10. Soft Delete Strategy

Products shall not be physically deleted.

Instead:

```

IsDeleted = true

DeletedOn = UTC Timestamp

DeletedBy = User

```

Benefits

- Audit history
- Recovery
- Compliance
- Reporting

---

# 11. Auditing

Every business entity should support auditing.

Common columns

- CreatedOn
- CreatedBy
- UpdatedOn
- UpdatedBy
- DeletedOn
- DeletedBy

Auditing should be implemented consistently across all entities.

---

# 12. Optimistic Concurrency

Every table should support optimistic concurrency.

Recommended column:

```

RowVersion

```

Benefits

- Prevent lost updates.
- Detect concurrent modifications.
- Improve data consistency.

---

# 13. Transactions

Business operations should execute within transactions when multiple entities are modified.

Examples

Create Product

Update Product

Delete Product

The transaction boundary is managed by the Application Layer.

---

# 14. Performance Considerations

The database design should support:

- Efficient filtering.
- Efficient pagination.
- Efficient sorting.
- Efficient indexing.
- Minimal joins where practical.

Large binary files shall never be stored in SQL tables.

---

# 15. Security

Sensitive data shall be protected using:

- Azure SQL encryption at rest
- TLS in transit
- Microsoft Entra ID authentication where applicable
- Least privilege database access
- Parameterised queries (via EF Core)

---

# 16. Backup & Recovery

Production environments should implement:

- Automated backups
- Point-in-time restore
- Geo-redundant backups (where required)
- Disaster recovery procedures

---

# 17. AI Readiness

The schema is designed to support future AI capabilities.

The following fields may later be indexed into Azure AI Search:

- Product Name
- Description
- Specifications
- Metadata
- Keywords
- Category
- Brand

These fields can also be transformed into vector embeddings for semantic search and Retrieval-Augmented Generation (RAG).

---

# 18. Data Lifecycle

Draft

↓

Active

↓

Inactive

↓

Archived

↓

Soft Deleted

The lifecycle supports auditing and historical reporting without permanent data loss.

---

# 19. Future Enhancements

The schema has been designed to accommodate:

- Product Variants
- Product Bundles
- Multi-language descriptions
- Region-specific pricing
- Inventory integration
- Product reviews
- Customer ratings
- AI-generated descriptions
- AI-generated keywords
- Product embeddings
- Event sourcing (future consideration)

---

# 20. Database Design Principles

The Product Catalog database follows these principles:

- Normalise where appropriate.
- Denormalise only for proven performance requirements.
- Prefer immutable audit history.
- Use surrogate keys.
- Keep the Domain Model independent of persistence.
- Optimise based on real workload metrics, not assumptions.

---

# 21. References

- 05-Domain-Model.md
- 06-Architecture.md
- 08-REST-API.md
- 09-CQRS.md
- 10-Azure-Resources.md
