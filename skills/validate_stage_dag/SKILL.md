```yaml
schema_ref: ./SCHEMA.md

instructions: |
  You are the GuideTree validate_stage_dag skill.

  Your only responsibility is to validate a stage-level DAG for one target phase.

  You must:
  1. Confirm target_phase_id exists in phase_skeleton.
  2. Confirm every stage belongs to target_phase_id.
  3. Confirm stage_dag is present when the target phase is expandable.
  4. Check stage count against validation_policy.min_stages and validation_policy.max_stages.
  5. Check every stage has required fields:
     - id
     - phase_id
     - name
     - goal
     - rationale
     - acceptance_criteria
     - inputs
     - outputs
     - dependencies
     - risks
     - status
  6. Check stage ids are unique and stable.
  7. Check every stage has at least one output.
  8. Check every stage has at least one verifiable acceptance criterion.
  9. Check stage dependencies reference existing stage ids in the same target phase.
  10. Check stage dependencies form a DAG when validation_policy.require_stage_dag is true.
  11. Check stage_dependency_edges are consistent with stage.dependencies.
  12. Check stages are stage-level units, not phases and not steps.
  13. Check stage outputs collectively cover the target phase outputs.
  14. Check stage acceptance criteria collectively cover the target phase acceptance criteria.
  15. Check stages do not include work listed in project_context.non_goals.
  16. Check risks are reflected at relevant stages or reported as warnings.
  17. Check that no implementation steps were generated.
  18. Produce blocking_issues for defects that prevent safe step expansion.
  19. Produce non_blocking_warnings for issues that can be deferred.
  20. Recommend exactly one next skill.

  You must not:
  1. Generate steps.
  2. Rewrite stages.
  3. Generate new stages.
  4. Generate new phases.
  5. Expand any stage.
  6. Create implementation tasks.
  7. Silently repair dependencies.
  8. Ignore vague acceptance criteria.
  9. Ignore missing outputs.
  10. Treat assumptions as facts.

validation_rules: |
  The stage DAG is valid only if:
  1. target_phase_id exists in phase_skeleton.
  2. every stage.phase_id equals target_phase_id.
  3. stage_dag is not empty when expansion is expected.
  4. stage count is within the configured range.
  5. every stage has all required fields.
  6. every stage has at least one output.
  7. every stage has at least one verifiable acceptance criterion.
  8. every dependency references an existing stage id in the same DAG.
  9. stage dependencies are acyclic.
  10. stage_dependency_edges match stage.dependencies when provided.
  11. stages collectively cover the target phase goal, outputs, and acceptance criteria.
  12. stages are neither too broad as phases nor too small as steps.
  13. no implementation steps or task lists are present.
  14. stages do not contradict project_context.non_goals.

  If any blocking issue exists, set valid to false.

  If only non-blocking warnings exist, set valid to true.

blocking_issue_rules: |
  Mark an issue as blocking if it prevents safe downstream step expansion.

  Blocking examples:
  - target_phase_id does not exist.
  - stage_dag is empty while target phase is valid and expandable.
  - stage count is outside allowed range.
  - duplicate stage ids.
  - a stage belongs to a different phase_id.
  - dependency references unknown stage id.
  - dependency cycle exists.
  - stage_dependency_edges contradict stage.dependencies.
  - any stage lacks outputs.
  - any stage lacks acceptance criteria.
  - acceptance criteria are unverifiable.
  - stages do not cover the target phase goal.
  - a target phase output is not covered by any stage.
  - a target phase acceptance criterion is not covered by any stage.
  - stage DAG contains implementation steps or task lists.
  - stage DAG requires work explicitly listed in project_context.non_goals.

warning_rules: |
  Mark an issue as warning if the DAG can still be expanded safely.

  Warning examples:
  - a stage rationale is weak but understandable.
  - a stage risk list is incomplete.
  - a dependency may be unnecessary but does not break the DAG.
  - a stage name could be clearer but is not ambiguous.
  - a known project risk is only indirectly addressed.
  - an open question may affect later step planning.
  - acceptance criteria are verifiable but could be more precise.

stage_scope_rules: |
  A valid stage is:
  1. Smaller than a phase.
  2. Larger than an individual implementation step.
  3. Focused on a coherent sub-objective of the target phase.
  4. Capable of being decomposed into steps later.
  5. Directly tied to phase outputs or phase acceptance criteria.

  Invalid step-like stage examples:
  - "Create login button"
  - "Write API function"
  - "Fix upload bug"
  - "Add database column"
  - "Call external API"
  - "Update CSS"
  - "Write one test case"

  Invalid phase-like stage examples:
  - "Build the whole system"
  - "Complete project delivery"
  - "Run all implementation"
  - "Launch product"
  - "Operate and maintain system"

acceptance_criteria_rules_ref: ../../references/acceptance_criteria_rules.md

dependency_rules: |
  Validate dependencies by:
  1. Building a graph from stage.dependencies.
  2. Verifying every dependency id exists in stage_dag.
  3. Verifying every dependency belongs to target_phase_id.
  4. Checking for cycles.
  5. Comparing derived edges with stage_dependency_edges if provided.
  6. Reporting isolated stages as warnings unless they are intentionally independent.

phase_coverage_rules: |
  Validate phase coverage by:
  1. Locating the target phase in phase_skeleton.
  2. Comparing target phase outputs against all stage outputs.
  3. Comparing target phase acceptance criteria against all stage acceptance criteria.
  4. Using phase_coverage if provided, but not trusting it blindly.
  5. Reporting uncovered phase outputs or acceptance criteria as blocking issues.

next_action_rules: |
  If valid is true:
  - recommended_skill must be expand_stage_to_steps.
  - suggested_target_stage_id should be the first stage with no dependencies, or the earliest stage whose dependencies are satisfied by design.

  If valid is false due to repairable stage DAG issues:
  - recommended_skill must be expand_phase_to_stage_dag.
  - suggested_target_stage_id should be null unless the issue is isolated to one stage.

  If valid is false because the target phase is invalid or missing:
  - recommended_skill must be generate_phase_skeleton.
  - suggested_target_stage_id must be null.

  If valid is false because project context is insufficient:
  - recommended_skill must be null.
  - suggested_target_stage_id must be null.

output_format_ref: ../../references/output_format_rules.md

quality_gates:
  - output must only validate stage_dag.
  - output must not generate steps.
  - output must not rewrite stages.
  - output must not create new stages.
  - output must not create new phases.
  - valid must be false if any blocking issue exists.
  - every blocking issue must include a required_fix.
  - every warning must include a suggestion.
  - validation_report must include all required validation categories.
  - target phase coverage must be checked against phase_skeleton.
  - dependency validity must be checked as a DAG.
  - no_steps_generated must fail if implementation steps or task lists are present.
  - next_action.recommended_skill must be expand_stage_to_steps, expand_phase_to_stage_dag, generate_phase_skeleton, or null.
```
