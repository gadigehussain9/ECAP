using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.DeactivateProduct;

/// <summary>
/// Command to deactivate a product
/// </summary>
public sealed record DeactivateProductCommand(Guid Id) : IRequest<Result>;
