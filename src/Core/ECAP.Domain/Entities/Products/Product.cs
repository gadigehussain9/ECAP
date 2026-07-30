using ECAP.Domain.Enums;
using ECAP.Domain.ValueObjects;
using ECAP.SharedKernel;

namespace ECAP.Domain.Entities.Products;

/// <summary>
/// Product aggregate root
/// </summary>
public sealed class Product : Entity<Guid>
{
    private readonly List<ProductImage> _images = new();

    public SKU Sku { get; private set; } = null!;
    public string Name { get; private set; } = string.Empty;
    public string Description { get; private set; } = string.Empty;
    public string? ShortDescription { get; private set; }

    public Guid BrandId { get; private set; }
    public Guid CategoryId { get; private set; }

    public decimal Price { get; private set; }
    public string Currency { get; private set; } = "USD";

    public ProductStatus Status { get; private set; }

    public Weight? Weight { get; private set; }
    public Dimensions? Dimensions { get; private set; }

    // SEO Fields
    public string? MetaTitle { get; private set; }
    public string? MetaDescription { get; private set; }
    public string? MetaKeywords { get; private set; }

    // Inventory summary (actual inventory is in Inventory module)
    public int AvailableQuantity { get; private set; }
    public int ReservedQuantity { get; private set; }
    public int LowStockThreshold { get; private set; }

    // Navigation properties
    public Brand Brand { get; private set; } = null!;
    public Category Category { get; private set; } = null!;
    public IReadOnlyCollection<ProductImage> Images => _images.AsReadOnly();

    // Audit fields
    public DateTime CreatedDate { get; private set; }
    public string? CreatedBy { get; private set; }
    public DateTime? UpdatedDate { get; private set; }
    public string? UpdatedBy { get; private set; }
    public bool IsDeleted { get; private set; }

    private Product() { }

    private Product(
        Guid id,
        SKU sku,
        string name,
        string description,
        Guid brandId,
        Guid categoryId,
        decimal price,
        string currency)
        : base(id)
    {
        Sku = sku;
        Name = name;
        Description = description;
        BrandId = brandId;
        CategoryId = categoryId;
        Price = price;
        Currency = currency;
        Status = ProductStatus.Draft;
        CreatedDate = DateTime.UtcNow;
        IsDeleted = false;
        LowStockThreshold = 10;
    }

    public static Result<Product> Create(
        string sku,
        string name,
        string description,
        Guid brandId,
        Guid categoryId,
        decimal price,
        string currency = "USD",
        string? createdBy = null)
    {
        // Validate inputs
        var skuResult = SKU.Create(sku);
        if (skuResult.IsFailure)
        {
            return Result<Product>.Failure(skuResult.Error!);
        }

        if (string.IsNullOrWhiteSpace(name))
        {
            return Result<Product>.Failure(Error.Validation("Product.Name.Empty", "Product name is required"));
        }

        if (name.Length > 200)
        {
            return Result<Product>.Failure(Error.Validation("Product.Name.TooLong", "Product name cannot exceed 200 characters"));
        }

        if (string.IsNullOrWhiteSpace(description))
        {
            return Result<Product>.Failure(Error.Validation("Product.Description.Empty", "Product description is required"));
        }

        if (description.Length > 2000)
        {
            return Result<Product>.Failure(Error.Validation("Product.Description.TooLong", "Product description cannot exceed 2000 characters"));
        }

        if (brandId == Guid.Empty)
        {
            return Result<Product>.Failure(Error.Validation("Product.BrandId.Invalid", "Brand ID is required"));
        }

        if (categoryId == Guid.Empty)
        {
            return Result<Product>.Failure(Error.Validation("Product.CategoryId.Invalid", "Category ID is required"));
        }

        if (price < 0)
        {
            return Result<Product>.Failure(Error.Validation("Product.Price.Negative", "Price cannot be negative"));
        }

        var product = new Product(Guid.NewGuid(), skuResult.Value!, name, description, brandId, categoryId, price, currency)
        {
            CreatedBy = createdBy
        };

        // Raise domain event
        product.RaiseDomainEvent(new Events.Products.ProductCreatedEvent(
            product.Id, 
            product.Sku.Value, 
            product.Name, 
            product.BrandId, 
            product.CategoryId, 
            product.Price, 
            product.Currency, 
            product.CreatedBy));

        return Result<Product>.Success(product);
    }

