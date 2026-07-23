# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Sprint 2: Testing & Quality (unit tests, integration tests, architecture tests)
- Sprint 3: Authentication & Authorization (JWT, identity, role-based access)
- Order Management domain
- Shopping Cart functionality
- Payment gateway integration
- Email notifications
- RabbitMQ event bus integration

---

## [0.1.0] - 2025-01-XX - Sprint 1: Product Catalog

### Added - Product Catalog Module

#### Domain Layer
- **Product aggregate root** with rich domain logic:
  - SKU management with validation and uniqueness
  - Product lifecycle states (Draft, Active, Inactive, Discontinued)
  - Weight and dimensions value objects
  - SEO metadata support
  - Product image collection management
  - Soft delete capability
  - Audit fields (CreatedBy, UpdatedBy, timestamps)
- **Brand aggregate root** with lifecycle management
- **Category aggregate root** with hierarchical support
- **Value Objects:** SKU, Weight, Dimensions with validation
- **Enums:** ProductStatus, Currency
- **Domain Events:** ProductCreated, Updated, Activated, Deactivated, Deleted, Copied

#### Application Layer
- **CQRS with MediatR 13.0.1:**
  - Commands: CreateProduct, UpdateProduct, DeleteProduct, ActivateProduct, DeactivateProduct
  - Queries: GetProducts (paginated), GetProductById, GetProductBySku
- **FluentValidation 11.11.1** for all commands and queries
- **DTOs:** ProductDto, BrandDto, CategoryDto, ProductImageDto, PagedResult<T>
- **Repository interfaces:** IProductRepository, IBrandRepository, ICategoryRepository
- **Application DI registration** with AddApplication()
- **Mapster 7.4.0** for object mapping

#### Infrastructure Layer
- **EF Core 10 configurations** for Product, Brand, Category
- **Value object mappings** for SKU, Weight, Dimensions
- **Owned entity mapping** for ProductImages collection
- **Soft delete query filters** on all entities
- **Performance indexes** on key fields
- **Repository implementations** with search, filtering, eager loading
- **Updated ApplicationDbContext** with Product Catalog DbSets

#### Presentation Layer
- **ProductsController** with 8 REST endpoints:
  - `GET /api/products` - List with pagination & filters
  - `GET /api/products/{id}` - Get by ID
  - `GET /api/products/sku/{sku}` - Get by SKU
  - `POST /api/products` - Create product
  - `PUT /api/products/{id}` - Update product
  - `DELETE /api/products/{id}` - Soft delete
  - `POST /api/products/{id}/activate` - Activate
  - `POST /api/products/{id}/deactivate` - Deactivate

#### Database
- **Migration:** ProductCatalog with Products, Brands, Categories tables
- Full schema with indexes and constraints
- ProductImages as owned collection
- Self-referencing Category hierarchy

#### Documentation
- Module documentation: `docs/modules/ProductCatalog.md`
- Sprint summary: `docs/sprint-summaries/Sprint-1-ProductCatalog-Summary.md`
- Updated README.md with current status
- Updated `.github/prompts/roadmap.md` with Sprint 1 completion
- Created STATUS.md for quick reference

### Changed
- **Extended Error class** with type-specific factories (Validation, NotFound, Conflict, Unauthorized, Forbidden)
- **Enhanced Result<T>** with Error Type property
- **Updated Persistence DI** to register Product Catalog repositories

### Fixed
- Nullable reference warnings in domain entities
- Nullable reference warnings in application handlers  
- Nullable reference warnings in API controller
- PagedResult namespace corrected to Application.Common.Models

---

## [0.0.1] - 2025-01-XX - Initial Setup

### Added
- Initial project structure following Clean Architecture
- SharedKernel project with domain primitives:
  - Entity base class
  - ValueObject base class
  - DomainEvent base class
  - Result pattern for error handling
  - Guard clauses for validation
- Domain layer with repository interfaces and sample value objects
- Application layer with feature-based organization ready for CQRS
- Infrastructure layers:
  - Persistence (EF Core with SQL Server)
  - Identity (Authentication/Authorization preparation)
  - ExternalServices (Email service placeholder)
  - Messaging (Event bus preparation)
- API layer with Swagger/OpenAPI documentation
- Test projects:
  - Unit tests
  - Integration tests
  - Architecture tests (NetArchTest)
  - Performance tests (NBomber)
- Documentation:
  - Architecture Decision Records (ADR)
  - Getting Started guide
  - Coding Standards
- Infrastructure as Code:
  - Terraform for Azure
  - Kubernetes manifests
  - Helm charts
- Automation:
  - Build & test scripts (PowerShell)
  - Database migration scripts
  - Local development setup
- GitHub configuration:
  - CI workflow (build, test, coverage, security scan)
  - CD workflows (staging, production with blue-green deployment)
  - Security scanning (CodeQL, dependency-check)
  - CODEOWNERS file
  - PR template
  - Issue templates
- Central Package Management
- EditorConfig for consistent coding style

### Changed
- N/A (initial release)

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- Integrated CodeQL security scanning in CI
- Trivy container scanning
- Dependabot vulnerability alerts enabled

---

## Release Notes Template

Use this template for future releases:

## [Version] - YYYY-MM-DD

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security improvements
