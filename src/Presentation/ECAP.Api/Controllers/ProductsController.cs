using ECAP.Application.Products.Commands.ActivateProduct;
using ECAP.Application.Products.Commands.CreateProduct;
using ECAP.Application.Products.Commands.DeactivateProduct;
using ECAP.Application.Products.Commands.DeleteProduct;
using ECAP.Application.Products.Commands.UpdateProduct;
using ECAP.Application.Products.Queries.GetProductById;
using ECAP.Application.Products.Queries.GetProductBySku;
using ECAP.Application.Products.Queries.GetProducts;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace ECAP.Api.Controllers;

/// <summary>
/// Products API endpoint
/// </summary>
[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class ProductsController : ControllerBase
{
    private readonly ISender _sender;

    public ProductsController(ISender sender)
    {
        _sender = sender;
    }

    /// <summary>
    /// Get all products with pagination and filtering
    /// </summary>
    [HttpGet]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> GetProducts(
        [FromQuery] string? keyword,
        [FromQuery] Guid? brandId,
        [FromQuery] Guid? categoryId,
        [FromQuery] int pageNumber = 1,
        [FromQuery] int pageSize = 20,
        CancellationToken cancellationToken = default)
    {
        var query = new GetProductsQuery
        {
            Keyword = keyword,
            BrandId = brandId,
            CategoryId = categoryId,
            PageNumber = pageNumber,
            PageSize = pageSize
        };

        var result = await _sender.Send(query, cancellationToken);

        return result.IsSuccess
            ? Ok(result.Value)
            : BadRequest(result.Error);
    }

    /// <summary>
    /// Get a product by ID
    /// </summary>
    [HttpGet("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetProductById(
        Guid id,
        CancellationToken cancellationToken = default)
    {
        var query = new GetProductByIdQuery(id);
        var result = await _sender.Send(query, cancellationToken);

        return result.IsSuccess
            ? Ok(result.Value)
            : NotFound(result.Error);
    }

    /// <summary>
    /// Get a product by SKU
    /// </summary>
    [HttpGet("sku/{sku}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> GetProductBySku(
        string sku,
        CancellationToken cancellationToken = default)
    {
        var query = new GetProductBySkuQuery(sku);
        var result = await _sender.Send(query, cancellationToken);

        return result.IsSuccess
            ? Ok(result.Value)
            : NotFound(result.Error);
    }

    /// <summary>
    /// Create a new product
    /// </summary>
    [HttpPost]
    [ProducesResponseType(StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    public async Task<IActionResult> CreateProduct(
        [FromBody] CreateProductCommand command,
        CancellationToken cancellationToken = default)
    {
        var result = await _sender.Send(command, cancellationToken);

        return result.IsSuccess
            ? CreatedAtAction(nameof(GetProductById), new { id = result.Value!.Id }, result.Value)
            : BadRequest(result.Error);
    }

    /// <summary>
    /// Update an existing product
    /// </summary>
    [HttpPut("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> UpdateProduct(
        Guid id,
        [FromBody] UpdateProductCommand command,
        CancellationToken cancellationToken = default)
    {
        if (id != command.Id)
        {
            return BadRequest("ID mismatch");
        }

        var result = await _sender.Send(command, cancellationToken);

        return result.IsSuccess
            ? Ok(result.Value)
            : result.Error!.Type == "NotFound"
                ? NotFound(result.Error)
                : BadRequest(result.Error);
    }

    /// <summary>
    /// Delete a product (soft delete)
    /// </summary>
    [HttpDelete("{id:guid}")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeleteProduct(
        Guid id,
        CancellationToken cancellationToken = default)
    {
        var command = new DeleteProductCommand(id);
        var result = await _sender.Send(command, cancellationToken);

        return result.IsSuccess
            ? NoContent()
            : NotFound(result.Error);
    }

    /// <summary>
    /// Activate a product
    /// </summary>
    [HttpPost("{id:guid}/activate")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> ActivateProduct(
        Guid id,
        CancellationToken cancellationToken = default)
    {
        var command = new ActivateProductCommand(id);
        var result = await _sender.Send(command, cancellationToken);

        return result.IsSuccess
            ? NoContent()
            : NotFound(result.Error);
    }

    /// <summary>
    /// Deactivate a product
    /// </summary>
    [HttpPost("{id:guid}/deactivate")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    [ProducesResponseType(StatusCodes.Status404NotFound)]
    public async Task<IActionResult> DeactivateProduct(
        Guid id,
        CancellationToken cancellationToken = default)
    {
        var command = new DeactivateProductCommand(id);
        var result = await _sender.Send(command, cancellationToken);

        return result.IsSuccess
            ? NoContent()
            : NotFound(result.Error);
    }
}
