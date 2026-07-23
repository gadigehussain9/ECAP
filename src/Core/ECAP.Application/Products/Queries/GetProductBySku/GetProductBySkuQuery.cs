using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Queries.GetProductBySku;

/// <summary>
/// Query to get a product by SKU
/// </summary>
public sealed record GetProductBySkuQuery(string Sku) : IRequest<Result<ProductDto>>;
