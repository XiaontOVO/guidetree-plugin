```yaml
name: validate_stage_result
version: 1.0.0
type: guidetree_skill

description: >
  Validate the result of exactly one completed stage. This skill checks whether
  the executed steps and their outputs collectively satisfy the stage goal,
  required outputs, and stage acceptance criteria. It validates the stage as a
  delivery boundary, not individual steps.

body_ref: ./SKILL.md

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
    - target_phase_id
    - stage_dag
    - target_stage_id
    - steps
    - step_execution_results
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
          - acceptance_criteria
          - dependencies
          - status
        properties:
          id:
            type: string
          name:
            type: string
          goal:
            type: string
          acceptance_criteria:
            type: array
            items:
              type: string
          dependencies:
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
              - in_progress
              - blocked
              - done
              - failed
              - needs_revision
              - skipped

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

    step_execution_results:
      type: array
      items:
        type: object
        required:
          - step_id
          - stage_id
          - status
          - produced_output
        properties:
          step_id:
            type: string
          stage_id:
            type: string
          status:
            type: string
            enum:
              - completed
              - blocked
              - failed
              - skipped
              - needs_revision
          produced_output:
            type:
              - object
              - string
              - array
              - "null"
          evidence:
            type: array
            default: []
            items:
              type: object
          blockers:
            type: array
            default: []
            items:
              type: object
          notes:
            type: array
            default: []
            items:
              type: string

    validation_policy:
      type: object
      default:
        require_all_required_steps_completed: true
        allow_skipped_optional_steps: true
        require_stage_outputs_covered: true
        require_all_stage_acceptance_criteria_passed: true
        require_no_open_blockers: true
        require_non_goal_compliance: true
        require_evidence_for_stage_claims: true
      properties:
        require_all_required_steps_completed:
          type: boolean
          default: true
        allow_skipped_optional_steps:
          type: boolean
          default: true
        require_stage_outputs_covered:
          type: boolean
          default: true
        require_all_stage_acceptance_criteria_passed:
          type: boolean
          default: true
        require_no_open_blockers:
          type: boolean
          default: true
        require_non_goal_compliance:
          type: boolean
          default: true
        require_evidence_for_stage_claims:
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
    - stage_status_recommendation
    - validation_report
    - stage_output_assessment
    - acceptance_check
    - blocking_issues
    - non_blocking_warnings
    - next_action
  properties:
    skill:
      type: string
      const: validate_stage_result

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

    stage_status_recommendation:
      type: string
      enum:
        - done
        - blocked
        - failed
        - needs_revision
        - skipped

    validation_report:
      type: object
      required:
        - target_stage_found
        - phase_alignment_valid
        - required_steps_completed
        - step_outputs_usable
        - stage_goal_satisfied
        - stage_outputs_covered
        - acceptance_criteria_satisfied
        - blockers_resolved
        - non_goal_compliance_valid
      properties:
        target_stage_found:
          type: boolean
        phase_alignment_valid:
          type: boolean
        required_steps_completed:
          type: boolean
        step_outputs_usable:
          type: boolean
        stage_goal_satisfied:
          type: boolean
        stage_outputs_covered:
          type: boolean
        acceptance_criteria_satisfied:
          type: boolean
        blockers_resolved:
          type: boolean
        non_goal_compliance_valid:
          type: boolean

    stage_output_assessment:
      type: object
      required:
        - required_outputs
        - covered_outputs
        - missing_outputs
        - output_sources
      properties:
        required_outputs:
          type: array
          items:
            type: string
        covered_outputs:
          type: array
          items:
            type: string
        missing_outputs:
          type: array
          items:
            type: string
        output_sources:
          type: array
          items:
            type: object
            required:
              - stage_output
              - source_step_ids
              - evidence
            properties:
              stage_output:
                type: string
              source_step_ids:
                type: array
                items:
                  type: string
              evidence:
                type: string

    acceptance_check:
      type: array
      items:
        type: object
        required:
          - criterion
          - passed
          - evidence
          - notes
        properties:
          criterion:
            type: string
          passed:
            type: boolean
          evidence:
            type: string
          notes:
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
            description: Where the issue was found (e.g. stage id, step id, output name).
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
            description: Where the warning applies (e.g. stage id, step id, output name).
          suggestion:
            type: string

    next_action:
      type: object
      required:
        - recommended_skill
        - reason
        - suggested_target_stage_id
        - suggested_target_phase_id
      properties:
        recommended_skill:
          type: string
          enum:
            - execute_step
            - expand_stage_to_steps
            - validate_stage_result
            - validate_stage_dag
            - null
        reason:
          type: string
        suggested_target_stage_id:
          type:
            - string
            - "null"
        suggested_target_phase_id:
          type:
            - string
            - "null"
```
