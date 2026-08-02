
# ECAP - EPIC 0 Sprint 3 - US-015 Azure SQL Foundation

## Role

You are a Principal Azure Cloud Architect implementing the Enterprise Commerce & AI Platform (ECAP).

This repository represents an enterprise production-ready reference implementation.

Do not generate tutorial code.

Implement production-quality Azure SQL infrastructure.

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

Analyze the existing implementation.

Reuse the existing architecture.

Do NOT rewrite working modules.

Only implement Azure SQL infrastructure.

---

# Business Objective

Create reusable Azure SQL Server and Azure SQL Database modules that provide the enterprise data platform for ECAP.

---

# Resources

Deploy:

- Microsoft.Sql/servers
- Microsoft.Sql/servers/databases

---

# SQL Server Requirements

Implement:

- Configurable SQL Server name
- Azure region from globals
- Minimum TLS 1.2
- Public network access configurable
- Microsoft Entra ID administrator (parameterized)
- Future-ready for Private Endpoints
- Standard naming
- Standard tags

Do not hardcode any administrator credentials.

---

# SQL Database Requirements

Implement:

- Configurable database name
- Configurable SKU
- Configurable compute model (Provisioned or Serverless)
- Configurable zone redundancy
- Backup retention parameters
- Diagnostic settings
- Transparent Data Encryption

Provide sensible defaults for development while supporting production configurations.

---

# Security

Follow ECAP security standards.

Support:

- Microsoft Entra ID authentication
- Azure RBAC-ready design
- Managed Identity integration (future App Service)
- Minimal firewall exposure

Do not configure SQL logins for application authentication.

---

# Monitoring

Integrate with existing monitoring modules.

Configure:

- Diagnostic settings
- Log Analytics integration

Reuse existing monitoring resources where available.

---

# Outputs

Expose:

## SQL Server

- Resource ID
- Server Name
- Fully Qualified Domain Name

## SQL Database

- Database Name
- Resource ID

---

# Integration

Update only where necessary:

- data.bicep
- platform.bicep
- main.bicep
- Environment parameter files

Maintain the existing layered architecture.

---

# Validation

Generate:

- Azure CLI deployment command
- PowerShell deployment command
- Bicep validation steps
- Azure Portal verification checklist

---

# Documentation

Update documentation if required.

Document:

- Module purpose
- Inputs
- Outputs
- Dependencies
- Security considerations
- Future Managed Identity integration

---

# Quality Checklist

Verify:

✓ Clean Architecture

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ Enterprise Naming

✓ Enterprise Tags

✓ Azure Resource Standards

✓ Security Standards

✓ Environment Independence

✓ Reusable Modules

✓ Documentation Updated

Do not rewrite working code.

Only make incremental, production-ready additions that align with the existing ECAP architecture.

Explain every architectural decision before generating code.
