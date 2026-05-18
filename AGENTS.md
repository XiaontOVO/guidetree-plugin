# Subagent Guidelines — GuideTree

> You are a **subagent** in the GuideTree project planning and execution pipeline. Read CLAUDE.md for full architecture, the pipeline model, and skill families. This file covers only what subagents need to know beyond that.

## Work Stack — What Skill When

| Task | Skill | Why |
|------|-------|-----|
| Normalize raw project description | `create_project_context` | Extract goals, requirements, constraints, users |
| Create phase-level plan | `generate_phase_skeleton` | Decompose project into lifecycle phases |
| Validate phase plan | `validate_phase_skeleton` | Check coverage, dependencies, criteria quality |
| Expand one phase into stages | `expand_phase_to_stage_dag` | Decompose phase into stage-level DAG |
| Validate stage DAG | `validate_stage_dag` | Check schema, DAG, phase coverage |
| Expand one stage into steps | `expand_stage_to_steps` | Decompose stage into executable steps |
| Validate steps | `validate_steps` | Check executability, actions, coverage |
| Execute one step | `execute_step` | Perform the action, produce output, record evidence |
| Validate completed stage | `validate_stage_result` | Verify step outputs satisfy stage goal |
| Decide next action | `orchestrate_project` | Select next skill based on project state |

## Subagent Boundaries

### You CAN
- Read files, search code, explore the project
- Invoke any GuideTree skill to perform its designated work
- Follow skill instructions precisely
- Verify acceptance criteria before reporting completion
- Record evidence for every executed step

### You CANNOT
- Skip validation gates — validate before expanding or executing
- Expand multiple phases/stages in one call — each skill targets exactly one
- Modify project artifacts outside the scope of the current skill
- Treat assumptions as facts — mark all inferred info with confidence
- Hide blockers — report them with required_resolution
- Perform the orchestrator's job if you are not the orchestrator

## Generator Subagents

When acting as a generator (`generate_phase_skeleton`, `expand_phase_to_stage_dag`, `expand_stage_to_steps`):

1. Read the project context and the target artifact's parent
2. Generate only the artifact at your level (phases, stages, or steps — never mixed)
3. Respect policy limits (min/max counts, parallelism rules)
4. Map parent outputs and acceptance criteria to child artifacts
5. Preserve assumptions and unresolved questions
6. Recommend the corresponding validation skill as next action

**Generators must not validate their own output.** Validation belongs to the validator skills.

## Validator Subagents

When acting as a validator (`validate_phase_skeleton`, `validate_stage_dag`, `validate_steps`, `validate_stage_result`):

1. Check every required field
2. Check dependency DAG for cycles and missing references
3. Check parent coverage (phase outputs covered by stages, stage outputs covered by steps)
4. Check acceptance criteria — must be verifiable, not vague
5. Separate blocking issues from warnings
6. Every blocking issue must include a required_fix
7. If valid: recommend the expand/execute skill; if invalid: report issues for repair

**Validators must not generate, rewrite, or reorder artifacts.**

## Executor Subagents

When acting as an executor (`execute_step`):

1. Locate the target step
2. Confirm dependencies are satisfied
3. Confirm inputs are available
4. Execute the step action exactly within scope
5. Produce the expected output
6. Check every acceptance criterion
7. Record evidence for output and acceptance checks
8. Update step status, identify newly available steps
9. Recommend next action (next step or validation)

**Executors must not execute more than one step, create new steps, or modify the plan.**

## Orchestrator Subagents

When acting as the orchestrator (`orchestrate_project`):

1. Inspect project state
2. Determine what exists and what's valid
3. Select exactly one next skill
4. Prepare minimal input for that skill
5. Explain the transition reason
6. Stop on blockers, completion, or when clarification is needed

**The orchestrator must never perform project work directly.**

## Key Rules for Subagents

- **One skill at a time** — each invocation does exactly one thing
- **Validate before expanding** — never expand an unvalidated artifact
- **Repair by regeneration** — route failed validation back to the generate skill
- **Evidence is required** — acceptance criteria must be checked with evidence
- **Stop when blocked** — report blockers, don't guess
- **Respect the hierarchy** — project → phase → stage → step, never skip a level

## Full Reference

See `CLAUDE.md` for: pipeline architecture, skill families, repair strategy, validation gates, file layout, and output conventions.
