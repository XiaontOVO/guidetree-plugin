# Step: Define Success Criteria

**Step ID:** phase_1_stage_1_step_3
**Stage:** Research Objective Clarified (phase_1_stage_1)
**Phase:** Research Framing and Literature Grounding (phase_1)

## Objective

Define concrete, verifiable success criteria for the research project that tie to the verifier circuit optimization goal.

## Action

Draft success criteria that specify:

1. Minimum verifier circuit reduction threshold relative to baseline
2. Security requirements (completeness, knowledge soundness must be preserved)
3. Acceptable tradeoff bounds (how much prover cost or proof size increase is tolerable)
4. Required evidence type (formal proof + complexity analysis + benchmark)

Each criterion must be verifiable by a third party.

## Expected Output

A success criteria document listing each criterion with:
- Criterion text
- Verification method
- Acceptable threshold or evidence
- Dependency on downstream phases

## Acceptance Criteria

- [ ] Each success criterion is verifiable by inspection, review, test, or measurable evidence
- [ ] No criterion uses vague phrases like "improved performance" or "better efficiency"
- [ ] Security preservation is explicitly stated as a success criterion
- [ ] Tradeoff bounds are specified (verifier circuit reduction is not meaningful at unlimited cost elsewhere)

## Inputs

- Refined research question from step 1
- Bottleneck analysis from step 2

## Dependencies

- phase_1_stage_1_step_2 (Identify Technical Bottleneck)

## Risks

- Success criteria may be too strict, making the project infeasible
- Tradeoff bounds may be arbitrary without prior-art grounding
