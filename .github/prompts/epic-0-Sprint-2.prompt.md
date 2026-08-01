# ECAP - EPIC 0 Sprint 2

You are a Principal Azure Cloud Architect implementing the Enterprise Commerce & AI Platform (ECAP).

## Before generating code

Review the existing repository.

Read:

- docs/handbook/epic-0-enterprise-foundation/
- docs/architecture/
- docs/architecture/adr/
- docs/development/*.md (all files)

Analyze the existing Bicep implementation before modifying it.

Do not rewrite working modules.

Refactor only where required.

---

## Sprint Goal

Implement the Security and Configuration foundation.

Deploy:

- Managed Identity
- Azure Key Vault
- Azure App Configuration

using reusable Bicep modules.

---

## Architecture Requirements

Follow:

- Infrastructure Strategy
- Azure Resource Standards
- Bicep Standards
- Security Standards

Use:

- Layered orchestration
- Reusable modules
- Parameterized deployments
- Environment-specific parameter files
- Enterprise naming module
- Enterprise tags module

---

## Managed Identity

Create a reusable module.

Requirements:

- System Assigned Managed Identity (default)
- Option to support User Assigned later
- Outputs:
  - Resource ID
  - Principal ID
  - Client ID

Explain why each output is required.

---

## Azure Key Vault

Create a reusable module.

Requirements:

- RBAC authorization
- Soft Delete enabled
- Purge Protection configurable
- Diagnostic settings
- Standard naming
- Standard tags
- HTTPS only

Do not use legacy Access Policies unless there is a documented reason.

Outputs:

- Vault URI
- Resource ID
- Name

---

## RBAC

Grant the Managed Identity the minimum required permissions.

Use Azure RBAC instead of Key Vault Access Policies.

Explain every role assignment.

---

## App Configuration

Create a reusable module.

Requirements:

- Managed Identity support
- Standard tags
- Diagnostic settings
- Private Endpoint support (future-ready)
- Outputs:
  - Endpoint
  - Resource ID
  - Name

---

## Validation

Generate:

- Deployment validation steps
- Azure CLI deployment commands
- PowerShell deployment commands
- Expected Azure Portal verification steps

---

## Documentation

Update:

README.md

Document:

- Module purpose
- Inputs
- Outputs
- Dependencies

---

## Quality Checklist

Before finishing verify:

✓ Infrastructure Strategy

✓ Azure Resource Standards

✓ Bicep Standards

✓ Security Standards

✓ Enterprise Naming

✓ Enterprise Tags

✓ Environment Independence

✓ Reusable Modules

✓ CI/CD Ready

Explain every architectural decision.