    public Result Update(
        string name,
        string description,
        string? shortDescription,
        Guid brandId,
        Guid categoryId,
        decimal price,
        string? updatedBy = null)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            return Result.Failure(Error.Validation("Product.Name.Empty", "Product name is required"));
        }

        if (name.Length > 200)
        {
            return Result.Failure(Error.Validation("Product.Name.TooLong", "Product name cannot exceed 200 characters"));
        }

        if (brandId == Guid.Empty)
        {
            return Result.Failure(Error.Validation("Product.BrandId.Invalid", "Brand ID is required"));
        }

        if (categoryId == Guid.Empty)
        {
            return Result.Failure(Error.Validation("Product.CategoryId.Invalid", "Category ID is required"));
        }

        if (price < 0)
        {
            return Result.Failure(Error.Validation("Product.Price.Negative", "Price cannot be negative"));
        }

        Name = name;
        Description = description;
        ShortDescription = shortDescription;
        BrandId = brandId;
        CategoryId = categoryId;
        Price = price;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = updatedBy;

        // Raise domain event
        RaiseDomainEvent(new Events.Products.ProductUpdatedEvent(
            Id, 
            Sku.Value, 
            Name, 
            BrandId, 
            CategoryId, 
            Price, 
            UpdatedBy));

        return Result.Success();
    }

    public void SetWeight(Weight weight)
    {
        Weight = weight;
        UpdatedDate = DateTime.UtcNow;
    }

    public void SetDimensions(Dimensions dimensions)
    {
        Dimensions = dimensions;
        UpdatedDate = DateTime.UtcNow;
    }

    public void SetSeo(string? metaTitle, string? metaDescription, string? metaKeywords)
    {
        MetaTitle = metaTitle;
        MetaDescription = metaDescription;
        MetaKeywords = metaKeywords;
        UpdatedDate = DateTime.UtcNow;
    }

    public Result AddImage(string url, string? altText = null, int displayOrder = 0, bool isMain = false)
    {
        var imageResult = ProductImage.Create(Id, url, altText, displayOrder, isMain);
        if (imageResult.IsFailure)
        {
            return Result.Failure(imageResult.Error!);
        }

        // If setting as main, unset any existing main image
        if (isMain)
        {
            foreach (var img in _images.Where(i => i.IsMain))
            {
                img.UnsetAsMain();
            }
        }

        _images.Add(imageResult.Value!);
        UpdatedDate = DateTime.UtcNow;

        return Result.Success();
    }

    public void RemoveImage(Guid imageId)
    {
        var image = _images.FirstOrDefault(i => i.Id == imageId);
        if (image is not null)
        {
            _images.Remove(image);
            UpdatedDate = DateTime.UtcNow;
        }
    }

    public void SetInventorySummary(int availableQuantity, int reservedQuantity)
    {
        AvailableQuantity = availableQuantity;
        ReservedQuantity = reservedQuantity;
    }

    public void SetLowStockThreshold(int threshold)
    {
        if (threshold < 0)
        {
            threshold = 0;
        }
        LowStockThreshold = threshold;
    }

    public bool IsLowStock() => AvailableQuantity <= LowStockThreshold;

    public void Activate(string? activatedBy = null)
    {
        Status = ProductStatus.Active;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = activatedBy;

        // Raise domain event
        RaiseDomainEvent(new Events.Products.ProductActivatedEvent(Id, Sku.Value, Name));
    }

    public void Deactivate(string? deactivatedBy = null)
    {
        Status = ProductStatus.Inactive;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = deactivatedBy;

        // Raise domain event
        RaiseDomainEvent(new Events.Products.ProductDeactivatedEvent(Id, Sku.Value, Name));
    }

    public void Discontinue(string? discontinuedBy = null)
    {
        Status = ProductStatus.Discontinued;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = discontinuedBy;
    }

    public void Delete(string? deletedBy = null)
    {
        IsDeleted = true;
        UpdatedDate = DateTime.UtcNow;
        UpdatedBy = deletedBy;

        // Raise domain event
        RaiseDomainEvent(new Events.Products.ProductDeletedEvent(Id, Sku.Value, Name));
    }
}
