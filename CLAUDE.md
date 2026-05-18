# GuideTree — AI Agent Guidelines

> **One project, one pipeline. Generate, validate, expand, execute — in order.**

## If You Are an AI Agent

This plugin decomposes projects into a hierarchical pipeline: project → phase → stage → step. Each level has generation, validation, and expansion skills. The orchestrator enforces sequencing and prevents invalid transitions.

**Core principle:** Generate first, validate before expanding, expand before executing, execute before validating results. Never skip a gate.

## The GuideTree Model

```
Project Goal
     ↓
create_project_context  (normalize requirements, constraints, success criteria)
     ↓
generate_phase_skeleton (decompose into lifecycle phases)
     ↓
validate_phase_skeleton (verify phases cover the project goal)
     ↓
expand_phase_to_stage_dag (decompose one phase into stages)
     ↓
validate_stage_dag      (verify stages cover the phase)
     ↓
expand_stage_to_steps   (decompose one stage into executable steps)
     ↓
validate_steps          (verify steps are executable and cover the stage)
     ↓
execute_step            (perform one concrete action)
     ↓  (repeat until stage complete)
validate_stage_result   (verify all step outputs satisfy the stage goal)
     ↓  (repeat for all stages, then advance to next phase)
orchestrate_project     (controls the entire loop)
```

## Skill Families

| Family | Role |
|--------|------|
| `guidetree-init` | Bootstrap: normalize project context from raw user input |
| `guidetree-planning` | Phase-level: generate and validate the project phase skeleton |
| `guidetree-expansion` | Stage-level: expand one phase into a stage DAG, validate it |
| `guidetree-steps` | Step-level: expand one stage into steps, validate them |
| `guidetree-execution` | Do the work: execute one step, validate stage results |
| `guidetree-orchestration` | Control: select the next skill and enforce the pipeline |

## The Orchestrator

`orchestrate_project` is the central control skill. It:

1. Inspects the current project state
2. Determines what exists and what's valid
3. Selects exactly one next skill to invoke
4. Prepares the minimal input for that skill
5. Returns the decision to the runtime

**The runtime loop:**
```
while project not terminal:
    decision = orchestrate_project(project_state)
    if decision != invoke_skill: stop
    result = invoke(selected_skill, selected_skill_input)
    project_state = persist(result)
```

## When to Use Each Skill

| Situation | Skill |
|-----------|-------|
| Raw project description received | `create_project_context` |
| Project context ready, no phases | `generate_phase_skeleton` |
| Phases generated, not validated | `validate_phase_skeleton` |
| Phase valid, no stages | `expand_phase_to_stage_dag` |
| Stages generated, not validated | `validate_stage_dag` |
| Stage valid, no steps | `expand_stage_to_steps` |
| Steps generated, not validated | `validate_steps` |
| Step ready to execute | `execute_step` |
| All steps in stage completed | `validate_stage_result` |
| Don't know what to do next | `orchestrate_project` |

## Repair Is Regeneration

When validation fails, the orchestrator routes back to the appropriate generate/expand skill with the validation report and blocking issues as additional context. There are no separate repair skills — the generate skills handle both creation and repair.

- Phase validation fails → `generate_phase_skeleton` (with validation feedback)
- Stage validation fails → `expand_phase_to_stage_dag` (with validation feedback)
- Step validation fails → `expand_stage_to_steps` (with validation feedback)
- Stage result validation fails → `expand_stage_to_steps` or `execute_step` (depending on root cause)

## Validation Gates (Enforced)

1. No phases before project_context exists
2. No stages before phase_skeleton is valid
3. No steps before stage_dag is valid
4. No execution before steps are valid
5. No stage validation before required steps are complete
6. No phase advancement before all required stages are validated

## Key Rules

- **One skill at a time** — the orchestrator selects exactly one skill per invocation
- **Validate before expanding** — never expand an artifact that hasn't passed validation
- **Execute within scope** — execute_step performs only the step's action, nothing more
- **Evidence required** — acceptance criteria must be checked with evidence, not assumed
- **Stop on blockers** — when the orchestrator detects blockers, it stops for operator input
- **Maintain the hierarchy** — project → phase → stage → step, never skip a level

## File Layout

```
skills/
  orchestrate_project/SKILL.md
  create_project_context/SKILL.md
  generate_phase_skeleton/SKILL.md
  validate_phase_skeleton/SKILL.md
  expand_phase_to_stage_dag/SKILL.md
  validate_stage_dag/SKILL.md
  expand_stage_to_steps/SKILL.md
  validate_steps/SKILL.md
  execute_step/SKILL.md
  validate_stage_result/SKILL.md

_shared/
  acceptance_criteria_rules.md    ← shared validation rules

catalog/
  skills.yml                      ← skill registry

.claude-plugin/
  plugin.json                     ← plugin manifest
```

## Output Conventions

Each skill returns valid JSON conforming to its `output_schema`. The skill output includes a `next_action.recommended_skill` field that hints at the next step — but the orchestrator makes the final decision.

**Status values** follow the project_state.status enum: `initialized`, `planning`, `validating_plan`, `expanding`, `validating_structure`, `executing`, `validating_stage`, `validating_phase`, `validating_project`, `blocked`, `needs_revision`, `failed`, `completed`.

## What Not To Do

- **Do NOT skip validation gates.** If an artifact hasn't been validated, don't expand it.
- **Do NOT execute before validation.** Steps must pass `validate_steps` before execution.
- **Do NOT expand multiple phases/stages at once.** Each expansion skill targets exactly one.
- **Do NOT treat assumptions as facts.** Mark all inferred information with confidence levels.
- **Do NOT hide blockers.** Report blockers with required_resolution in the output.
