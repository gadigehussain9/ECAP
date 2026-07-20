# ECAP Coding Standards

## C# Coding Conventions

### Naming Conventions

- **Classes, Methods, Properties**: `PascalCase`
- **Local variables, parameters**: `camelCase`
- **Private fields**: `_camelCase` (with underscore prefix)
- **Interfaces**: `IPascalCase` (start with I)
- **Async methods**: End with `Async` suffix
- **Test methods**: Use descriptive names with underscores (e.g., `GetProduct_WhenIdExists_ReturnsProduct`)

### Code Organization

1. **File Structure**
   - One class per file
   - File name matches class name
   - Organize using statements (System first, then third-party, then project)

2. **Class Member Order**
   - Constants
   - Fields
   - Constructors
   - Properties
   - Methods (public → private)

### Vertical Slice Architecture

```csharp
// ✅ CORRECT: Feature-based organization
Application/
└── Features/
    └── Catalog/
        ├── Commands/
        │   └── CreateProduct/
        │       ├── CreateProductCommand.cs
        │       ├── CreateProductCommandHandler.cs
        │       └── CreateProductCommandValidator.cs
        └── Queries/
            └── GetProductById/
                ├── GetProductByIdQuery.cs
                └── GetProductByIdQueryHandler.cs

// ❌ WRONG: Layer-based organization
Application/
├── Commands/
├── Queries/
└── Handlers/
```

### CQRS Pattern

```csharp
// Command (changes state)
public sealed record CreateProductCommand(string Name, decimal Price) : IRequest<Result<Guid>>;

public sealed class CreateProductCommandHandler : IRequestHandler<CreateProductCommand, Result<Guid>>
{
    public async Task<Result<Guid>> Handle(CreateProductCommand command, CancellationToken ct)
    {
        // Implementation
    }
}

// Query (reads state)
public sealed record GetProductByIdQuery(Guid Id) : IRequest<ProductDto>;

public sealed class GetProductByIdQueryHandler : IRequestHandler<GetProductByIdQuery, ProductDto>
{
    public async Task<ProductDto> Handle(GetProductByIdQuery query, CancellationToken ct)
    {
        // Implementation
    }
}
```

### Error Handling

```csharp
// ✅ CORRECT: Use Result pattern
public async Task<Result<Product>> GetProductAsync(Guid id)
{
    var product = await _repository.GetByIdAsync(id);

    if (product is null)
        return Result<Product>.Failure(new Error("Product.NotFound", $"Product {id} not found"));

    return Result<Product>.Success(product);
}

// ❌ WRONG: Throw exceptions for business logic errors
public async Task<Product> GetProductAsync(Guid id)
{
    var product = await _repository.GetByIdAsync(id);

    if (product is null)
        throw new NotFoundException(nameof(Product), id); // Only for exceptional cases

    return product;
}
```

### Dependency Injection

```csharp
// ✅ CORRECT: Interface-based dependencies
public class ProductService
{
    private readonly IRepository<Product, Guid> _repository;
    private readonly IEmailService _emailService;

    public ProductService(IRepository<Product, Guid> repository, IEmailService emailService)
    {
        _repository = repository;
        _emailService = emailService;
    }
}

// ❌ WRONG: Concrete dependencies
public class ProductService
{
    private readonly ProductRepository _repository; // Tight coupling
}
```

### Async/Await

```csharp
// ✅ CORRECT
public async Task<Product> GetProductAsync(Guid id, CancellationToken cancellationToken)
{
    return await _context.Products
        .FirstOrDefaultAsync(p => p.Id == id, cancellationToken);
}

// ❌ WRONG: Missing CancellationToken
public async Task<Product> GetProductAsync(Guid id)
{
    return await _context.Products.FirstOrDefaultAsync(p => p.Id == id);
}
```

### Entity Framework Core

```csharp
// ✅ CORRECT: Use configurations
public class ProductConfiguration : IEntityTypeConfiguration<Product>
{
    public void Configure(EntityTypeBuilder<Product> builder)
    {
        builder.ToTable("Products");
        builder.HasKey(p => p.Id);
        builder.Property(p => p.Name).IsRequired().HasMaxLength(200);
    }
}

// ❌ WRONG: Fluent API in OnModelCreating
protected override void OnModelCreating(ModelBuilder modelBuilder)
{
    modelBuilder.Entity<Product>().HasKey(p => p.Id);
    modelBuilder.Entity<Product>().Property(p => p.Name).IsRequired();
    // ... hundreds of lines
}
```

### Testing

```csharp
// ✅ CORRECT: Arrange-Act-Assert pattern
[Fact]
public async Task CreateProduct_WithValidData_ReturnsSuccessResult()
{
    // Arrange
    var command = new CreateProductCommand("Test Product", 99.99m);
    var handler = new CreateProductCommandHandler(_repository, _unitOfWork);

    // Act
    var result = await handler.Handle(command, CancellationToken.None);

    // Assert
    result.IsSuccess.Should().BeTrue();
    result.Value.Should().NotBeEmpty();
}

// Use Moq for mocking
var mockRepository = new Mock<IRepository<Product, Guid>>();
mockRepository.Setup(r => r.GetByIdAsync(It.IsAny<Guid>(), It.IsAny<CancellationToken>()))
    .ReturnsAsync(new Product());
```

## Code Quality Tools

- **EditorConfig**: Enforces coding style
- **Roslyn Analyzers**: Catches common mistakes
- **Architecture Tests**: Validates Clean Architecture rules
- **Code Coverage**: Minimum 80% coverage for Domain and Application layers

## Pre-Commit Checklist

- [ ] Code builds without warnings
- [ ] All tests pass
- [ ] Code coverage meets minimum threshold
- [ ] Architecture tests pass
- [ ] No commented-out code
- [ ] XML documentation for public APIs
- [ ] Followed naming conventions
- [ ] Used async/await with CancellationToken
