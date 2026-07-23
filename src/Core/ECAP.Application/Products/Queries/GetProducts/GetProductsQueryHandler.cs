using ECAP.Application.Common.Interfaces;
using ECAP.Application.Common.Models;
using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using Mapster;
using MediatR;

namespace ECAP.Application.Products.Queries.GetProducts;

/// <summary>
/// Handler for GetProductsQuery
/// </summary>
public sealed class GetProductsQueryHandler : IRequestHandler<GetProductsQuery, Result<PagedResult<ProductDto>>>
{
    private readonly IProductRepository _productRepository;

    public GetProductsQueryHandler(IProductRepository productRepository)
    {
        _productRepository = productRepository;
    }

    public async Task<Result<PagedResult<ProductDto>>> Handle(GetProductsQuery request, CancellationToken cancellationToken)
    {
        var products = await _productRepository.SearchAsync(
            request.Keyword,
            request.BrandId,
            request.CategoryId,
            request.PageNumber,
            request.PageSize,
            cancellationToken);

        var totalCount = await _productRepository.CountAsync(
            request.Keyword,
            request.BrandId,
            request.CategoryId,
            cancellationToken);

        var productDtos = products.Adapt<List<ProductDto>>();

        // Enhance DTOs with calculated fields
        foreach (var dto in productDtos)
        {
            var product = products.First(p => p.Id == dto.Id);
            var enhanced = dto with
            {
                BrandName = product.Brand?.Name ?? string.Empty,
                CategoryName = product.Category?.Name ?? string.Empty,
                IsLowStock = product.IsLowStock()
            };
            productDtos[productDtos.IndexOf(dto)] = enhanced;
        }

        var pagedResult = new PagedResult<ProductDto>(
            productDtos,
            request.PageNumber,
            request.PageSize,
            totalCount);

        return Result<PagedResult<ProductDto>>.Success(pagedResult);
    }
}
