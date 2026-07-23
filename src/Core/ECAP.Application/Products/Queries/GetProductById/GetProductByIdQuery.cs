using ECAP.Application.Products.Common;
using ECAP.SharedKernel;
using MediatR;

namespace ECAP.Application.Products.Queries.GetProductById;

/// <summary>
/// Query to get a product by ID
/// </summary>
public sealed record GetProductByIdQuery(Guid Id) : IRequest<Result<ProductDto>>;
