using ECAP.Api.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ECAP.Api.Controllers;

/// <summary>
/// Authentication controller for login, logout, and token management
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IJwtTokenGenerator _jwtTokenGenerator;
    private readonly ILogger<AuthController> _logger;

    public AuthController(
        IJwtTokenGenerator jwtTokenGenerator,
        ILogger<AuthController> logger)
    {
        _jwtTokenGenerator = jwtTokenGenerator;
        _logger = logger;
    }

    /// <summary>
    /// Login endpoint (DEMO - integrate with your actual user management)
    /// </summary>
    [HttpPost("login")]
    [AllowAnonymous]
    public IActionResult Login([FromBody] LoginRequest request)
    {
        // TODO: Replace with actual user authentication via Identity or custom service
        // This is a demo implementation showing how to generate tokens

        if (string.IsNullOrWhiteSpace(request.Email) || string.IsNullOrWhiteSpace(request.Password))
        {
            return BadRequest(new { error = "Email and password are required" });
        }

        // DEMO: Accept any credentials for development
        // In production, validate against database/Identity
        var userId = Guid.NewGuid();
        var roles = new[] { "User" }; // TODO: Get from database

        var token = _jwtTokenGenerator.GenerateToken(userId, request.Email, roles);

        _logger.LogInformation("User {Email} logged in successfully", request.Email);

        return Ok(new LoginResponse
        {
            Token = token,
            ExpiresIn = 3600, // seconds
            TokenType = "Bearer"
        });
    }

    /// <summary>
    /// Get current user info from token
    /// </summary>
    [HttpGet("me")]
    [Authorize]
    public IActionResult GetCurrentUser()
    {
        var userId = User.FindFirst("sub")?.Value;
        var email = User.FindFirst("email")?.Value;
        var roles = User.Claims.Where(c => c.Type == "http://schemas.microsoft.com/ws/2008/06/identity/claims/role")
                               .Select(c => c.Value)
                               .ToList();

        return Ok(new
        {
            userId,
            email,
            roles
        });
    }

    /// <summary>
    /// Admin-only endpoint example
    /// </summary>
    [HttpGet("admin-only")]
    [Authorize(Policy = "RequireAdminRole")]
    public IActionResult AdminOnly()
    {
        return Ok(new { message = "You have admin access!" });
    }
}

public record LoginRequest
{
    public string Email { get; init; } = string.Empty;
    public string Password { get; init; } = string.Empty;
}

public record LoginResponse
{
    public string Token { get; init; } = string.Empty;
    public int ExpiresIn { get; init; }
    public string TokenType { get; init; } = string.Empty;
}
