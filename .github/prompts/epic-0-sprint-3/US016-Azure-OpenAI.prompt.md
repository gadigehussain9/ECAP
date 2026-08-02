# ECAP - EPIC 0 Sprint 3 - US-016 Azure OpenAI Foundation

## Role

You are a Principal Azure AI Architect implementing the Enterprise Commerce & AI Platform (ECAP).

This repository is an enterprise production-ready reference implementation.

Generate production-quality Azure AI infrastructure.

Do not generate tutorial code.

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

Pay particular attention to:

- Use-Azure-OpenAI.md
- Adopt-Azure-AI-Foundry-and-Azure-OpenAI.md

## Development Standards

docs/development/

## AI Standards

docs/AI/

Review:

- prompt-engineering.md
- rag-standards.md
- vector-search.md
- ai-evaluation.md
- llm-security.md
- model-governance.md

Analyze the existing implementation.

Reuse the existing architecture.

Do NOT rewrite working modules.

Implement only Azure OpenAI infrastructure.

---

# Business Objective

Provision Azure OpenAI as the enterprise AI platform for ECAP.

The implementation must support future AI workloads including RAG, Product Catalog AI, Semantic Search, Recommendations, and AI Agents.

---

# Resources

Deploy:

Microsoft.CognitiveServices/accounts

Kind:

OpenAI

---

# Azure OpenAI Requirements

Implement:

- Configurable resource name
- Azure region from globals
- Enterprise naming
- Enterprise tags
- Diagnostic settings
- Future Private Endpoint support
- Azure RBAC-ready design

Do not embed API keys.

---

# Model Deployments

Create reusable deployment resources.

Support:

## Chat Model

Parameters:

- deploymentName
- modelName
- modelVersion

## Embedding Model

Parameters:

- deploymentName
- modelName
- modelVersion

Model names and versions must be parameterized because availability varies by Azure region and subscription.

---

# Security

Support:

- Microsoft Entra ID authentication where available
- Azure RBAC
- Managed Identity integration (future App Service)
- Azure Key Vault integration for configuration if keys are required

Do not hardcode secrets.

---

# Monitoring

Reuse existing monitoring modules.

Configure:

- Diagnostic Settings
- Log Analytics integration

---

# Outputs

Expose:

Azure OpenAI

- Resource ID
- Name
- Endpoint

Chat Deployment

- Deployment Name

Embedding Deployment

- Deployment Name

---

# Integration

Update only where necessary:

- ai.bicep
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
- Future AI Provider integration

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ Enterprise Naming

✓ Enterprise Tags

✓ Azure Resource Standards

✓ AI Standards

✓ Security Standards

✓ Environment Independence

✓ Reusable Modules

✓ Documentation Updated

Do not rewrite working code.

Only make incremental, production-ready additions.

Explain every architectural decision before generating code.
