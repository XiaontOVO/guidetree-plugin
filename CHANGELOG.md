# Changelog

## 1.0.0 (2026-05-18)

### Added
- Initial plugin structure with 10 skills across 6 families
- `create_project_context` — normalize raw project description into structured context
- `generate_phase_skeleton` — decompose project into lifecycle phases
- `validate_phase_skeleton` — validate phase coverage, DAG, and criteria quality
- `expand_phase_to_stage_dag` — decompose one phase into stage-level DAG
- `validate_stage_dag` — validate stage schema, DAG, and phase coverage
- `expand_stage_to_steps` — decompose one stage into executable steps
- `validate_steps` — validate step executability, actions, and stage coverage
- `execute_step` — execute one step with evidence collection
- `validate_stage_result` — validate completed stage against acceptance criteria
- `orchestrate_project` — central pipeline control and skill selection
- Repair strategy: route validation failures back to generate skills (no separate repair skills)
- Hierarchical pipeline model: project → phase → stage → step
- Validation gates at every level
- CLAUDE.md agent guidelines
- AGENTS.md subagent guidelines
- INDEX.md skill index
- SessionStart hook for context injection
- Shared acceptance criteria rules (`_shared/acceptance_criteria_rules.md`)
- Plugin self-validation infrastructure (hooks, catalog, references)
