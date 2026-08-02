
# ECAP - EPIC 0 Sprint 3 - US-014 Enterprise Storage Foundation

You are a Principal Azure Cloud Architect implementing the Enterprise Commerce & AI Platform (ECAP).

## Before Implementation

Review the repository.

Read the following documentation:

### Enterprise Foundation

docs/EPICs/epic-0-enterprise-foundation/

### Architecture

docs/architecture/

docs/architecture/adr/

### Development Standards

docs/development/

### AI Standards

docs/AI/

Analyze the existing infrastructure.

Do NOT rewrite working modules.

Only implement the Storage Account functionality.

Reuse:

- globals.bicep
- naming.bicep
- tags.bicep
- platform.bicep
- data.bicep

Follow the existing orchestration pattern.

---

## Business Objective

Create an enterprise Azure Storage Account module that serves as the central storage service for ECAP.

The module must support future AI, RAG, Product Catalog, Inventory, Orders, and Reporting workloads.

---

## Architecture Requirements

Follow:

- Azure Well-Architected Framework
- Azure Cloud Adoption Framework
- ECAP Infrastructure Strategy
- Azure Resource Standards
- Bicep Standards

---

## Resource Requirements

Deploy:

Microsoft.Storage/storageAccounts

Storage Kind:

StorageV2

Minimum TLS:

TLS1_2

HTTPS Only:

Enabled

Public Blob Access:

Disabled

Large File Shares:

Configurable

Shared Key Access:

Disabled by default (parameterized)

Infrastructure Encryption:

Enabled where supported

Allow future Private Endpoint integration.

---

## Services

Enable support for:

- Blob
- Queue
- Table
- File

---

## Diagnostics

Integrate with:

- Log Analytics
- Application Insights (where applicable)
- Diagnostic Settings

Reuse the existing monitoring modules if available.

---

## Security

Use:

- Azure RBAC
- Managed Identity ready
- Enterprise Tags
- Enterprise Naming

Do not configure access keys in code.

Do not generate secrets.

---

## Outputs

Return:

- Storage Account Name
- Resource ID
- Blob Endpoint
- Queue Endpoint
- Table Endpoint
- File Endpoint

---

## Integration

Update:

- data.bicep
- platform.bicep (if required)
- main.bicep

Only make incremental changes.

---

## Validation

Generate:

- Azure CLI deployment
- PowerShell deployment
- Bicep validation
- Azure Portal verification steps

---

## Documentation

Update the infrastructure README if necessary.

Document:

- Purpose
- Inputs
- Outputs
- Dependencies

---

## Quality Checklist

Verify:

✓ Enterprise Naming

✓ Enterprise Tags

✓ Infrastructure Standards

✓ Security Standards

✓ Azure Standards

✓ Reusable Module

✓ Environment Independent

✓ Documentation Updated

Explain every architectural decision before generating code.

Do not generate tutorial code.

Generate production-ready enterprise implementation only.
