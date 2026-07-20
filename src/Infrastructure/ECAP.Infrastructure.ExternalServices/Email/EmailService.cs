using ECAP.Application.Common.Interfaces;

namespace ECAP.Infrastructure.ExternalServices.Email;

/// <summary>
/// Placeholder email service implementation.
/// </summary>
public class EmailService : IEmailService
{
    public async Task SendEmailAsync(string to, string subject, string body, CancellationToken cancellationToken = default)
    {
        // TODO: Implement actual email sending logic (SendGrid, SMTP, etc.)
        await Task.CompletedTask;
    }
}
