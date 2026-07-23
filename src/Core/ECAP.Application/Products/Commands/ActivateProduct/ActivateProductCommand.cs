using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Commands.ActivateProduct;

/// <summary>
/// Command to activate a product
/// </summary>
public sealed record ActivateProductCommand(Guid Id) : IRequest<Result>;
