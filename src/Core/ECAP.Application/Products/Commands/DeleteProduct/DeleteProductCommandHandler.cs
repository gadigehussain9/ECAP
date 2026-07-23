using ECAP.Application.Common.Interfaces;
using ECAP.Domain.Interfaces;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.DeleteProduct;

/// <summary>
/// Handler for DeleteProductCommand
/// </summary>
public sealed class DeleteProductCommandHandler : IRequestHandler<DeleteProductCommand, Result>
{
    private readonly IProductRepository _productRepository;
    private readonly IUnitOfWork _unitOfWork;

    public DeleteProductCommandHandler(
        IProductRepository productRepository,
        IUnitOfWork unitOfWork)
    {
        _productRepository = productRepository;
        _unitOfWork = unitOfWork;
    }

    public async Task<Result> Handle(DeleteProductCommand request, CancellationToken cancellationToken)
    {
        var product = await _productRepository.GetByIdAsync(request.Id, cancellationToken);
        if (product is null)
        {
            return Result.Failure(
                Error.NotFound("Product.NotFound", $"Product with ID '{request.Id}' was not found"));
        }

        product.Delete();
        _productRepository.Update(product);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        return Result.Success();
    }
}
