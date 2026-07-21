using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.CreateProduct;

/// <summary>
/// Command to create a new product
/// </summary>
public sealed record CreateProductCommand : IRequest<Result<ProductDto>>
{
    public string Sku { get; init; } = string.Empty;
    public string Name { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
    public string? ShortDescription { get; init; }
    public Guid BrandId { get; init; }
    public Guid CategoryId { get; init; }
    public decimal Price { get; init; }
    public string Currency { get; init; } = "USD";
    public decimal? Weight { get; init; }
    public string? WeightUnit { get; init; }
    public decimal? Length { get; init; }
    public decimal? Width { get; init; }
    public decimal? Height { get; init; }
    public string? DimensionUnit { get; init; }
    public string? MetaTitle { get; init; }
    public string? MetaDescription { get; init; }
    public string? MetaKeywords { get; init; }
    public List<CreateProductImageDto>? Images { get; init; }
}

public sealed record CreateProductImageDto
{
    public string Url { get; init; } = string.Empty;
    public string? AltText { get; init; }
    public int DisplayOrder { get; init; }
    public bool IsMain { get; init; }
}
