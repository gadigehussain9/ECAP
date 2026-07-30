using System.Diagnostics;

namespace ECAP.Api.Middleware;

/// <summary>
/// Middleware that ensures every request has a correlation ID for tracing.
/// </summary>
public class CorrelationIdMiddleware
{
    private readonly RequestDelegate _next;
    private const string CorrelationIdHeader = "X-Correlation-ID";

    public CorrelationIdMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Get or create correlation ID
        var correlationId = context.Request.Headers[CorrelationIdHeader].FirstOrDefault()
            ?? Activity.Current?.Id
            ?? Guid.NewGuid().ToString();

        // Add to response headers
        context.Response.Headers.Append(CorrelationIdHeader, correlationId);

        // Add to activity for distributed tracing
        Activity.Current?.AddBaggage("CorrelationId", correlationId);

        // Add to HttpContext for easy access in controllers/handlers
        context.Items["CorrelationId"] = correlationId;

        await _next(context);
    }
}
