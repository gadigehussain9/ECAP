using ECAP.Application.Common.Interfaces;
using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using Mapster;
using MediatR;

namespace ECAP.Application.Products.Queries.GetProductById;

/// <summary>
/// Handler for GetProductByIdQuery
/// </summary>
public sealed class GetProductByIdQueryHandler : IRequestHandler<GetProductByIdQuery, Result<ProductDto>>
{
    private readonly IProductRepository _productRepository;

    public GetProductByIdQueryHandler(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }

    public async Task<Result<ProductDto>> Handle(GetProductByIdQuery request, CancellationToken cancellationToken)
    {
        var product = await _productRepository.GetByIdAsync(request.Id, cancellationToken);
        if (product is null)
        {
            return Result<ProductDto>.Failure(
                Error.NotFound("Product.NotFound", $"Product with ID '{request.Id}' was not found"));
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
