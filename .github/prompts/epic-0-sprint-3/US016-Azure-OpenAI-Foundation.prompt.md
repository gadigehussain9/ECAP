# ECAP - EPIC 0 - Sprint 3 - US-016 Azure OpenAI Foundation

## Role

You are a Principal Azure AI Architect and Enterprise Cloud Architect implementing the Enterprise Commerce & AI Platform (ECAP).

This repository follows enterprise architecture principles.

Do NOT generate tutorial code.

Generate production-quality, reusable, enterprise-ready infrastructure.

Reuse existing modules and follow the current ECAP repository standards.

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

Especially review:

- Use-Azure-OpenAI.md
- Adopt-Azure-AI-Foundry-and-Azure-OpenAI.md
- Use-Bicep.md

## AI Standards

docs/AI/

Review:

- prompt-engineering.md
- rag-standards.md
- vector-search.md
- ai-evaluation.md
- llm-security.md
- model-governance.md

## Development Standards

docs/development/

Review:

- coding-standards.md
- security-standards.md
- logging-standards.md

Analyze the existing implementation before making any changes.

Reuse existing naming, tagging, globals, monitoring and orchestration modules.

Do NOT rewrite existing infrastructure.

Only add Azure OpenAI infrastructure.

---

# Business Objective

Provision Azure OpenAI as the enterprise AI platform for ECAP.

The platform must support future AI capabilities including:

- Product Catalog AI
- Product Recommendations
- AI Search
- Retrieval Augmented Generation (RAG)
- Prompt Engineering
- AI Agents
- Product Classification
- Product Description Generation
- AI Chat Assistant

Design for long-term scalability.

---

# Existing Architecture

Reuse the existing layered architecture.

main.bicep

↓

platform.bicep

↓

ai.bicep

↓

modules/ai/

Do not change the existing orchestration pattern.

---

# Resources

Deploy:

Microsoft.CognitiveServices/accounts

Kind:

OpenAI

---

# Azure OpenAI Resource

Implement:

- Enterprise naming convention
- Enterprise tags
- Configurable Azure region
- Configurable SKU
- Public network access configurable
- Future Private Endpoint support
- Managed Identity ready
- Azure RBAC ready
- Diagnostic Settings
- Log Analytics integration

Do not hardcode values.

---

# Model Deployments

Create reusable deployment modules.

Implement two deployments.

## Chat Model

Support parameters:

- deploymentName
- modelName
- modelVersion
- capacity (where supported)

Default deployment name:

chat

Do NOT hardcode GPT model names.

Model names and versions must be configurable because availability varies by Azure region and subscription.

---

## Embedding Model

Support parameters:

- deploymentName
- modelName
- modelVersion

Default deployment name:

embeddings

Model names must be configurable.

---

# Configuration

Store model configuration as parameters or centralized configuration objects.

Avoid scattered parameters.

Follow the existing ECAP configuration approach.

---

# Security

Follow ECAP security standards.

Support:

- Microsoft Entra ID authentication where available
- Azure RBAC
- Future Managed Identity integration
- Azure Key Vault integration if API keys are required

Do not expose secrets.

Do not embed API keys.

Do not generate application authentication code.

Infrastructure only.

---

# Networking

Current sprint:

Public access may remain enabled.

However the implementation must be ready for:

- Private Endpoint
- Private DNS Zone
- Network ACLs

Do not deploy Private Endpoints yet.

---

# Monitoring

Reuse existing monitoring modules.

Configure:

- Diagnostic Settings
- Log Analytics

Enable categories supported by Azure OpenAI.

---

# Outputs

Expose:

Azure OpenAI Resource

- Resource Name
- Resource ID
- Endpoint
- Location

Chat Deployment

- Deployment Name

Embedding Deployment

- Deployment Name

Outputs must be reusable by future AI provider modules.

---

# Integration

Update only where required.

Integrate with:

- ai.bicep
- platform.bicep
- main.bicep
- globals.bicep
- naming.bicep
- tags.bicep

Do not break existing modules.

---

# Validation

Generate:

Azure CLI deployment command

PowerShell deployment command

Bicep validation command

What-If deployment command

Azure Portal verification checklist

---

# Documentation

Update documentation where appropriate.

Document:

Purpose

Architecture

Inputs

Outputs

Dependencies

Security considerations

Future AI Provider integration

Future Azure AI Foundry integration

Do not duplicate existing documentation.

---

# Future Readiness

Design the module so future resources can be added without redesign.

Examples:

- Azure AI Search
- Azure AI Foundry
- GPT-5 family models
- Image models
- Speech models
- AI Agents
- Prompt Flow
- Model Router

---

# Deliverables

Generate:

- azure-openai.bicep
- openai-deployment.bicep (or equivalent reusable deployment module)
- Updates to ai.bicep
- Required parameter files
- Required outputs
- Documentation updates

Maintain the existing repository structure.

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ ECAP Architecture Standards

✓ Azure Resource Standards

✓ Bicep Standards

✓ Security Standards

✓ AI Standards

✓ Enterprise Naming

✓ Enterprise Tags

✓ Reusable Modules

✓ Environment Independence

✓ Backward Compatibility

✓ Documentation Updated

Before generating code:

1. Explain the proposed architecture.
2. Identify existing modules that will be reused.
3. Explain why each architectural decision was made.

Generate production-ready enterprise infrastructure only.

Do not generate tutorial examples.
