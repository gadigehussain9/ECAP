#pragma warning disable CS8602, CS8604 // Null checks handled by Result pattern
using ECAP.Application.Common.Interfaces;
using ECAP.Application.Products.Common;
using ECAP.Domain.Interfaces;
using ECAP.Domain.ValueObjects;
using ECAP.SharedKernel;
using Mapster;
using MediatR;

namespace ECAP.Application.Products.Commands.UpdateProduct;

/// <summary>
/// Handler for UpdateProductCommand
/// </summary>
public sealed class UpdateProductCommandHandler : IRequestHandler<UpdateProductCommand, Result<ProductDto>>
{
    private readonly IProductRepository _productRepository;
    private readonly IBrandRepository _brandRepository;
    private readonly ICategoryRepository _categoryRepository;
    private readonly IUnitOfWork _unitOfWork;

    public UpdateProductCommandHandler(
        IProductRepository productRepository,
        IBrandRepository brandRepository,
        ICategoryRepository categoryRepository,
        IUnitOfWork unitOfWork)
    {
        _productRepository = productRepository;
        _brandRepository = brandRepository;
        _categoryRepository = categoryRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result<ProductDto>> Handle(UpdateProductCommand request, CancellationToken cancellationToken)
    {
        // Get product
        var product = await _productRepository.GetByIdAsync(request.Id, cancellationToken);
        if (product is null)
        {
            return Result<ProductDto>.Failure(
                Error.NotFound("Product.NotFound", $"Product with ID '{request.Id}' was not found"));
        }

        // Validate brand exists
        var brand = await _brandRepository.GetByIdAsync(request.BrandId, cancellationToken);
        if (brand is null)
        {
            return Result<ProductDto>.Failure(
                Error.NotFound("Brand.NotFound", $"Brand with ID '{request.BrandId}' was not found"));
        }

        if (!brand.IsActive)
        {
            return Result<ProductDto>.Failure(
                Error.Validation("Brand.Inactive", "Cannot update product with inactive brand"));
        }

        // Validate category exists
        var category = await _categoryRepository.GetByIdAsync(request.CategoryId, cancellationToken);
        if (category is null)
        {
            return Result<ProductDto>.Failure(
                Error.NotFound("Category.NotFound", $"Category with ID '{request.CategoryId}' was not found"));
        }

        if (!category.IsActive)
        {
            return Result<ProductDto>.Failure(
                Error.Validation("Category.Inactive", "Cannot update product with inactive category"));
        }

        // Update product
        var updateResult = product.Update(
            request.Name,
            request.Description,
            request.ShortDescription,
            request.BrandId,
            request.CategoryId,
            request.Price);

        if (updateResult.IsFailure)
        {
            return Result<ProductDto>.Failure(updateResult.Error);
        }

        // Set weight if provided
        if (request.Weight.HasValue && !string.IsNullOrWhiteSpace(request.WeightUnit))
        {
            var weightResult = Weight.Create(request.Weight.Value, request.WeightUnit);
            if (weightResult.IsFailure)
            {
                return Result<ProductDto>.Failure(weightResult.Error);
            }
            product.SetWeight(weightResult.Value);
        }

        // Set dimensions if provided
        if (request.Length.HasValue && request.Width.HasValue && request.Height.HasValue &&
            !string.IsNullOrWhiteSpace(request.DimensionUnit))
        {
            var dimensionsResult = Dimensions.Create(
                request.Length.Value,
                request.Width.Value,
                request.Height.Value,
                request.DimensionUnit);

            if (dimensionsResult.IsFailure)
            {
                return Result<ProductDto>.Failure(dimensionsResult.Error);
            }
            product.SetDimensions(dimensionsResult.Value);
        }

        // Set SEO fields
        product.SetSeo(request.MetaTitle, request.MetaDescription, request.MetaKeywords);

        // Save changes
        _productRepository.Update(product);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // Map to DTO
        var dto = product.Adapt<ProductDto>();
        dto = dto with
        {
            BrandName = brand.Name,
            CategoryName = category.Name,
            IsLowStock = product.IsLowStock()
        };

        return Result<ProductDto>.Success(dto);
    }
}
