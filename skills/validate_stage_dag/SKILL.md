```yaml
name: validate_stage_dag
version: 1.0.0
type: guidetree_skill

description: >
  Validate a stage-level DAG generated for one target phase. This skill only
  validates stages, dependencies, and phase coverage. It must not generate steps,
  rewrite stages, or expand the plan.

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
    - target_phase_id
    - stage_dag
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
            enum:
              - not_started
              - ready
              - blocked
              - in_progress
              - done
              - skipped
              - failed
              - needs_revision

    stage_dependency_edges:
      type: array
      default: []
      items:
        type: array
        minItems: 2
        maxItems: 2
        items:
          type: string

    phase_coverage:
      type: object
      default: {}
      properties:
        phase_goal_covered:
          type: boolean
        phase_outputs_covered:
          type: array
          items:
            type: object
        phase_acceptance_criteria_covered:
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
        min_stages: 3
        max_stages: 9
        require_stage_dag: true
        require_phase_coverage: true
        require_verifiable_acceptance_criteria: true
        strict_no_steps: true
        allow_empty_stage_dag_when_blocked: true
      properties:
        min_stages:
          type: integer
          minimum: 2
          maximum: 15
          default: 3

        max_stages:
          type: integer
          minimum: 2
          maximum: 15
          default: 9

        require_stage_dag:
          type: boolean
          default: true

        require_phase_coverage:
          type: boolean
          default: true

        require_verifiable_acceptance_criteria:
          type: boolean
          default: true

        strict_no_steps:
          type: boolean
          default: true

        allow_empty_stage_dag_when_blocked:
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
    - valid
    - validation_report
    - blocking_issues
    - non_blocking_warnings
    - repair_suggestions
    - next_action
  properties:
    skill:
      type: string
      const: validate_stage_dag

    version:
      type: string

    summary:
      type: string

    project_id:
      type: string

    phase_id:
      type: string

    valid:
      type: boolean

    validation_report:
      type: object
      required:
        - target_phase_valid
        - stage_count_valid
        - stage_schema_valid
        - stage_scope_valid
        - dependency_valid
        - acceptance_criteria_valid
        - input_output_valid
        - phase_coverage_valid
        - risk_alignment_valid
        - non_goal_compliance_valid
        - no_steps_generated
      properties:
        target_phase_valid:
          type: object
          required:
            - passed
            - message
          properties:
            passed:
              type: boolean
            message:
              type: string

        stage_count_valid:
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

        stage_schema_valid:
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
                  - stage_id
                  - field
                  - issue
                  - severity
                properties:
                  stage_id:
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

        stage_scope_valid:
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
                  - stage_id
                  - issue
                  - severity
                properties:
                  stage_id:
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
                  stage_id:
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
                  - stage_id
                  - criterion
                  - issue
                  - severity
                properties:
                  stage_id:
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
                  - stage_id
                  - issue
                  - severity
                properties:
                  stage_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        phase_coverage_valid:
          type: object
          required:
            - passed
            - missing_phase_outputs
            - missing_phase_acceptance_criteria
            - message
          properties:
            passed:
              type: boolean
            missing_phase_outputs:
              type: array
              items:
                type: string
            missing_phase_acceptance_criteria:
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
                  - stage_id
                  - issue
                  - severity
                properties:
                  stage_id:
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
                  - stage_id
                  - issue
                  - severity
                properties:
                  stage_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        no_steps_generated:
          type: object
          required:
            - passed
            - message
          properties:
            passed:
              type: boolean
            message:
              type: string

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
        - suggested_target_stage_id
      properties:
        recommended_skill:
          type: string
          enum:
            - expand_stage_to_steps
            - expand_phase_to_stage_dag
            - generate_phase_skeleton
            - null

        reason:
          type: string

        suggested_target_stage_id:
          type:
            - string
            - "null"

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

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

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