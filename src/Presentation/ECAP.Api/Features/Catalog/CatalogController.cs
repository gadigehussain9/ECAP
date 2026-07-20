using Microsoft.AspNetCore.Mvc;

namespace ECAP.Api.Features.Catalog;

/// <summary>
/// Catalog management endpoints following vertical slice architecture.
/// All catalog-related endpoints in one controller.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class CatalogController : ControllerBase
{
    // Inject MediatR and use it to send queries/commands
    // Example:
    // private readonly IMediator _mediator;
    // public CatalogController(IMediator mediator) => _mediator = mediator;

    // [HttpGet("{id}")]
    // public async Task<IActionResult> GetProduct(Guid id)
    // {
    //     var result = await _mediator.Send(new GetProductByIdQuery(id));
    //     return Ok(result);
    // }
}
