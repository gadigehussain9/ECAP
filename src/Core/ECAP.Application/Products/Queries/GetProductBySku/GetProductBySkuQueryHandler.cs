using ECAP.Application.Common.Interfaces;
using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using Mapster;
using MediatR;

namespace ECAP.Application.Products.Queries.GetProductBySku;

/// <summary>
/// Handler for GetProductBySkuQuery
/// </summary>
public sealed class GetProductBySkuQueryHandler : IRequestHandler<GetProductBySkuQuery, Result<ProductDto>>
{
    private readonly IProductRepository _productRepository;

    public GetProductBySkuQueryHandler(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }

    public async Task<Result<ProductDto>> Handle(GetProductBySkuQuery request, CancellationToken cancellationToken)
    {
        var product = await _productRepository.GetBySkuAsync(request.Sku, cancellationToken);
        if (product is null)
        {
            return Result<ProductDto>.Failure(
                Error.NotFound("Product.NotFound", $"Product with SKU '{request.Sku}' was not found"));
        }

        var dto = product.Adapt<ProductDto>();
        dto = dto with
        {
            BrandName = product.Brand?.Name ?? string.Empty,
            CategoryName = product.Category?.Name ?? string.Empty,
            IsLowStock = product.IsLowStock()
        };

        return Result<ProductDto>.Success(dto);
    }
}
