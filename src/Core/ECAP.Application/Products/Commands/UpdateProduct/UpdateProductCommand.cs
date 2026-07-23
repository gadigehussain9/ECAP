using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.UpdateProduct;

/// <summary>
/// Command to update an existing product
/// </summary>
public sealed record UpdateProductCommand : IRequest<Result<ProductDto>>
{
    public Guid Id { get; init; }
    public string Name { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
    public string? ShortDescription { get; init; }
    public Guid BrandId { get; init; }
    public Guid CategoryId { get; init; }
    public decimal Price { get; init; }
    public decimal? Weight { get; init; }
    public string? WeightUnit { get; init; }
    public decimal? Length { get; init; }
    public decimal? Width { get; init; }
    public decimal? Height { get; init; }
    public string? DimensionUnit { get; init; }
    public string? MetaTitle { get; init; }
    public string? MetaDescription { get; init; }
    public string? MetaKeywords { get; init; }
}
