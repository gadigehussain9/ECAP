# EPIC-01: Enterprise Product Catalog

# Security Architecture

| Item | Value |
|------|-------|
| Epic ID | EPIC-01 |
| Epic Name | Enterprise Product Catalog |
| Document | Security Architecture |
| Version | 1.0 |
| Status | Approved |
| Owner | Security Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines the security architecture for the Enterprise Product Catalog.

The objective is to protect business data, APIs, infrastructure and identities using Microsoft's recommended cloud security practices.

Security shall be considered at every layer of the application and infrastructure.

---

# 2. Security Objectives

The solution shall provide:

- Confidentiality
- Integrity
- Availability
- Authentication
- Authorization
- Auditing
- Non-Repudiation
- Compliance
- Secure Defaults
- Least Privilege

---

# 3. Security Principles

The architecture follows:

- Zero Trust
- Defence in Depth
- Least Privilege
- Secure by Default
- Identity First
- Assume Breach
- Principle of Separation of Duties

---

# 4. High-Level Security Architecture

```
                    User
                     │
                     ▼
             Microsoft Entra ID
                     │
                     ▼
           Azure API Management
                     │
          JWT Validation Policy
                     │
                     ▼
             ASP.NET Core API
                     │
      Authentication Middleware
                     │
      Authorization Policies
                     │
             Application Layer
                     │
                Domain Layer
                     │
          Infrastructure Layer
                     │
      Azure SQL / Blob Storage
                     │
          Managed Identity
                     │
             Azure Key Vault
```

---

# 5. Authentication

Identity Provider

Microsoft Entra ID

Supported Authentication

- OAuth 2.0
- OpenID Connect

Token Type

JWT Access Token

The API trusts only tokens issued by the configured tenant.

---

# 6. Authorization

Authorization is Role-Based.

Example Roles

- ProductAdmin
- ProductManager
- MarketingManager
- CategoryManager
- ProductViewer

Example Permissions

| Operation | Role |
|------------|------|
| Create Product | ProductAdmin |
| Update Product | ProductAdmin |
| Delete Product | ProductAdmin |
| View Product | ProductViewer |
| Manage Categories | CategoryManager |
| Manage Metadata | MarketingManager |

Policy-based authorization should be preferred over hard-coded role checks.

---

# 7. API Security

Azure API Management responsibilities

- JWT Validation
- Subscription Key Validation (if required)
- Rate Limiting
- IP Filtering
- Header Validation
- Request Transformation
- Response Transformation
- CORS Policy
- Request Size Limits

---

# 8. Application Security

ASP.NET Core shall implement:

- HTTPS Redirection
- HSTS
- Authentication Middleware
- Authorization Middleware
- Exception Handling Middleware
- Input Validation
- Output Encoding
- Anti-forgery protection (where applicable)

---

# 9. Input Validation

Every request must be validated.

Validation includes:

- Required fields
- Maximum lengths
- Allowed values
- Business rules
- File size validation
- File type validation

FluentValidation shall be used.

---

# 10. Secrets Management

Secrets shall never be stored:

- In source code
- In configuration files
- In repositories

Secrets are stored in:

Azure Key Vault

Examples

- SQL Connection String
- Storage Account Secrets
- API Keys
- Certificates

Applications access secrets using Managed Identity.

---

# 11. Managed Identity

Managed Identity shall be used for:

- Azure SQL authentication
- Blob Storage access
- Key Vault access
- Application Insights
- Azure AI services (future)

No credentials should be embedded in the application.

---

# 12. Database Security

Azure SQL

- Transparent Data Encryption (TDE)
- Firewall Rules
- Private Endpoint (Production)
- Microsoft Entra Authentication
- Auditing Enabled

Application access occurs only through repositories.

---

# 13. Storage Security

Blob Storage

- Private Containers
- SAS Tokens (when required)
- HTTPS Only
- Soft Delete
- Versioning

Public anonymous access should be disabled.

---

# 14. Network Security

Production environment

- Private Endpoints
- Network Security Groups
- Web Application Firewall
- Azure Front Door (future)
- Application Gateway (future)
- DDoS Protection (future)

---

# 15. Logging & Auditing

Every security-sensitive operation should be logged.

Examples

- Login
- Token validation failures
- Product creation
- Product deletion
- Role changes
- Permission failures

Each log entry should include:

- Correlation ID
- User ID
- Timestamp
- Client IP
- Request Path
- Result

---

# 16. Error Handling

Error responses must not expose:

- Stack traces
- SQL details
- Internal implementation
- Secrets
- Connection strings

Use Problem Details (RFC 7807).

---

# 17. Security Headers

Responses should include:

- Strict-Transport-Security
- X-Content-Type-Options
- X-Frame-Options
- Referrer-Policy
- Content-Security-Policy (where applicable)

---

# 18. OWASP Top 10 Mitigations

| Risk | Mitigation |
|------|------------|
| Broken Access Control | RBAC + Policies |
| Cryptographic Failures | TLS + TDE + Key Vault |
| Injection | Parameterised queries + EF Core |
| Insecure Design | Clean Architecture |
| Security Misconfiguration | IaC + Secure Defaults |
| Vulnerable Components | Dependency Scanning |
| Identification Failures | Entra ID |
| Integrity Failures | CI/CD Validation |
| Logging Failures | App Insights + Monitor |
| SSRF | Validate outbound requests |

---

# 19. AI Security Readiness

Future AI services must:

- Authenticate using Managed Identity.
- Never expose prompts containing secrets.
- Validate AI-generated output.
- Log AI interactions.
- Restrict AI access to authorised users.
- Use approved Azure AI services.

---

# 20. Secure Development Checklist

Developers shall:

- Validate every request.
- Use parameterised queries.
- Avoid hard-coded secrets.
- Review dependencies regularly.
- Follow secure coding guidelines.
- Write security-focused unit tests.
- Conduct peer code reviews.

---

# 21. Security Traceability

| Security Control | Azure Service |
|------------------|---------------|
| Identity | Microsoft Entra ID |
| API Gateway | Azure API Management |
| Secret Management | Azure Key Vault |
| Monitoring | Application Insights |
| Logs | Azure Monitor |
| Database Encryption | Azure SQL |
| Storage Security | Azure Blob Storage |
| Authentication Between Services | Managed Identity |

---

# 22. References

- 06-Architecture.md
- 08-REST-API.md
- 10-Azure-Resources.md
- 12-Deployment.md
