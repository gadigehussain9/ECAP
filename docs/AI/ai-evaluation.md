# ECAP AI Evaluation Standards

| Item | Value |
|------|-------|
| Document | AI Evaluation Standards |
| Project | Enterprise Commerce & AI Platform (ECAP) |
| Version | 1.0 |
| Status | Approved |
| Owner | AI Architect |
| Last Updated | 2026-07-30 |

---

# 1. Purpose

This document defines how AI features are evaluated within the Enterprise Commerce & AI Platform (ECAP).

The objectives are to:

- Measure AI quality
- Detect regressions
- Improve response accuracy
- Reduce hallucinations
- Improve customer experience
- Support continuous AI improvement

Evaluation is required for every AI capability before production deployment.

---

# 2. Evaluation Principles

AI evaluation should be:

- Repeatable
- Automated where practical
- Version controlled
- Measurable
- Transparent
- Business-focused
- Independent of model provider

Every AI change should be evaluated before release.

---

# 3. Evaluation Lifecycle

```
Prompt Change

↓

Evaluation Dataset

↓

Model Execution

↓

Metric Calculation

↓

Review

↓

Approval

↓

Deployment

↓

Production Monitoring
```

---

# 4. Evaluation Types

ECAP supports multiple evaluation categories.

## Functional Evaluation

Measures whether the AI completes the requested task correctly.

Examples:

- Product recommendation
- Product search
- Chat response
- Classification
- Summarisation

---

## RAG Evaluation

Measures retrieval quality.

Examples:

- Retrieval relevance
- Groundedness
- Citation quality
- Context utilisation

---

## Prompt Evaluation

Measures prompt quality.

Examples:

- Instruction following
- Format compliance
- Stability
- Consistency

---

## Safety Evaluation

Measures:

- Harmful content
- Prompt injection resistance
- Sensitive data exposure
- Policy compliance
- Toxicity

---

## Performance Evaluation

Measures:

- Latency
- Throughput
- Availability
- Error rate
- Token consumption

---

# 5. Evaluation Dataset

Maintain representative datasets for each AI capability.

Each test case should contain:

- Test Case ID
- Scenario
- User Input
- Expected Behaviour
- Expected Output (when applicable)
- Evaluation Criteria
- Priority

Store datasets in source control.

---

# 6. Core Quality Metrics

## Accuracy

Does the response correctly answer the user's question?

Target:

> 90%

---

## Relevance

Does the response match the user's intent?

Target:

> 90%

---

## Groundedness

Is the answer supported by retrieved knowledge?

Target:

> 95%

---

## Completeness

Does the response contain all required information?

Target:

> 90%

---

## Consistency

Does the model produce similar high-quality responses for equivalent requests?

Target:

High consistency across repeated evaluations.

---

## Citation Quality

When citations are expected:

- Correct source
- Correct section
- No fabricated references

---

## Hallucination Rate

Responses containing unsupported facts.

Target:

< 2%

---

## Safety

Responses should comply with organisational Responsible AI policies.

Target:

100%

---

# 7. Performance Metrics

Track:

| Metric | Target |
|--------|--------|
| Total Response Time | <5 seconds |
| Retrieval Time | <300 ms |
| AI Generation Time | <3 seconds |
| Availability | >99.9% |
| Error Rate | <1% |

---

# 8. Cost Metrics

Track:

- Prompt tokens
- Completion tokens
- Total tokens
- Cost per request
- Cost per user
- Daily cost
- Monthly cost

Monitor trends over time.

---

# 9. Regression Testing

Re-run evaluation whenever:

- Prompt changes
- Model changes
- Embedding model changes
- Search configuration changes
- Chunking strategy changes
- System prompt changes

Production deployment requires successful regression results.

---

# 10. Human Evaluation

Human reviewers should assess:

- Usefulness
- Clarity
- Correctness
- Tone
- Business suitability

Human evaluation is required for high-impact scenarios.

---

# 11. Automated Evaluation

Automated evaluation may include:

- Rule-based validation
- JSON schema validation
- Keyword matching
- LLM-assisted evaluation (with appropriate oversight)
- Custom scoring algorithms

Automated results should be reviewed periodically for accuracy.

---

# 12. Failure Categories

Classify failures consistently.

Examples:

- Hallucination
- Missing information
- Incorrect citation
- Retrieval failure
- Prompt failure
- Safety violation
- Formatting error
- Timeout

---

# 13. Evaluation Reports

Reports should include:

- Model version
- Prompt version
- Embedding version
- Dataset version
- Overall score
- Metric breakdown
- Failure summary
- Recommendations

Store reports with release artifacts where appropriate.

---

# 14. Production Monitoring

Monitor:

- User feedback
- Token usage
- Latency
- Retrieval quality
- Failure rate
- Empty responses
- Safety events

Use Application Insights and Azure Monitor for telemetry.

---

# 15. Acceptance Criteria

An AI feature is production-ready when:

- Required evaluation datasets pass.
- Accuracy targets are met.
- Safety checks pass.
- Performance targets are met.
- Regression tests pass.
- Documentation is updated.

---

# 16. Continuous Improvement

Regularly:

- Review failed evaluations.
- Improve prompts.
- Improve retrieval quality.
- Refresh evaluation datasets.
- Optimise token usage.
- Monitor production feedback.

Evaluation is an ongoing process, not a one-time activity.

---

# 17. Best Practices

- Version prompts.
- Version datasets.
- Version models.
- Measure before deploying.
- Combine automated and human evaluation.
- Track trends over time.
- Evaluate representative business scenarios.

---

# 18. Anti-Patterns

Avoid:

- Deploying prompt changes without evaluation.
- Measuring only latency.
- Ignoring hallucinations.
- Using tiny evaluation datasets.
- Relying solely on manual testing.
- Ignoring user feedback.
- Optimising only for token cost.

---

# 19. References

- Prompt Engineering Standards
- RAG Standards
- Vector Search Standards
- Security Standards
- Logging Standards
- Testing Standards
- Azure AI Foundry Evaluation Guidance
- Azure OpenAI Documentation
- Microsoft Responsible AI Guidance
