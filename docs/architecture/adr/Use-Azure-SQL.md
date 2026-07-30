# ADR-003: Adopt Azure SQL Database

| Item | Value |
|------|-------|
| ADR Number | ADR-003 |
| Title | Adopt Azure SQL Database |
| Status | Accepted |
| Date | 2026-07-30 |
| Decision Makers | Principal Architect, Solution Architect, Development Team |
| Epic | Enterprise Commerce & AI Platform (ECAP) |
| Related Documents | 07-Database.md, 10-Azure-Resources.md, 15-Implementation-Guide.md |

---

# 1. Context

The Enterprise Commerce & AI Platform (ECAP) manages transactional business data across multiple domains including:

- Product Catalog
- Orders
- Inventory
- Customers
- Payments
- Vendors
- Promotions
- Reviews

These domains require:

- ACID transactions
- Strong consistency
- Relational modelling
- Referential integrity
- Complex filtering
- Reporting
- Auditing
- High availability

The platform will run on Microsoft Azure and integrate with other Azure services.

---

# 2. Decision

ECAP will use **Azure SQL Database** as the primary transactional database.

Azure SQL Database will be the system of record for all business-critical transactional data.

Database access will be encapsulated through repositories within the Infrastructure layer.

---

# 3. Decision Drivers

The decision is based on the following requirements:

- Strong consistency
- ACID transactions
- Mature relational engine
- Excellent .NET support
- Cloud-native managed service
- High availability
- Automatic backups
- Security features
- Operational simplicity
- Enterprise scalability

---

# 4. Architecture Overview

```
ASP.NET Core API
        │
        ▼
Application Layer
        │
        ▼
Repository Interfaces
        │
        ▼
Infrastructure Layer
        │
        ▼
Entity Framework Core
        │
        ▼
Azure SQL Database
```

The Domain and Application layers remain independent of the database technology.

---

# 5. Benefits

## Relational Model

Supports:

- One-to-many relationships
- Many-to-many relationships
- Foreign keys
- Constraints
- Normalisation

Ideal for transactional systems.

---

## ACID Transactions

Azure SQL provides:

- Atomicity
- Consistency
- Isolation
- Durability

Critical for:

- Orders
- Payments
- Inventory
- Financial transactions

---

## Strong Consistency

Data is immediately consistent after a successful transaction.

This simplifies business logic and avoids eventual consistency challenges for transactional workloads.

---

## Mature Query Engine

Supports:

- Complex joins
- Aggregations
- Window functions
- Stored procedures (when appropriate)
- Index optimisation
- Query tuning

---

## Excellent .NET Integration

Native support through:

- Entity Framework Core
- Microsoft.Data.SqlClient
- LINQ
- EF Core Migrations

---

## Enterprise Features

Azure SQL provides:

- Automatic backups
- Point-in-time restore
- Geo-redundancy options
- Transparent Data Encryption (TDE)
- Auditing
- Threat detection
- High availability

---

# 6. Consequences

## Positive

- Reliable transactional storage.
- Excellent performance for relational workloads.
- Mature tooling.
- Strong Azure integration.
- Well-understood operational model.

## Negative

- Less suitable for highly flexible document data.
- Horizontal partitioning requires additional planning.
- Not optimised for vector similarity search.

These trade-offs are acceptable for ECAP's transactional workloads.

---

# 7. Alternatives Considered

## Alternative 1 — Azure Cosmos DB

Description

Globally distributed NoSQL document database.

Advantages

- Flexible schema
- Horizontal scalability
- Low-latency global distribution
- Native JSON documents

Disadvantages

- Eventual consistency (depending on configuration)
- Limited relational capabilities
- No foreign keys
- More complex transactional modelling
- Higher learning curve for relational scenarios

Decision

Rejected as the primary transactional database.

Future Use:

- AI conversation history
- Session data
- Event storage
- Flexible document storage

---

## Alternative 2 — Azure Database for PostgreSQL

