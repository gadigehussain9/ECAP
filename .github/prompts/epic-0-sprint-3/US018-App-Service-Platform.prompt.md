# ECAP - EPIC 0 - Sprint 3 - US-018 Azure App Service Platform

## Role

You are a Principal Azure Cloud Architect implementing the Enterprise Commerce & AI Platform (ECAP).

Generate production-quality Azure infrastructure.

Do NOT generate tutorial code.

Reuse the existing ECAP architecture and standards.

Only implement the Azure App Service hosting platform.

---

# Before Implementation

Review the repository.

Read:

## Enterprise Foundation

docs/EPICs/epic-0-enterprise-foundation/

## Product Catalog

docs/EPICs/epic-01-product-catalog/

## Architecture

docs/architecture/

docs/architecture/adr/

## Development Standards

docs/development/

## AI Standards

docs/AI/

Analyze the existing infrastructure.

Reuse:

- globals
- naming
- tags
- monitoring
- diagnostics
- networking
- layered orchestration

Do not rewrite existing modules.

---

# Business Objective

Provision the enterprise hosting platform for ECAP.

This platform will host:

- Product Catalog API
- AI API
- GraphQL API
- Background Workers
- Future Microservices

The implementation must be reusable across environments.

---

# Resources

Deploy:

Microsoft.Web/serverfarms

Microsoft.Web/sites

---

# App Service Plan

Implement:

- Linux
- Premium v3 (parameterized)
- Configurable SKU
- Configurable instance count
- Zone redundancy parameter
- Per-site scaling support

Parameterize all sizing options.

---

# App Service

Deploy:

Enterprise App Service.

Implement:

- HTTPS Only
- HTTP/2
- TLS 1.2+
- Always On
- Health Check Path
- ARR Affinity disabled
- WebSockets configurable
- FTPS disabled
- Public access configurable
- Managed Identity (System Assigned)
- Diagnostic Settings
- Log Analytics integration

---

# Runtime

Support configuration for:

.NET 10

Parameterize runtime version.

Do not hardcode.

---

# App Settings

Prepare App Settings for future integration.

Include placeholders for:

Azure OpenAI Endpoint

Azure AI Search Endpoint

Azure SQL Connection (Managed Identity)

Storage Account

Application Insights

App Configuration

Key Vault References

Do not use secrets.

---

# Networking

Current Sprint:

Public endpoint allowed.

Prepare for:

Private Endpoint

Regional VNet Integration

Access Restrictions

Private DNS

Do not deploy them yet.

---

# Security

Implement:

HTTPS Only

Minimum TLS 1.2

Managed Identity

Azure RBAC readiness

Key Vault reference readiness

No secrets in configuration.

---

# Monitoring

Reuse existing monitoring modules.

Configure:

Application Insights

Diagnostic Settings

Log Analytics

Health Check

---

# Outputs

Expose:

App Service Name

App Service Resource ID

Default Hostname

Managed Identity Principal ID

App Service Plan Name

---

# Integration

Update only:

platform.bicep

app.bicep

main.bicep

Parameter files

Maintain layered architecture.

---

# Future Readiness

Design for future support of:

Deployment Slots

Blue-Green Deployments

Canary Deployments

Autoscale Rules

Private Endpoints

Container Apps (future evaluation)

No redesign should be required later.

---

# Validation

Generate:

Azure CLI deployment command

PowerShell deployment command

Bicep validation

What-If deployment

Portal verification checklist

---

# Documentation

Document:

Purpose

Inputs

Outputs

Dependencies

Security

Networking

Monitoring

Future Enhancements

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ ECAP Standards

✓ Azure Resource Standards

✓ Bicep Standards

✓ Security Standards

✓ Enterprise Naming

✓ Enterprise Tags

✓ Managed Identity Ready

✓ Reusable Modules

✓ Environment Independence

✓ Production Ready

Before generating code:

1. Explain the proposed architecture.
2. Explain why App Service is chosen over Container Apps for the current phase.
3. Explain how the platform supports future AI services.
4. Explain how Managed Identity will be used in the next user story.

Generate production-ready infrastructure only.
