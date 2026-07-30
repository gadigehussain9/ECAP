# ECAP AI Model Governance Standards

| Item | Value |
|------|-------|
| Document | AI Model Governance Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | AI Platform Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines governance standards for Artificial Intelligence models used within the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Ensure reliable AI deployments
- Standardise model lifecycle management
- Improve security
- Improve auditability
- Support Responsible AI
- Reduce operational risk
- Enable controlled upgrades

These standards apply to all AI models used by ECAP.

---

# 2. Scope

This document applies to:

- Azure OpenAI Chat Models
- Embedding Models
- Reranking Models
- Image Models
- Speech Models
- Future Custom ML Models
- Third-party AI Providers

---

# 3. Governance Principles

Every AI model must be:

- Approved
- Versioned
- Documented
- Tested
- Monitored
- Auditable
- Replaceable
- Secure

No AI model may be used in production without approval.

---

# 4. Model Inventory

Maintain an inventory for every model.

Each record should include:

- Model Name
- Provider
- Version
- Purpose
- Owner
- Approval Status
- Deployment Date
- Retirement Date
- Region
- Cost Centre

Example

| Model | Purpose |
|--------|----------|
| GPT-4.1 | Chat |
| text-embedding-3-large | Embeddings |
| GPT-4.1-mini | Low-cost chat |

---

# 5. Model Selection

Model selection should consider:

- Accuracy
- Latency
- Cost
- Context Window
- Tool Calling Support
- Structured Output Support
- Availability
- Security
- Responsible AI capabilities

Choose the smallest model that satisfies the business requirement.

---

# 6. Version Management

Every model version shall be recorded.

Example

```
GPT-4.1

↓

GPT-4.1 Revision X

↓

Future Approved Version
```

Applications must avoid hard-coding model identifiers where configuration can be used.

---

# 7. Model Registry

Maintain a central registry.

Example

```
Model

Purpose

Provider

Version

Status

Owner

Approved

Retirement Date
```

The registry should be version controlled.

---

# 8. Approval Process

Before production:

- Architecture Review
- Security Review
- AI Evaluation
- Performance Testing
- Cost Review
- Responsible AI Review
- Operational Approval

All approvals should be documented.

---

# 9. Deployment Strategy

Support:

- Development
- Test
- QA
- Production

Deployments should support:

- Blue/Green
- Canary
- Gradual Rollout
- Rollback

---

# 10. Model Configuration

Store configuration outside application code.

Configuration includes:

- Model Name
- Deployment Name
- API Version
- Temperature
- Max Tokens
- Top P
- Retry Policy
- Timeout

Use Azure App Configuration and Azure Key Vault where appropriate.

---

# 11. Monitoring

Capture:

- Latency
- Token Usage
- Error Rate
- Availability
- Cost
- User Feedback
- Evaluation Scores
- Content Safety Events

Use Azure Monitor and Application Insights.

---

# 12. Cost Governance

Track:

- Cost per Request
- Cost per User
- Daily Cost
- Monthly Cost
- Token Consumption
- Budget Thresholds

Configure alerts when thresholds are exceeded.

---

# 13. Responsible AI

Every production model shall be reviewed for:

- Fairness
- Transparency
- Privacy
- Safety
- Accountability

Business owners remain responsible for decisions made using AI-assisted outputs.

---

# 14. Security

Models shall:

- Use Managed Identity where supported
- Protect API credentials
- Restrict network access
- Log security events
- Restrict model access using RBAC

---

# 15. Evaluation

Before promotion:

- Accuracy evaluation
- Groundedness evaluation
- Hallucination testing
- Regression testing
- Safety evaluation
- Performance testing

Reference: AI Evaluation Standards.

---

# 16. Change Management

Any of the following requires a governance review:

- Model replacement
- Major version upgrade
- Prompt strategy change
- Embedding model change
- RAG architecture change
- Retrieval strategy change

Document the impact before implementation.

---

# 17. Rollback Strategy

Rollback must be possible when:

- Evaluation fails
- Latency increases significantly
- Error rate exceeds thresholds
- Safety incidents occur
- Cost exceeds approved limits

Previous approved configurations should remain available.

---

# 18. Retirement

A model should be retired when:

- Deprecated by the provider
- No longer supported
- Replaced by an approved model
- Security concerns arise
- Business requirements change

Retirement plans should include migration guidance.

---

# 19. Audit Requirements

Maintain records of:

- Model Version
- Prompt Version
- Deployment Date
- Evaluation Report
- Approval Records
- Rollback History
- Security Reviews

Audit records should follow organisational retention policies.

---

# 20. Best Practices

- Maintain a model registry.
- Separate configuration from code.
- Version prompts and models independently.
- Monitor continuously.
- Review costs regularly.
- Test before deployment.
- Keep rollback simple.
- Document every production model.

---

# 21. Anti-Patterns

Avoid:

- Hard-coded model names.
- Production deployments without evaluation.
- Silent model upgrades.
- Mixing development and production models.
- Ignoring cost trends.
- Skipping governance reviews.
- Using deprecated models.

---

# 22. References

- Prompt Engineering Standards
- AI Evaluation Standards
- RAG Standards
- LLM Security Standards
- Security Standards
- Azure AI Foundry Documentation
- Azure OpenAI Documentation
- Microsoft Responsible AI Guidance
- NIST AI Risk Management Framework
