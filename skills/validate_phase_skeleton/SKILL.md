```yaml
name: validate_phase_skeleton
version: 1.0.0
type: guidetree_skill

description: >
  Validate a generated phase skeleton against the project context and phase design rules.
  This skill only validates phases and reports issues. It must not generate stages,
  steps, or expand the project plan.

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
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
          required:
            - ready_for_phase_planning
            - confidence
            - reason
          properties:
            ready_for_phase_planning:
              type: boolean
            confidence:
              type: number
              minimum: 0
              maximum: 1
            reason:
              type: string

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
            enum:
              - not_started
              - ready
              - blocked
              - in_progress
              - done
              - skipped
              - failed
              - needs_revision

    phase_dependency_edges:
      type: array
      default: []
      items:
        type: array
        minItems: 2
        maxItems: 2
        items:
          type: string

    validation_policy:
      type: object
      default:
        min_phases: 5
        max_phases: 9
        require_lifecycle_coverage: true
        require_verifiable_acceptance_criteria: true
        require_dependency_dag: true
        allow_empty_phase_skeleton_when_not_ready: true
        strict_no_stage_or_step: true
      properties:
        min_phases:
          type: integer
          minimum: 3
          maximum: 12
          default: 5

        max_phases:
          type: integer
          minimum: 3
          maximum: 12
          default: 9

        require_lifecycle_coverage:
          type: boolean
          default: true

        require_verifiable_acceptance_criteria:
          type: boolean
          default: true

        require_dependency_dag:
          type: boolean
          default: true

        allow_empty_phase_skeleton_when_not_ready:
          type: boolean
          default: true

        strict_no_stage_or_step:
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
    - valid
    - validation_report
    - blocking_issues
    - non_blocking_warnings
    - repair_suggestions
    - next_action
  properties:
    skill:
      type: string
      const: validate_phase_skeleton

    version:
      type: string

    summary:
      type: string

    project_id:
      type: string

    valid:
      type: boolean

    validation_report:
      type: object
      required:
        - readiness_valid
        - phase_count_valid
        - phase_schema_valid
        - lifecycle_coverage_valid
        - dependency_valid
        - acceptance_criteria_valid
        - input_output_valid
        - risk_alignment_valid
        - non_goal_compliance_valid
        - no_stage_or_step_generated
      properties:
        readiness_valid:
          type: object
          required:
            - passed
            - message
          properties:
            passed:
              type: boolean
            message:
              type: string

        phase_count_valid:
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

        phase_schema_valid:
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
                  - phase_id
                  - field
                  - issue
                  - severity
                properties:
                  phase_id:
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

        lifecycle_coverage_valid:
          type: object
          required:
            - passed
            - covered_concerns
            - missing_concerns
            - message
          properties:
            passed:
              type: boolean
            covered_concerns:
              type: array
              items:
                type: string
            missing_concerns:
              type: array
              items:
                type: string
            message:
              type: string

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
                  phase_id:
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
                  - phase_id
                  - criterion
                  - issue
                  - severity
                properties:
                  phase_id:
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
                  - phase_id
                  - issue
                  - severity
                properties:
                  phase_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

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
                  - phase_id
                  - issue
                  - severity
                properties:
                  phase_id:
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
                  - phase_id
                  - issue
                  - severity
                properties:
                  phase_id:
                    type: string
                  issue:
                    type: string
                  severity:
                    type: string
                    enum:
                      - blocking
                      - warning

        no_stage_or_step_generated:
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
        - suggested_target_phase_id
      properties:
        recommended_skill:
          type: string
          enum:
            - expand_phase_to_stage_dag
            - generate_phase_skeleton
            - null

        reason:
          type: string

        suggested_target_phase_id:
          type:
            - string
            - "null"

instructions: |
  You are the GuideTree validate_phase_skeleton skill.

  Your only responsibility is to validate a generated phase skeleton.

  You must:
  1. Check whether project_context is ready for phase planning.
  2. Check whether phase_skeleton exists when project_context is ready.
  3. Check whether phase count is within validation_policy.min_phases and validation_policy.max_phases.
  4. Check every phase has required fields:
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
  5. Check phase ids are unique and stable.
  6. Check phase dependencies reference existing phase ids.
  7. Check phase dependencies form a DAG when validation_policy.require_dependency_dag is true.
  8. Check phase_dependency_edges are consistent with phase.dependencies.
  9. Check each phase has at least one output.
  10. Check each phase has at least one verifiable acceptance criterion.
  11. Check phases collectively cover the lifecycle needed to achieve project_context.project_goal.
  12. Check known_requirements and success_criteria are addressed by at least one phase.
  13. Check non_goals are not included as required project work.
  14. Check major project risks are reflected in relevant phase risks or validation warnings.
  15. Check that no stages or steps were generated.
  16. Produce blocking_issues for defects that prevent safe continuation.
  17. Produce non_blocking_warnings for issues that can be deferred.
  18. Recommend exactly one next skill.

  You must not:
  1. Generate new phases.
  2. Rewrite the phase skeleton.
  3. Generate stages.
  4. Generate steps.
  5. Expand any phase.
  6. Create a detailed project plan.
  7. Silently fix invalid dependencies.
  8. Ignore vague acceptance criteria.
  9. Ignore missing outputs.
  10. Treat assumptions as facts.

validation_rules: |
  The phase skeleton is valid only if:
  1. project_context.readiness.ready_for_phase_planning is true.
  2. phase_skeleton is not empty.
  3. phase count is within the configured range.
  4. every phase has all required fields.
  5. every phase has at least one output.
  6. every phase has at least one verifiable acceptance criterion.
  7. all dependency references point to existing phase ids.
  8. phase dependencies are acyclic.
  9. phase_dependency_edges match phase.dependencies when provided.
  10. the skeleton covers the project lifecycle at phase level.
  11. the skeleton does not contain stages or steps.
  12. the skeleton does not require work explicitly listed in project_context.non_goals.

  If any blocking issue exists, set valid to false.

  If only non-blocking warnings exist, set valid to true.

blocking_issue_rules: |
  Mark an issue as blocking if it prevents safe downstream expansion.

  Blocking examples:
  - project_context is not ready for phase planning.
  - phase_skeleton is empty while project_context is ready.
  - phase count is outside allowed range.
  - duplicate phase ids.
  - dependency references unknown phase ids.
  - dependency cycle exists.
  - any phase lacks outputs.
  - any phase lacks acceptance criteria.
  - phases contain stages or steps.
  - phase skeleton contradicts non_goals.
  - core project goal is not covered by any phase.
  - required success criteria are not addressed by any phase.

warning_rules: |
  Mark an issue as warning if the skeleton can still be expanded safely.

  Warning examples:
  - phase rationale is weak but understandable.
  - phase risks are incomplete.
  - acceptance criteria are verifiable but not very specific.
  - a known requirement is only indirectly covered.
  - an open question may affect later stage planning.
  - a phase name could be clearer but is not ambiguous.

acceptance_criteria_rules: |
  Acceptance criteria are valid only if a third party can judge whether they are satisfied.

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

  These phrases are allowed only when they include a concrete object, metric,
  threshold, evidence, or observable completion condition.

dependency_rules: |
  Validate dependencies by:
  1. Building a graph from phase.dependencies.
  2. Verifying each dependency id exists.
  3. Checking for cycles.
  4. Comparing derived edges with phase_dependency_edges if phase_dependency_edges is provided.
  5. Reporting isolated phases as warnings unless they are intentionally independent.

next_action_rules: |
  If valid is true:
  - recommended_skill must be expand_phase_to_stage_dag.
  - suggested_target_phase_id should be the first phase with no dependencies, or the earliest phase whose dependencies are satisfied by design.

  If valid is false due to repairable skeleton issues:
  - recommended_skill must be generate_phase_skeleton.
  - suggested_target_phase_id should be null unless the issue is isolated to one phase.

  If valid is false because project_context is not ready:
  - recommended_skill must be null.
  - suggested_target_phase_id must be null.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - output must only validate the phase skeleton.
  - output must not contain generated stages.
  - output must not contain generated steps.
  - output must not rewrite phase_skeleton.
  - valid must be false if any blocking issue exists.
  - blocking_issues must be actionable.
  - non_blocking_warnings must be specific.
  - repair_suggestions must not include full regenerated phases.
  - validation_report must include all required validation categories.
  - next_action.recommended_skill must be expand_phase_to_stage_dag, generate_phase_skeleton, or null.
```