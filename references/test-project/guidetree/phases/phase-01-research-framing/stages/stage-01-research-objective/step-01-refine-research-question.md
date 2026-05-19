# Step: Refine Research Question

**Step ID:** phase_1_stage_1_step_1
**Stage:** Research Objective Clarified (phase_1_stage_1)
**Phase:** Research Framing and Literature Grounding (phase_1)

## Objective

Transform the raw project goal into a precise, technically meaningful research question that specifies the optimization target and scope.

## Action

Draft a refined research question that specifies:

1. The folding scheme component being optimized (verifier circuit)
2. The metric for measuring improvement (constraint count or gate count)
3. The class of folding schemes under consideration
4. The constraints on the optimization (must preserve soundness and completeness)

Document the question in a structured format with question text, scope, and exclusions.

## Expected Output

A refined research question document containing:
- Precise question text
- Scope specification
- Excluded topics
- Relationship between the question and the project goal

## Acceptance Criteria

- [ ] Research question is not merely "study ZKP" or "optimize folding schemes"
- [ ] Question specifies verifier circuit reduction as the optimization target
- [ ] Scope identifies whether the target is R1CS-based, Plonkish-based, or both
- [ ] Question is falsifiable -- it can be disproven by later analysis

## Inputs

- Project goal from project_context
- Initial research question from project_context

## Dependencies

None (this is the first step).

## Risks

- Question may be too broad if both R1CS and Plonkish folding are included
- Question may be too narrow if only one specific scheme is targeted
