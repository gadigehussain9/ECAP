using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.DeleteProduct;

/// <summary>
/// Command to delete a product (soft delete)
/// </summary>
public sealed record DeleteProductCommand(Guid Id) : IRequest<Result>;
