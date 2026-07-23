# Product Catalog Module

## Overview

The Product Catalog module is the first feature module of the ECAP platform, implementing a complete product management system with support for brands, categories, and product catalog operations.

## Domain Model

### Entities

#### Product (Aggregate Root)
- **SKU**: Unique product identifier (value object)
- **Name**: Product name (max 200 chars)
- **Description**: Detailed product description (max 2000 chars)
- **Short Description**: Brief product summary (max 500 chars)
- **Brand**: Reference to Brand entity
- **Category**: Reference to Category entity
- **Price & Currency**: Pricing information
- **Status**: Draft, Active, Inactive, Discontinued
- **Weight & Dimensions**: Physical product attributes (value objects)
- **SEO Fields**: Meta title, description, keywords
- **Images**: Product image collection
- **Inventory Summary**: Available quantity, reserved quantity, low stock threshold

#### Brand (Aggregate Root)
- **Name**: Brand name (unique, max 100 chars)
- **Description**: Brand description (max 500 chars)
- **Logo URL**: Brand logo image
- **IsActive**: Active/Inactive status
- **Audit Fields**: Created/Updated date and user

#### Category (Aggregate Root)
- **Name**: Category name (max 100 chars)
- **Description**: Category description (max 500 chars) 
- **Parent Category**: Hierarchical support
- **Display Order**: For sorting
- **IsActive**: Active/Inactive status
- **Audit Fields**: Created/Updated date and user

#### ProductImage (Entity)
- **URL**: Image URL (max 500 chars)
- **Alt Text**: Alternative text for accessibility
- **Display Order**: Image ordering
- **IsMain**: Primary product image flag

### Value Objects

- **SKU**: Validated product SKU (alphanumeric + hyphens, max 50 chars, uppercase)
- **Weight**: Weight value + unit
- **Dimensions**: Length, width, height + unit
- **Money**: Price + currency (existing)

### Enums

- **ProductStatus**: Draft, Active, Inactive, Discontinued
- **Currency**: USD, EUR, GBP, INR, AUD, CAD, JPY, CNY

## Application Layer

### Commands

#### Product Commands
- **CreateProductCommand**: Create new product with all attributes
- **UpdateProductCommand**: Update existing product
- **DeleteProductCommand**: Soft delete product
- **ActivateProductCommand**: Change status to Active
- **DeactivateProductCommand**: Change status to Inactive

### Queries

- **GetProductsQuery**: Paginated product list with filters (keyword, brand, category)
- **GetProductByIdQuery**: Get single product by ID
- **GetProductBySkuQuery**: Get single product by SKU

### DTOs

- **ProductDto**: Full product response
- **BrandDto**: Brand response
- **CategoryDto**: Category response
- **ProductImageDto**: Image response
- **PagedResult<T>**: Generic pagination wrapper

## Infrastructure

### EF Core Configurations

Complete entity configurations with:
- Value object mappings (SKU, Weight, Dimensions)
- Relationships with proper delete behaviors
- Query filters for soft delete
- Indexes for performance (Name, SKU, BrandId, CategoryId, Status)
- Owned entities for ProductImages

### Repositories

- **IProductRepository / ProductRepository**
  - CRUD operations
  - Search with filters
  - SKU uniqueness check
  - Includes for related entities

- **IBrandRepository / BrandRepository**
  - CRUD operations
  - Name uniqueness check
  - Active/inactive filtering

- **ICategoryRepository / CategoryRepository**
  - CRUD operations
  - Hierarchical category support
  - Name uniqueness check
  - Child category checks

## API Endpoints

### Products Controller (`/api/products`)

```http
GET    /api/products                    # List products (paginated, filtered)
GET    /api/products/{id}               # Get product by ID
GET    /api/products/sku/{sku}          # Get product by SKU
POST   /api/products                    # Create product
PUT    /api/products/{id}               # Update product
DELETE /api/products/{id}               # Delete product (soft)
POST   /api/products/{id}/activate      # Activate product
POST   /api/products/{id}/deactivate    # Deactivate product
```

## Validation

### FluentValidation Rules

#### CreateProductCommand
- SKU: Required, max 50 chars, alphanumeric + hyphens
- Name: Required, max 200 chars
- Description: Required, max 2000 chars
- Short Description: Optional, max 500 chars
- Brand: Required
- Category: Required
- Price: >= 0
- Weight: > 0 (if provided)
- Dimensions: All > 0 (if provided)
- Meta fields: Title max 100, Description max 300 chars

#### UpdateProductCommand
- Same as Create except SKU (not updated)

## Domain Events

- **ProductCreatedEvent**: Raised when product is created
- **ProductUpdatedEvent**: Raised when product is updated
- **ProductActivatedEvent**: Raised when product is activated
- **ProductDeactivatedEvent**: Raised when product is deactivated
- **ProductDeletedEvent**: Raised when product is soft-deleted
- **ProductCopiedEvent**: Raised when product is copied

## Database Migration

Migration created: `ProductCatalog`

Tables:
- **Products**: Main product table with owned ProductImages
- **Brands**: Brand catalog
- **Categories**: Category hierarchy
- **ProductImages**: Product image collection

Run migration:
```bash
dotnet ef database update --project src/Infrastructure/ECAP.Infrastructure.Persistence --startup-project src/Presentation/ECAP.Api
```

## Business Rules

1. **Product SKU must be unique** across the catalog
2. **Products can only reference active brands and categories**
3. **Only one main image per product** is allowed
4. **Soft delete pattern** for all entities (IsDeleted flag)
5. **Hierarchical categories** support parent-child relationships
6. **Category cannot be its own parent** (validation)
7. **Price cannot be negative**
8. **Physical dimensions must be positive** values

## Testing

### Unit Tests
- Domain entity creation and validation
- Value object behavior
- Command/query handlers
- Validators

### Integration Tests
- Repository operations
- Database queries
- End-to-end API flows

### Architecture Tests
- Layer dependency rules
- Naming conventions
- Controller patterns

## Future Enhancements

1. **Product Variants**: Size, color, material variations
2. **Pricing Rules**: Discounts, tiered pricing, promotions
3. **Product Reviews**: Customer ratings and reviews
4. **Inventory Integration**: Real-time stock updates
5. **Search Optimization**: Full-text search, facets, filters
6. **Image Management**: Multiple image sizes, CDN integration
7. **Product Attributes**: Custom attributes, specifications
8. **Product Relations**: Related products, bundles, cross-sells

## Dependencies

- MediatR 13.0.1
- FluentValidation.DependencyInjectionExtensions 11.11.1
- Mapster 7.4.0
- Microsoft.EntityFrameworkCore 10.0.0
- Microsoft.EntityFrameworkCore.SqlServer 10.0.0
