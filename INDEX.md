# GuideTree — Skill Index

Hierarchical project planning and execution pipeline. Decompose any project from goal → phases → stages → steps, with validation gates at every level.

---

## Pipeline Overview

```
create_project_context
    ↓
generate_phase_skeleton → validate_phase_skeleton
    ↓
expand_phase_to_stage_dag → validate_stage_dag
    ↓
expand_stage_to_steps → validate_steps
    ↓
execute_step (repeat)
    ↓
validate_stage_result
    ↓
(advance to next stage/phase, or complete)
```

The orchestrator (`orchestrate_project`) controls the entire loop.

---

## Skill Families

### guidetree-init — Project Initialization

| Skill | Description |
|-------|-------------|
| `create_project_context` | Normalize raw project description into structured context: goals, requirements, constraints, users, success criteria, assumptions, and open questions |

### guidetree-planning — Phase-Level Planning

| Skill | Description |
|-------|-------------|
| `generate_phase_skeleton` | Decompose project context into lifecycle phases with goals, acceptance criteria, inputs/outputs, and dependencies |
| `validate_phase_skeleton` | Validate phase skeleton against project context: check completeness, dependency DAG, coverage, and acceptance criteria quality |

### guidetree-expansion — Stage-Level Expansion

| Skill | Description |
|-------|-------------|
| `expand_phase_to_stage_dag` | Expand one validated phase into a stage-level DAG with goals, acceptance criteria, and phase coverage mapping |
| `validate_stage_dag` | Validate stage DAG: check schema, dependency DAG, phase coverage, scope appropriateness, and no embedded steps |

### guidetree-steps — Step-Level Decomposition

| Skill | Description |
|-------|-------------|
| `expand_stage_to_steps` | Expand one validated stage into executable steps with concrete actions, expected outputs, and acceptance criteria |
| `validate_steps` | Validate steps: check executability, dependency DAG, stage coverage, action concreteness, and acceptance criteria quality |

### guidetree-execution — Step Execution & Validation

| Skill | Description |
|-------|-------------|
| `execute_step` | Execute exactly one validated step: perform the action, produce the output, check acceptance criteria, record evidence |
| `validate_stage_result` | Validate completed stage: verify step outputs collectively satisfy the stage goal, outputs, and acceptance criteria |

### guidetree-orchestration — Pipeline Orchestration

| Skill | Description |
|-------|-------------|
| `orchestrate_project` | Select the next correct skill based on project state, enforce workflow rules, prevent invalid transitions, delegate to appropriate skills |

---

## Repair Strategy

When validation fails, the orchestrator routes back to the corresponding generate/expand skill with the validation report as repair context. No separate repair skills are needed.

| Validation Failure | Repair Route |
|-------------------|--------------|
| `validate_phase_skeleton` fails | Route to `generate_phase_skeleton` with validation feedback |
| `validate_stage_dag` fails | Route to `expand_phase_to_stage_dag` with validation feedback |
| `validate_steps` fails | Route to `expand_stage_to_steps` with validation feedback |
| `validate_stage_result` fails (step defect) | Route to `expand_stage_to_steps` |
| `validate_stage_result` fails (execution) | Route to `execute_step` for re-execution |

---

## Shared References

- `_shared/acceptance_criteria_rules.md` — Valid and invalid acceptance criteria patterns, shared by all validation skills
