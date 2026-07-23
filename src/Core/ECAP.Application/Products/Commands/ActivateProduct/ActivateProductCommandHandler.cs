using ECAP.Application.Common.Interfaces;
using ECAP.Domain.Interfaces;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.ActivateProduct;

/// <summary>
/// Handler for ActivateProductCommand
/// </summary>
public sealed class ActivateProductCommandHandler : IRequestHandler<ActivateProductCommand, Result>
{
    private readonly IProductRepository _productRepository;
    private readonly IUnitOfWork _unitOfWork;

    public ActivateProductCommandHandler(
        IProductRepository productRepository,
        IUnitOfWork unitOfWork)
    {
        _productRepository = productRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result> Handle(ActivateProductCommand request, CancellationToken cancellationToken)
    {
        var product = await _productRepository.GetByIdAsync(request.Id, cancellationToken);
        if (product is null)
        {
            return Result.Failure(
                Error.NotFound("Product.NotFound", $"Product with ID '{request.Id}' was not found"));
        }

        product.Activate();
        _productRepository.Update(product);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }
}
