# Research Audit Phases

This directory contains the phase definitions for the research-audit domain template.

Each phase is defined in a separate YAML file following the pattern `P{n}.yaml`.

## Phase Index

| Phase | ID | Name | Purpose |
|-------|----|------|---------|
| 1 | P1 | Claims Verification | Extract and verify quantitative claims against raw evidence |
| 2 | P2 | Citation Audit | Three-layer citation verification: existence, metadata, context |
| 3 | P3 | Adversarial Review | Construct strongest rejection, then objectively adjudicate |
| 4 | P4 | Iterative Improvement | Review-fix loops until positive assessment or MAX_ROUNDS |
| 5 | P5 | Rebuttal Drafting | Structured rebuttal with safety gates and stress test |
| 6 | P6 | Quality Gating | Independent scoring and PASS/WARN/FAIL decision |

## Phase Selection by Audit Type

Not every audit needs all 6 phases. Select based on audit type:

- **peer_review_response**: P1, P3, P4, P5 (verify claims, attack, iterate, rebut)
- **self_audit**: P1, P2, P3, P4, P6 (verify claims, audit citations, attack, iterate, gate)
- **full_audit_pipeline**: All 6 phases
- **citation_only_audit**: P2 only

## Dependency Order

```
P1 (Claims) --> P2 (Citations) --> P3 (Adversarial) --> P4 (Improvement) --> P5 (Rebuttal) --> P6 (Gating)
```

Claims must be verified before citations are audited for context. Citations must
be audited before adversarial review. Adversarial review must identify weaknesses
before iterative improvement. Improvement must occur before rebuttal drafting.
Quality gating comes last.
