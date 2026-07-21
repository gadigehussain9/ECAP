namespace ECAP.Application.Products.Common;

/// <summary>
/// Product response DTO
/// </summary>
public sealed record ProductDto
{
    public Guid Id { get; init; }
    public string Sku { get; init; } = string.Empty;
    public string Name { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
    public string? ShortDescription { get; init; }
    public Guid BrandId { get; init; }
    public string BrandName { get; init; } = string.Empty;
    public Guid CategoryId { get; init; }
    public string CategoryName { get; init; } = string.Empty;
    public decimal Price { get; init; }
    public string Currency { get; init; } = "USD";
    public string Status { get; init; } = string.Empty;
    public decimal? Weight { get; init; }
    public string? WeightUnit { get; init; }
    public string? Dimensions { get; init; }
    public string? MetaTitle { get; init; }
    public string? MetaDescription { get; init; }
    public string? MetaKeywords { get; init; }
    public int AvailableQuantity { get; init; }
    public int ReservedQuantity { get; init; }
    public bool IsLowStock { get; init; }
    public List<ProductImageDto> Images { get; init; } = new();
    public DateTime CreatedDate { get; init; }
    public DateTime? UpdatedDate { get; init; }
}

/// <summary>
/// Product image response DTO
/// </summary>
public sealed record ProductImageDto
{
    public Guid Id { get; init; }
    public string Url { get; init; } = string.Empty;
    public string? AltText { get; init; }
    public int DisplayOrder { get; init; }
    public bool IsMain { get; init; }
}

/// <summary>
/// Brand response DTO
/// </summary>
public sealed record BrandDto
{
    public Guid Id { get; init; }
    public string Name { get; init; } = string.Empty;
    public string? Description { get; init; }
    public string? LogoUrl { get; init; }
    public bool IsActive { get; init; }
}

/// <summary>
/// Category response DTO
/// </summary>
public sealed record CategoryDto
{
    public Guid Id { get; init; }
    public string Name { get; init; } = string.Empty;
    public string? Description { get; init; }
    public Guid? ParentCategoryId { get; init; }
    public string? ParentCategoryName { get; init; }
    public int DisplayOrder { get; init; }
    public bool IsActive { get; init; }
}
