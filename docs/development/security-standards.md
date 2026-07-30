# ECAP Security Standards

| Item | Value |
|------|-------|
| Document | Security Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | Security Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the security standards for the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Protect customer and business data.
- Prevent unauthorized access.
- Secure APIs and cloud resources.
- Ensure regulatory compliance.
- Reduce security vulnerabilities.
- Implement security by design.

These standards apply to all applications, APIs, Azure resources, AI services and CI/CD pipelines.

---

# 2. Security Principles

ECAP follows these principles:

- Zero Trust
- Least Privilege
- Defence in Depth
- Secure by Default
- Security by Design
- Privacy by Design
- Fail Securely
- Assume Breach

---

# 3. Identity and Authentication

Authentication shall use:

- Microsoft Entra ID
- OAuth 2.0
- OpenID Connect
- JWT Access Tokens

Authentication must never rely on:

- Basic Authentication
- Shared credentials
- Hard-coded passwords

Production APIs shall not expose anonymous endpoints except where explicitly approved.

---

# 4. Authorization

Authorization shall use:

- Policy-based authorization
- Claims-based authorization
- Fine-grained permissions

Example policies:

```
Catalog.Read

Catalog.Write

Orders.Read

Orders.Manage

Payments.Process
```

Avoid role checks directly in controllers.

---

# 5. API Security

All APIs must:

- Enforce HTTPS
- Validate JWT tokens
- Validate token audience
- Validate issuer
- Validate expiration
- Validate scopes or permissions
- Reject invalid requests
- Apply rate limiting
- Apply quotas where appropriate

Azure API Management is the primary gateway for external APIs.

---

# 6. Secrets Management

Secrets must never be stored in:

- Source code
- Git repositories
- Configuration files
- Docker images
- Pipeline YAML

Secrets shall be stored in:

- Azure Key Vault

Applications should authenticate using Managed Identity whenever supported.

---

# 7. Managed Identity

Azure resources should use Managed Identity for accessing:

- Azure Key Vault
- Azure SQL Database
- Azure Storage
- Azure AI Foundry
- Azure AI Search
- Azure Service Bus

Avoid client secrets where Managed Identity is available.

---

# 8. Data Protection

Sensitive data must be:

- Encrypted in transit
- Encrypted at rest
- Access controlled
- Audited

TLS 1.2 or later is required for all communications.

---

# 9. Input Validation

Validate all client input.

Validation includes:

- Required values
- Length
- Format
- Range
- Business rules
- File size
- File type

Never trust client-side validation alone.

---

# 10. OWASP Top 10 Protection

ECAP shall protect against:

- Broken Access Control
- Cryptographic Failures
- Injection
- Insecure Design
- Security Misconfiguration
- Vulnerable Components
- Authentication Failures
- Software Integrity Failures
- Logging Failures
- Server-Side Request Forgery (SSRF)

Security testing shall verify these protections.

---

# 11. SQL Injection Prevention

Always use:

- Entity Framework Core
- Parameterised queries
- LINQ

Avoid:

- Dynamic SQL
- String concatenation in SQL statements

---

# 12. Cross-Site Scripting (XSS)

Prevent XSS by:

- Encoding output
- Validating input
- Sanitising user-generated content where appropriate
- Using Content Security Policy (CSP) where applicable

---

# 13. Cross-Site Request Forgery (CSRF)

Browser-based applications shall:

- Use anti-forgery protection where appropriate.
- Validate origins for state-changing requests.

Stateless APIs secured with bearer tokens generally do not require anti-forgery tokens.

---

# 14. File Upload Security

Uploaded files must:

- Be virus scanned (where applicable)
- Validate MIME type
- Validate extension
- Validate size
- Be stored outside the web root
- Use generated file names

Never trust client-provided file names.

---

# 15. Logging and Auditing

Log:

- Authentication failures
- Authorization failures
- Administrative actions
- Security events
- Configuration changes
- AI moderation events (where applicable)

Never log:

- Passwords
- Tokens
- Secrets
- Connection strings
- Full payment details
- Sensitive personal data

Use structured logging with correlation IDs.

---

# 16. Data Classification

Data shall be classified as:

| Classification | Examples |
|----------------|----------|
| Public | Product catalogue, documentation |
| Internal | Operational reports |
| Confidential | Customer profiles, invoices |
| Restricted | Secrets, encryption keys, access tokens |

Handling requirements must match the classification.

---

# 17. AI Security

AI features shall:

- Use approved prompts
- Validate user input
- Protect confidential business data
- Apply content filtering
- Record prompt metadata
- Capture token usage
- Prevent prompt injection where possible

AI responses must not be treated as authoritative without appropriate business validation.

---

# 18. Infrastructure Security

Azure resources shall:

- Use Private Endpoints where appropriate
- Disable public access unless required
- Apply Network Security Groups (NSGs) where applicable
- Use Azure Firewall or equivalent controls where required
- Enable diagnostic logging
- Apply Azure Policy
- Apply resource locks for critical production resources

---

# 19. CI/CD Security

Pipelines shall:

- Use least-privilege service connections
- Protect secrets
- Require Pull Request reviews
- Run automated security scanning
- Run dependency vulnerability scanning
- Run Infrastructure as Code validation
- Prevent deployment on failed security checks

---

# 20. Dependency Management

Third-party packages shall:

- Come from trusted sources
- Be actively maintained
- Be regularly updated
- Be scanned for vulnerabilities

Avoid unnecessary package dependencies.

---

# 21. Monitoring and Incident Response

Monitor:

- Failed logins
- Suspicious API usage
- Unusual traffic patterns
- Privilege changes
- Key Vault access
- Managed Identity failures
- AI service failures

Critical security alerts shall be routed to the operations team.

---

# 22. Backup and Recovery

Security-related assets must support recovery, including:

- Azure Key Vault (soft delete and purge protection)
- Azure SQL backups
- Infrastructure as Code (Bicep)
- Configuration backups

Recovery procedures shall be documented and tested.

---

# 23. Compliance

ECAP aligns with:

- Microsoft Security Development Lifecycle (SDL)
- Azure Well-Architected Framework
- OWASP Top 10
- Zero Trust Architecture
- Clean Architecture
- Microsoft Entra ID best practices

---

# 24. Security Review Checklist

Every Pull Request should verify:

- No hard-coded secrets
- Authentication enforced
- Authorization verified
- Input validated
- Logging implemented
- Error messages sanitised
- Dependencies reviewed
- Tests updated
- Documentation updated

---

# 25. References

- ADR-002 – Adopt Clean Architecture
- ADR-004 – Adopt Azure AI Foundry and Azure OpenAI
- ADR-005 – Adopt Bicep
- API Standards
- Coding Standards
- Microsoft Security Development Lifecycle
- Azure Well-Architected Framework
- OWASP Top 10
