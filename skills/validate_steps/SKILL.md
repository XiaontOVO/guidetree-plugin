```yaml
name: validate_steps
version: 1.0.0
type: guidetree_skill

description: >
  Validate executable steps generated for one target stage. This skill only
  validates steps, dependencies, and stage coverage. It must not generate,
  rewrite, reorder, or execute steps.

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
    - target_phase_id
    - stage_dag
    - target_stage_id
    - steps
  properties:
    project_context:
      type: object
      required:
        - project_id
        - project_name
        - project_goal
        - success_criteria
        - known_requirements
        - known_constraints
        - non_goals
        - risks
        - assumptions
        - open_questions
        - readiness
      properties:
        project_id:
          type: string
        project_name:
          type: string
        project_goal:
          type: string
        background:
          type:
            - string
            - "null"
        target_users:
          type: array
          items:
            type: object
        business_objectives:
          type: array
          items:
            type: string
        success_criteria:
          type: array
          items:
            type: string
        known_requirements:
          type: array
          items:
            type: string
        known_constraints:
          type: object
        existing_assets:
          type: array
          items:
            type: string
        non_goals:
          type: array
          items:
            type: string
        risks:
          type: array
          items:
            type: string
        assumptions:
          type: array
          items:
            type: string
        open_questions:
          type: array
          items:
            type: object
        readiness:
          type: object

    phase_skeleton:
      type: array
      items:
        type: object
        required:
          - id
          - name
          - goal
          - rationale
          - acceptance_criteria
          - inputs
          - outputs
          - dependencies
          - risks
          - status
        properties:
          id:
            type: string
          name:
            type: string
          goal:
            type: string
          rationale:
            type: string
          acceptance_criteria:
            type: array
            items:
              type: string
          inputs:
            type: array
            items:
              type: string
          outputs:
            type: array
            items:
              type: string
          dependencies:
            type: array
            items:
              type: string
          risks:
            type: array
            items:
              type: string
          status:
            type: string

    target_phase_id:
      type: string

    stage_dag:
      type: array
      items:
        type: object
        required:
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
        properties:
          id:
            type: string
          phase_id:
            type: string
          name:
            type: string
          goal:
            type: string
          rationale:
            type: string
          acceptance_criteria:
            type: array
            items:
              type: string
          inputs:
            type: array
            items:
              type: string
          outputs:
            type: array
            items:
              type: string
          dependencies:
            type: array
            items:
              type: string
          risks:
            type: array
            items:
              type: string
          status:
            type: string

    target_stage_id:
      type: string

    steps:
      type: array
      items:
        type: object
        required:
          - id
          - stage_id
          - name
          - objective
          - action
          - expected_output
          - acceptance_criteria
          - inputs
          - dependencies
          - risks
          - status
        properties:
          id:
            type: string
          stage_id:
            type: string
          name:
            type: string
          objective:
            type: string
          action:
            type: string
          expected_output:
            type: string
          acceptance_criteria:
            type: array
            items:
              type: string
          inputs:
            type: array
            items:
              type: string
          dependencies:
            type: array
            items:
              type: string
          risks:
            type: array
            items:
              type: string
          owner_role:
            type:
              - string
              - "null"
          effort_estimate:
            type:
              - string
              - "null"
          status:
            type: string
            enum:
              - not_started
              - ready
              - blocked
              - in_progress
              - done
              - skipped
              - failed
              - needs_revision

    step_dependency_edges:
      type: array
      default: []
      items:
        type: array
        minItems: 2
        maxItems: 2
        items:
          type: string

    stage_coverage:
      type: object
      default: {}
      properties:
        stage_goal_covered:
          type: boolean
        stage_outputs_covered:
          type: array
          items:
            type: object
        stage_acceptance_criteria_covered:
          type: array
          items:
            type: object
        coverage_notes:
          type: array
          items:
            type: string

    validation_policy:
      type: object
      default:
        min_steps: 4
        max_steps: 15
        require_step_dependencies: true
        require_stage_coverage: true
        require_verifiable_acceptance_criteria: true
        require_executable_actions: true
        strict_single_stage_only: true
      properties:
        min_steps:
          type: integer
          minimum: 1
          maximum: 30
          default: 4

        max_steps:
          type: integer
          minimum: 1
          maximum: 30
          default: 15

        require_step_dependencies:
          type: boolean
          default: true

        require_stage_coverage:
          type: boolean
          default: true

        require_verifiable_acceptance_criteria:
          type: boolean
          default: true

        require_executable_actions:
          type: boolean
          default: true

        strict_single_stage_only:
          type: boolean
          default: true

  additionalProperties: false

output_schema:
  type: object
  required:
    - skill
    - version
    - summary
    - project_id
    - phase_id
    - stage_id
    - valid
    - validation_report
    - blocking_issues
    - non_blocking_warnings
    - repair_suggestions
    - next_action
  properties:
    skill:
      type: string
      const: validate_steps

    version:
      type: string

    summary:
      type: string

    project_id:
      type: string

    phase_id:
      type: string

    stage_id:
      type: string

    valid:
      type: boolean

    validation_report:
      type: object
      required:
        - target_stage_valid
        - step_count_valid
        - step_schema_valid
        - step_scope_valid
        - dependency_valid
        - acceptance_criteria_valid
        - action_valid
        - input_output_valid
        - stage_coverage_valid
        - risk_alignment_valid
        - non_goal_compliance_valid
      properties:
        target_stage_valid:
          type: object
          required:
            - passed
            - message
          properties:
            passed:
              type: boolean
            message:
              type: string

        step_count_valid:
          type: object
          required:
            - passed
            - actual_count
            - expected_min
            - expected_max
            - message
          properties:
            passed:
              type: boolean
            actual_count:
              type: integer
            expected_min:
              type: integer
            expected_max:
              type: integer
            message:
              type: string

        step_schema_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - field
                  - issue
                  - severity
                properties:
                  step_id:
                    type:
                      - string
                      - "null"
                  field:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        step_scope_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - issue
                  - severity
                properties:
                  step_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        dependency_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - issue
                  - severity
                properties:
                  step_id:
                    type:
                      - string
                      - "null"
                  dependency:
                    type:
                      - string
                      - "null"
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        acceptance_criteria_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - criterion
                  - issue
                  - severity
                properties:
                  step_id:
                    type: string
                  criterion:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        action_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - action
                  - issue
                  - severity
                properties:
                  step_id:
                    type: string
                  action:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        input_output_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - issue
                  - severity
                properties:
                  step_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        stage_coverage_valid:
          type: object
          required:
            - passed
            - missing_stage_outputs
            - missing_stage_acceptance_criteria
            - message
          properties:
            passed:
              type: boolean
            missing_stage_outputs:
              type: array
              items:
                type: string
            missing_stage_acceptance_criteria:
              type: array
              items:
                type: string
            message:
              type: string

        risk_alignment_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - issue
                  - severity
                properties:
                  step_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        non_goal_compliance_valid:
          type: object
          required:
            - passed
            - issues
          properties:
            passed:
              type: boolean
            issues:
              type: array
              items:
                type: object
                required:
                  - step_id
                  - issue
                  - severity
                properties:
                  step_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

    blocking_issues:
      type: array
      items:
        type: object
        required:
          - id
          - issue
          - location
          - reason
          - required_fix
        properties:
          id:
            type: string
          issue:
            type: string
          location:
            type: string
          reason:
            type: string
          required_fix:
            type: string

    non_blocking_warnings:
      type: array
      items:
        type: object
        required:
          - id
          - warning
          - location
          - suggestion
        properties:
          id:
            type: string
          warning:
            type: string
          location:
            type: string
          suggestion:
            type: string

    repair_suggestions:
      type: array
      items:
        type: object
        required:
          - target
          - action
          - rationale
        properties:
          target:
            type: string
          action:
            type: string
          rationale:
            type: string

    next_action:
      type: object
      required:
        - recommended_skill
        - reason
        - suggested_target_step_id
      properties:
        recommended_skill:
          type: string
          enum:
            - execute_step
            - expand_stage_to_steps
            - expand_phase_to_stage_dag
            - null

        reason:
          type: string

        suggested_target_step_id:
          type:
            - string
            - "null"

instructions: |
  You are the GuideTree validate_steps skill.

  Your only responsibility is to validate executable steps generated for one target stage.

  You must:
  1. Confirm target_stage_id exists in stage_dag.
  2. Confirm target stage belongs to target_phase_id.
  3. Confirm every step belongs to target_stage_id.
  4. Check step count against validation_policy.min_steps and validation_policy.max_steps.
  5. Check every step has required fields:
     - id
     - stage_id
     - name
     - objective
     - action
     - expected_output
     - acceptance_criteria
     - inputs
     - dependencies
     - risks
     - status
  6. Check step ids are unique and stable.
  7. Check every step has a concrete executable action.
  8. Check every step has a concrete expected_output.
  9. Check every step has at least one verifiable acceptance criterion.
  10. Check step dependencies reference existing step ids in the same step set.
  11. Check step dependencies form a DAG.
  12. Check step_dependency_edges are consistent with step.dependencies.
  13. Check steps are execution-level units, not stages and not micro-actions.
  14. Check steps collectively cover the target stage goal, outputs, and acceptance criteria.
  15. Check steps do not include work listed in project_context.non_goals.
  16. Check risks are reflected at relevant steps or reported as warnings.
  17. Check owner_role and effort_estimate are present only when allowed or explicitly provided.
  18. Produce blocking_issues for defects that prevent safe execution packaging.
  19. Produce non_blocking_warnings for issues that can be deferred.
  20. Recommend exactly one next skill.

  You must not:
  1. Generate new steps.
  2. Rewrite steps.
  3. Reorder steps.
  4. Execute steps.
  5. Generate stages.
  6. Generate phases.
  7. Create implementation details beyond validation.
  8. Silently repair dependencies.
  9. Ignore vague actions or unverifiable acceptance criteria.
  10. Treat assumptions as facts.

validation_rules: |
  The steps are valid only if:
  1. target_stage_id exists in stage_dag.
  2. target stage belongs to target_phase_id.
  3. every step.stage_id equals target_stage_id.
  4. step count is within the configured range.
  5. every step has all required fields.
  6. every step has one concrete executable action.
  7. every step has one concrete expected_output.
  8. every step has at least one verifiable acceptance criterion.
  9. every dependency references an existing step id in the same step set.
  10. step dependencies are acyclic.
  11. step_dependency_edges match step.dependencies when provided.
  12. steps collectively cover the target stage goal, outputs, and acceptance criteria.
  13. steps are execution-level units, not stages and not micro-actions.
  14. steps do not contradict project_context.non_goals.
  15. owner_role and effort_estimate are not invented without permission.

  If any blocking issue exists, set valid to false.

  If only non-blocking warnings exist, set valid to true.

blocking_issue_rules: |
  Mark an issue as blocking if it prevents safe execution packaging.

  Blocking examples:
  - target_stage_id does not exist.
  - target stage belongs to a different phase_id.
  - steps array is empty while target stage is valid and expandable.
  - step count is outside allowed range.
  - duplicate step ids.
  - a step belongs to a different stage_id.
  - dependency references unknown step id.
  - dependency cycle exists.
  - step_dependency_edges contradict step.dependencies.
  - any step lacks action.
  - any step has vague or non-executable action.
  - any step lacks expected_output.
  - any step lacks acceptance criteria.
  - acceptance criteria are unverifiable.
  - steps do not cover the target stage goal.
  - a target stage output is not covered by any step.
  - a target stage acceptance criterion is not covered by any step.
  - steps contain stage-like or phase-like items.
  - steps are only micro-actions instead of meaningful execution units.
  - steps require work explicitly listed in project_context.non_goals.
  - owner_role or effort_estimate is invented without permission.

warning_rules: |
  Mark an issue as warning if the step set can still be packaged safely.

  Warning examples:
  - step name could be clearer but action is concrete.
  - step risks are incomplete.
  - inputs are broad but usable.
  - a dependency may be unnecessary but does not break the DAG.
  - an expected_output is verifiable but could be more specific.
  - a known project risk is only indirectly addressed.
  - an open question may affect execution but does not block packaging.

step_scope_rules: |
  A valid step is:
  1. Executable by a person or agent.
  2. Atomic enough to verify.
  3. Larger than a trivial keystroke or micro-action.
  4. Smaller than a stage.
  5. Focused on one primary outcome.
  6. Suitable for conversion into an execution checklist, ticket, or agent task.

  Invalid vague step examples:
  - "do research"
  - "improve system"
  - "optimize performance"
  - "handle edge cases"
  - "write code"
  - "test everything"
  - "finish implementation"

  Invalid micro-action examples:
  - "open editor"
  - "click save"
  - "create file"
  - "type command"
  - "rename variable"

  Invalid stage-like examples:
  - "complete full design"
  - "build prototype"
  - "run validation phase"
  - "deliver release package"

action_rules: |
  A valid action must:
  1. Use a concrete verb.
  2. Identify the object being acted on.
  3. Indicate the intended result or completion evidence.
  4. Avoid vague verbs unless paired with concrete scope and evidence.

  Weak verbs that require concrete scope:
  - improve
  - optimize
  - handle
  - process
  - manage
  - support
  - enhance
  - refine
  - update
  - review
  - analyze
  - research
  - design
  - test
  - implement

  Examples of valid actions:
  - "Document each target user scenario in a table containing actor, trigger, input, expected outcome, priority, and source."
  - "Review the requirements artifact against the approved success criteria and record pass/fail evidence for each criterion."
  - "Package the approved outputs, unresolved questions, assumptions, and downstream dependencies into a handoff bundle."

acceptance_criteria_rules: |
  Acceptance criteria must be verifiable by inspection, review, test, approval,
  or measurable evidence.

  Invalid vague phrases include:
  - good experience
  - better performance
  - high quality
  - works well
  - reasonable result
  - optimized
  - improved
  - user friendly
  - 效果好
  - 体验好
  - 体验不错
  - 高质量
  - 性能好
  - 合理
  - 优化
  - 完善

  These phrases are allowed only when paired with concrete evidence, threshold,
  artifact, metric, approval condition, or observable behavior.

dependency_rules: |
  Validate dependencies by:
  1. Building a graph from step.dependencies.
  2. Verifying every dependency id exists in steps.
  3. Verifying every dependency belongs to target_stage_id.
  4. Checking for cycles.
  5. Comparing derived edges with step_dependency_edges if provided.
  6. Reporting isolated steps as warnings unless they are intentionally independent.

stage_coverage_rules: |
  Validate stage coverage by:
  1. Locating the target stage in stage_dag.
  2. Comparing target stage outputs against all step expected_output values.
  3. Comparing target stage acceptance criteria against all step acceptance criteria.
  4. Using stage_coverage if provided, but not trusting it blindly.
  5. Reporting uncovered stage outputs or acceptance criteria as blocking issues.

next_action_rules: |
  If valid is true:
  - recommended_skill must be execute_step.
  - suggested_target_step_id should be the first step with no dependencies, or the earliest step whose dependencies are satisfied by design.

  If valid is false due to repairable step issues:
  - recommended_skill must be expand_stage_to_steps.
  - suggested_target_step_id should be null unless the issue is isolated to one step.

  If valid is false because the target stage is invalid or missing:
  - recommended_skill must be expand_phase_to_stage_dag.
  - suggested_target_step_id must be null.

  If valid is false because project context is insufficient:
  - recommended_skill must be null.
  - suggested_target_step_id must be null.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - output must only validate steps.
  - output must not generate new steps.
  - output must not rewrite steps.
  - output must not reorder steps.
  - output must not create stages.
  - output must not create phases.
  - valid must be false if any blocking issue exists.
  - every blocking issue must include a required_fix.
  - every warning must include a suggestion.
  - validation_report must include all required validation categories.
  - target stage coverage must be checked against stage_dag.
  - dependency validity must be checked as a DAG.
  - owner_role and effort_estimate misuse must be detected.
  - next_action.recommended_skill must be execute_step, expand_stage_to_steps, expand_phase_to_stage_dag, or null.
```