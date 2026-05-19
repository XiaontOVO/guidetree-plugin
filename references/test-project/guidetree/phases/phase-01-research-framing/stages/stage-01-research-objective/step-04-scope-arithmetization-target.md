# Step: Scope Arithmetization Target

**Step ID:** phase_1_stage_1_step_4
**Stage:** Research Objective Clarified (phase_1_stage_1)
**Phase:** Research Framing and Literature Grounding (phase_1)

## Objective

Resolve whether the optimization targets R1CS-based folding (Nova-style), Plonkish/arithmetic-based folding (Protostar-style), or both, and document the decision with rationale.

## Action

Compare R1CS-based and Plonkish-based folding approaches in terms of:

1. Verifier circuit structure
2. Known optimization opportunities
3. Existing prior art density
4. Relevance to the bottleneck hypothesis from step 2

Make a scoped decision on the arithmetization target and document the rationale. If both are in scope, specify how they will be handled (separate analyses or unified framework).

## Expected Output

An arithmetization scoping document containing:
- Target arithmetization model(s)
- Rationale for inclusion/exclusion
- Expected verifier circuit structure differences
- Implications for downstream phases

## Acceptance Criteria

- [ ] Arithmetization target is explicitly stated (R1CS, Plonkish, or both)
- [ ] Rationale is provided for the choice
- [ ] Decision resolves open question UQ1 or documents why it remains deferred
- [ ] Implications for phase_2 (formal model) and phase_4 (protocol development) are noted

## Inputs

- Refined research question from step 1
- Bottleneck analysis from step 2

## Dependencies

- phase_1_stage_1_step_2 (Identify Technical Bottleneck)

## Risks

- Choosing only one arithmetization may limit the contribution scope
- Choosing both may make the project too broad
