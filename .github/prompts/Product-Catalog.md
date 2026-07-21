Business Goal

The Product Catalog is the heart of every commerce platform.

It manages:

    Products
    Categories
    Brands
    Pricing
    Images
    Inventory status
    Search attributes
    Product lifecycle

Every other module depends on it.

Sprint 1 Deliverables:
By the end of Sprint 1, we will have:

    Product Domain
    Category Domain
    Brand Domain
    Product APIs
    CQRS
    MediatR
    FluentValidation
    Repository
    Unit of Work
    Domain Events
    Unit Tests
    Integration Tests
    Swagger
    GitHub documentation
    Architecture Decision Record (ADR)
Phase 1 – Business Requirements:
This is where architects begin.

Functional Requirements:
    1. Product Management
        The system shall allow:

            Create Product
            Update Product
            Delete Product (soft delete)
            Copy Product
            Activate Product
            Deactivate Product

    2. Product Search
        Users can:

            Search by keyword
            Search by SKU
            Search by Brand
            Search by Category
            Filter
            Sort
            Paginate

    3. Product Information

        Each product contains:

            SKU
            Name
            Description
            Brand
            Category
            Price
            Currency
            Status
            Images
            Attributes
            SEO metadata
            Dimensions
            Weight
    4. Inventory Information

        The catalog shows:

            Available Quantity
            Reserved Quantity
            Available for Sale
            Low Stock Indicator

Inventory ownership will belong to the Inventory module later, but the catalog can display inventory summaries.

Non-Functional Requirements:

        The system should:

        Support 1 million+ products
        Respond to product searches quickly
        Be horizontally scalable
        Support caching
        Support AI Search later
        Support multiple languages
        Support multiple currencies

User Stories:
Story 1

    As an Administrator

    I want to create a product

    So that customers can purchase it.

Story 2

    As a Product Manager

    I want to update product information

    So customers always see accurate data.

Story 3

    As a Customer

    I want to search products

    So I can quickly find what I need.

Story 4

    As a Customer

    I want to filter products

    So I can narrow my search results.

Story 5

    As an Administrator

    I want to deactivate a product

    So it is no longer available for sale.

Acceptance Criteria
    Create Product

    Given:

    Administrator is authenticated.

    When:

    Administrator submits valid product data.

    Then:

    Product created
    SKU unique
    Audit record created
    Domain Event published
    HTTP 201 returned
Search Product

    Given:

    Products exist.

    When:

    Customer searches "Laptop"

    Then:

    Matching products returned.

    Pagination applied.

    Sorting supported.

Domain Model

Now we think like Domain-Driven Design practitioners.

Product Aggregate Root
    Product
    Id
    SKU
    Name
    Description
    BrandId
    CategoryId
    Price
    Currency
    Status
    Weight
    Dimensions
    SEO
    CreatedDate
    UpdatedDate

Category
    Category
    Id
    Name
    ParentCategoryId
    Status

Brand
    Brand
    Id
    Name
    Description

ProductImage
    ProductImage
    Id
    Url
    DisplayOrder
    AltText
ProductAttribute
    Color
    Size
    Memory
    Storage
    Processor
    RAM
    ...

Domain Events

    We'll introduce enterprise events from Day 1.

    ProductCreatedEvent

    ProductUpdatedEvent

    ProductActivatedEvent

    ProductDeactivatedEvent

    ProductDeletedEvent

    Later these events will flow through the Outbox Pattern to Azure Service Bus.

CQRS Design
    Commands
        CreateProductCommand
        UpdateProductCommand
        DeleteProductCommand
        ActivateProductCommand
        DeactivateProductCommand
        CopyProductCommand
    Queries
        GetProductByIdQuery
        GetProductBySkuQuery
        SearchProductsQuery
        GetProductsQuery
        GetCategoriesQuery
        GetBrandsQuery
        Validation Rules

FluentValidation will enforce rules such as:

        SKU required
        SKU unique
        Name required
        Price > 0
        Currency valid
        Brand exists
        Category exists
        Images valid
        Description length
        Maximum attributes
        Status valid

Repository

    We'll create interfaces such as:

    IProductRepository

    IBrandRepository

    ICategoryRepository

    These will expose business-oriented operations rather than generic CRUD where appropriate.

Unit of Work

    A typical flow:

    Validate command.
    Load required entities.
    Apply business rules.
    Save changes.
    Raise domain events.
    Commit transaction.

    API Endpoints

We'll implement RESTful endpoints:

    GET    /api/v1/products
    GET    /api/v1/products/{id}
    GET    /api/v1/products/sku/{sku}
    POST   /api/v1/products
    PUT    /api/v1/products/{id}
    DELETE /api/v1/products/{id}
    POST   /api/v1/products/{id}/activate
    POST   /api/v1/products/{id}/deactivate
    POST   /api/v1/products/{id}/copy

Testing Strategy

    We'll add:

    Domain Tests
    Command Handler Tests
    Validator Tests
    Repository Tests
    Integration Tests
    API Tests
    Architecture Tests


LOCAL SQL Server: 
	server name: LAPTOP-E9HPGPJ0
	username: sa
	Password: Bindu1huss!
