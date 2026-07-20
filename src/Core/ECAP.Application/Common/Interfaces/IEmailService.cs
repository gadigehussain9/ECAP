namespace ECAP.Application.Common.Interfaces;

/// <summary>
/// Interface for sending emails.
/// </summary>
public interface IEmailService
{
    Task SendEmailAsync(string to, string subject, string body, CancellationToken cancellationToken = default);
}
