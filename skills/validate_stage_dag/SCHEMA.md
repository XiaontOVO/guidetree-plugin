```yaml
name: validate_stage_dag
version: 1.0.0
type: guidetree_skill

description: >
  Validate a stage-level DAG generated for one target phase. This skill only
  validates stages, dependencies, and phase coverage. It must not generate steps,
  rewrite stages, or expand the plan.

body_ref: ./SKILL.md

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
```