Advantages

- Open-source ecosystem
- Strong SQL capabilities
- Rich extension support

Disadvantages

- Existing team expertise and tooling align more closely with SQL Server.
- Tighter integration is available with the broader Microsoft ecosystem.

Decision

Rejected.

---

## Alternative 3 — MongoDB

Advantages

- Flexible document model
- Easy schema evolution

Disadvantages

- No native relational model
- Limited support for complex transactional relationships
- Additional operational considerations

Decision

Rejected.

---

## Alternative 4 — Azure Table Storage

Advantages

- Low cost
- Simple key/value access

Disadvantages

- No relational capabilities
- No joins
- Limited query flexibility

Decision

Rejected.

---

# 8. Database Usage Strategy

Azure SQL will store:

- Products
- Categories
- Brands
- Customers
- Orders
- Inventory
- Payments
- Vendors
- Promotions
- Reviews

Other Azure data services may be introduced for specialised workloads where appropriate.

---

# 9. Data Access Standards

All database access shall:

- Use Repository pattern.
- Use Entity Framework Core.
- Use asynchronous APIs.
- Support cancellation tokens.
- Avoid direct SQL from controllers.
- Keep business logic outside repositories.

---

# 10. Security

Azure SQL will use:

- Microsoft Entra ID authentication (where applicable)
- Managed Identity for application access
- Transparent Data Encryption (TDE)
- Auditing
- Firewall rules
- Private Endpoints in Production

Secrets shall be stored in Azure Key Vault.

---

# 11. Performance Strategy

Performance practices include:

- Proper indexing
- Pagination
- Optimised projections
- AsNoTracking() for read-only queries
- Query performance monitoring
- Connection pooling
- Optimistic concurrency

---

# 12. Backup and Recovery

Azure SQL provides:

- Automatic backups
- Point-in-time restore
- Geo-restore (where enabled)
- Long-term backup retention (as required)

Recovery procedures will be documented and tested.

---

# 13. Future Evolution

Azure SQL remains the primary transactional database.

Future complementary services may include:

| Service | Purpose |
|---------|----------|
| Azure Cosmos DB | AI conversations, session state, document storage |
| Azure AI Search | Semantic and vector search |
| Azure Blob Storage | Images and documents |
| Azure Cache for Redis | Frequently accessed reference data |
| Azure Data Lake Storage | Analytics and reporting |

This approach follows a **polyglot persistence** strategy, selecting the right data store for each workload.

---

# 14. Risks

Potential risks:

- Poor indexing
- Long-running queries
- Blocking transactions
- Excessive database coupling

Mitigation:

- Code reviews
- Query performance monitoring
- Database indexing strategy
- Architecture validation
- Load testing

---

# 15. Compliance

This decision aligns with:

- Azure Well-Architected Framework
- Microsoft SQL Server Best Practices
- Clean Architecture
- SOLID Principles
- Domain-Driven Design (DDD)

---

# 16. Review Criteria

This ADR should be reviewed if:

- Transactional requirements change significantly.
- A different persistence model becomes more suitable.
- Multi-region write requirements emerge.
- Business domains adopt specialised data stores.

---

# 17. Status History

| Date | Status | Notes |
|------|--------|-------|
| 2026-07-30 | Accepted | Initial architectural decision for ECAP |

---

# 18. Related ADRs

- ADR-001 – Use CQRS
- ADR-002 – Adopt Clean Architecture
- ADR-004 – Adopt Azure API Management
- ADR-005 – Use Bicep for Infrastructure as Code

---

# 19. Summary

ECAP adopts **Azure SQL Database** as its primary transactional database because it provides strong consistency, ACID transactions, mature relational capabilities, enterprise security and seamless integration with the Microsoft Azure ecosystem.

This decision supports the platform's current transactional needs while allowing complementary data stores, such as Azure Cosmos DB and Azure AI Search, to be introduced later for specialised workloads without replacing the core transactional database.
