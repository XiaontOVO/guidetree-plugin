# Step: Identify Technical Bottleneck

**Step ID:** phase_1_stage_1_step_2
**Stage:** Research Objective Clarified (phase_1_stage_1)
**Phase:** Research Framing and Literature Grounding (phase_1)

## Objective

Identify which component of the verifier circuit in existing folding schemes dominates the cost, providing a concrete optimization target.

## Action

Analyze the verifier circuit structure of representative folding schemes (Nova, Protostar) to identify the dominant cost component. Document which operations (elliptic curve scalar multiplications, hash computations, polynomial evaluations, commitment verifications) contribute most to verifier circuit size. Produce a bottleneck analysis table.

## Expected Output

A bottleneck analysis table listing:
- Verifier circuit components
- Estimated constraint/gate count per component
- Percentage of total verifier circuit
- Which components are amenable to optimization

## Acceptance Criteria

- [ ] At least one identifiable bottleneck or hypothesis is stated
- [ ] Bottleneck analysis references specific verifier circuit components (not just "the verifier is expensive")
- [ ] Analysis identifies which components are amenable to optimization vs inherently required

## Inputs

- Refined research question from step 1

## Dependencies

- phase_1_stage_1_step_1 (Refine Research Question)

## Risks

- Bottleneck hypothesis may be wrong without detailed prior-art analysis (which comes in stage 3)
- Different folding schemes may have different bottleneck structures
