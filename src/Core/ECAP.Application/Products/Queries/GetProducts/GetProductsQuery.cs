using ECAP.Application.Common.Models;
using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Queries.GetProducts;

/// <summary>
/// Query to get paginated products with filters
/// </summary>
public sealed record GetProductsQuery : IRequest<Result<PagedResult<ProductDto>>>
{
    public string? Keyword { get; init; }
    public Guid? BrandId { get; init; }
    public Guid? CategoryId { get; init; }
    public int PageNumber { get; init; } = 1;
    public int PageSize { get; init; } = 20;
}
