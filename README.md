# GuideTree

> Hierarchical project planning and execution pipeline for Claude Code. From a raw project description to validated, executed steps — with gates at every level.

## What It Does

GuideTree decomposes complex projects into a hierarchical pipeline: **project → phase → stage → step**. Each level has dedicated generation, validation, and execution skills. An orchestrator controls the entire loop, enforcing validation gates and preventing invalid transitions.

**Core capabilities:**
- **Initialize**: Normalize a raw project description into structured context (`create_project_context`)
- **Plan**: Generate and validate a phase skeleton covering the full project lifecycle
- **Expand**: Decompose phases into stage DAGs, then stages into executable steps
- **Execute**: Run one step at a time with evidence collection and acceptance checking
- **Validate**: Verify results at every level — step outputs, stage completion, phase coverage
- **Orchestrate**: Central control skill selects the next correct action based on project state

## Quick Start

```bash
# Install the plugin
claude plugins install guidetree@guidetree

# Start a project — just describe what you want to build
/guidetree:orchestrate_project

# Or begin with project context
/guidetree:create_project_context
```

## The GuideTree Pipeline

```
Project Goal
     ↓
create_project_context    (normalize requirements, constraints)
     ↓
generate_phase_skeleton   (decompose into lifecycle phases)
     ↓
validate_phase_skeleton   (verify phase coverage)
     ↓
expand_phase_to_stage_dag (decompose one phase into stages)
     ↓
validate_stage_dag        (verify stage coverage)
     ↓
expand_stage_to_steps     (decompose one stage into steps)
     ↓
validate_steps            (verify step executability)
     ↓
execute_step              (perform one action)
     ↓  (repeat)
validate_stage_result     (verify stage completion)
     ↓  (advance to next stage/phase)
orchestrate_project       (controls the loop)
```

## Skills

| Skill | Family | Description |
|-------|--------|-------------|
| `create_project_context` | init | Normalize raw description into structured project context |
| `generate_phase_skeleton` | planning | Generate lifecycle phases with goals, criteria, dependencies |
| `validate_phase_skeleton` | planning | Validate phases: coverage, DAG, criteria quality |
| `expand_phase_to_stage_dag` | expansion | Decompose one phase into stage-level DAG |
| `validate_stage_dag` | expansion | Validate stages: schema, DAG, phase coverage |
| `expand_stage_to_steps` | steps | Decompose one stage into executable steps |
| `validate_steps` | steps | Validate steps: actions, dependencies, stage coverage |
| `execute_step` | execution | Execute one step: perform action, produce output, record evidence |
| `validate_stage_result` | execution | Validate completed stage against acceptance criteria |
| `orchestrate_project` | orchestration | Select next skill, enforce workflow rules, prevent invalid transitions |

## Repair Strategy

No separate repair skills. When validation fails, the orchestrator routes back to the generation skill that created the defective artifact — this time with the validation report as repair context.

| Validation Failure | Repair Route |
|-------------------|--------------|
| Phase skeleton invalid | → `generate_phase_skeleton` + validation feedback |
| Stage DAG invalid | → `expand_phase_to_stage_dag` + validation feedback |
| Steps invalid | → `expand_stage_to_steps` + validation feedback |
| Stage result invalid (steps OK) | → `execute_step` for re-execution |
| Stage result invalid (step defect) | → `expand_stage_to_steps` |

## Validation Gates

1. No phases before project_context exists
2. No stages before phase_skeleton is valid
3. No steps before stage_dag is valid
4. No execution before steps are valid
5. No stage validation before required steps are complete
6. No phase advancement before all required stages are validated

## Plugin Structure

```
guidetree/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── CLAUDE.md
├── AGENTS.md
├── README.md
├── LICENSE
├── CHANGELOG.md
├── INDEX.md
├── catalog/
│   └── skills.yml
├── hooks/
│   ├── hooks.json
│   ├── session-start
│   └── session-start.ps1
├── skills/                  ← 10 skill definitions
│   ├── orchestrate_project/SKILL.md
│   ├── create_project_context/SKILL.md
│   ├── generate_phase_skeleton/SKILL.md
│   ├── validate_phase_skeleton/SKILL.md
│   ├── expand_phase_to_stage_dag/SKILL.md
│   ├── validate_stage_dag/SKILL.md
│   ├── expand_stage_to_steps/SKILL.md
│   ├── validate_steps/SKILL.md
│   ├── execute_step/SKILL.md
│   └── validate_stage_result/SKILL.md
├── references/
│   └── paths.yml
└── _shared/
    └── acceptance_criteria_rules.md
```

## Principles

- **Generate, validate, expand, execute** — in order, every time
- **One skill at a time** — the orchestrator selects exactly one per invocation
- **Repair by regeneration** — reuse generation skills with feedback, no separate repair skills
- **Evidence required** — acceptance criteria must be checked with evidence, not assumed
- **Hierarchy preserved** — project → phase → stage → step, never skip a level

## License

MIT — see [LICENSE](LICENSE).
