
# ECAP - EPIC 0 - Sprint 3 - US-017 Azure AI Search Foundation

## Role

You are a Principal Azure AI Architect, Search Architect, and Enterprise Cloud Architect implementing the Enterprise Commerce & AI Platform (ECAP).

This repository follows enterprise architecture principles.

Generate production-quality infrastructure.

Do NOT generate tutorial code.

Reuse existing ECAP infrastructure, naming, monitoring, and security standards.

Only implement Azure AI Search infrastructure.

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

## AI Standards

docs/AI/

Review:

- rag-standards.md
- vector-search.md
- prompt-engineering.md
- ai-evaluation.md
- llm-security.md
- model-governance.md

## Development Standards

docs/development/

Analyze the existing implementation.

Reuse existing:

- globals
- naming
- tags
- monitoring
- diagnostics
- platform orchestration

Do NOT rewrite working modules.

---

# Business Objective

Provision Azure AI Search as the enterprise search platform for ECAP.

The implementation must support future:

- Semantic Search
- Vector Search
- Hybrid Search
- Retrieval Augmented Generation (RAG)
- Product Search
- Product Recommendations
- AI Chat
- Knowledge Base Search
- AI Agents

The implementation must be reusable across all business modules.

---

# Existing Architecture

Maintain the existing layered architecture.

main.bicep

↓

platform.bicep

↓

ai.bicep

↓

azure-ai-search.bicep

Do not change repository architecture.

---

# Resources

Deploy:

Microsoft.Search/searchServices

---

# Azure AI Search

Implement:

- Enterprise naming
- Enterprise tags
- Configurable region
- Configurable SKU
- Replica count parameter
- Partition count parameter
- Public network access configurable
- Future Private Endpoint readiness
- Azure RBAC readiness
- Diagnostic Settings
- Log Analytics integration

Do not hardcode values.

---

# Search Capabilities

The infrastructure must support future implementation of:

- Full Text Search
- Semantic Search
- Vector Search
- Hybrid Search
- Filters
- Facets
- Scoring Profiles
- Synonym Maps
- Suggesters
- Autocomplete

Do not create indexes in this sprint.

Infrastructure only.

---

# Future Indexes

Design the module to support future indexes including:

Product Index

Inventory Index

Knowledge Base

Documentation

Customer Support

AI Memory

These indexes will be created during EPIC 2.

---

# Vector Search Readiness

Prepare the infrastructure for:

Azure OpenAI Embeddings

Vector Fields

Hybrid Search

Nearest Neighbor Search

Do not deploy vector indexes yet.

The architecture should support them without redesign.

---

# Semantic Search

Enable support for:

Semantic Ranking

Captions

Answers

Semantic Configuration

Where supported by SKU and service capabilities.

Parameterize the configuration.

---

# Security

Follow ECAP security standards.

Support:

- Azure RBAC
- Microsoft Entra ID
- Managed Identity integration (future)
- Private Endpoint readiness
- Private DNS readiness

Do not hardcode API keys.

Do not generate application authentication code.

Infrastructure only.

---

# Networking

Current sprint:

Public network access may remain enabled.

Prepare for future:

- Private Endpoint
- Network ACLs
- Private DNS

Do not deploy them now.

---

# Monitoring

Reuse existing monitoring modules.

Configure:

- Diagnostic Settings
- Log Analytics integration

Enable supported diagnostic categories.

---

# Outputs

Expose:

Search Service Name

Search Service Resource ID

Search Endpoint

Location

Replica Count

Partition Count

Outputs must be reusable by future application modules.

---

# Integration

Update only where necessary.

Integrate with:

- ai.bicep
- platform.bicep
- main.bicep
- globals.bicep
- naming.bicep
- tags.bicep

Maintain layered orchestration.

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

Update documentation where required.

Document:

Purpose

Architecture

Inputs

Outputs

Dependencies

Security

Future Vector Search

Future RAG Integration

Future Semantic Search

Do not duplicate existing documentation.

---

# Future Readiness

Design the module for future support of:

- Indexes
- Indexers
- Data Sources
- Skillsets
- Semantic Configurations
- Vector Configurations
- AI Enrichment
- Knowledge Store
- Prompt Flow
- AI Agents

No redesign should be required later.

---

# Deliverables

Generate:

- azure-ai-search.bicep
- Updates to ai.bicep
- Parameter updates
- Outputs
- Documentation updates

Reuse existing modules.

---

# Quality Checklist

Verify:

✓ Azure Well-Architected Framework

✓ Azure Cloud Adoption Framework

✓ ECAP Architecture Standards

✓ Azure Resource Standards

✓ AI Standards

✓ Security Standards

✓ Bicep Standards

✓ Enterprise Naming

✓ Enterprise Tags

✓ Reusable Modules

✓ Environment Independence

✓ Backward Compatibility

✓ Documentation Updated

Before generating code:

1. Explain the proposed architecture.
2. Explain how Azure AI Search integrates with Azure OpenAI.
3. Explain how this infrastructure enables future RAG.
4. Explain how this infrastructure enables Hybrid Search.
5. Explain how this infrastructure supports Semantic Search.

Generate production-ready enterprise infrastructure only.

Do not generate tutorial examples.
