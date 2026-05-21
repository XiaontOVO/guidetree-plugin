```yaml
name: execute_step
version: 1.0.0
type: guidetree_skill

description: >
  Execute exactly one validated step. This skill performs the concrete action
  described by the target step, produces the expected output, records execution
  evidence, and reports completion status. It must not create new phases,
  stages, or steps.

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
    - target_step_id
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

    target_step_id:
      type: string

    completed_dependency_step_ids:
      type: array
      default: []
      items:
        type: string

    execution_context:
      type: object
      default: {}
      properties:
        available_inputs:
          type: array
          items:
            type: string
        available_artifacts:
          type: array
          items:
            type: object
        environment:
          type: object
        operator_notes:
          type: array
          items:
            type: string

    execution_policy:
      type: object
      default:
        require_dependencies_done: true
        require_inputs_available: true
        allow_assumption_based_execution: false
        stop_on_open_blocker: true
        require_evidence: true
        mark_done_only_if_acceptance_passes: true
      properties:
        require_dependencies_done:
          type: boolean
          default: true
        require_inputs_available:
          type: boolean
          default: true
        allow_assumption_based_execution:
          type: boolean
          default: false
        stop_on_open_blocker:
          type: boolean
          default: true
        require_evidence:
          type: boolean
          default: true
        mark_done_only_if_acceptance_passes:
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
    - step_id
    - execution_status
    - execution_result
    - produced_output
    - evidence
    - acceptance_check
    - blockers
    - state_update
    - next_action
  properties:
    skill:
      type: string
      const: execute_step

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

    step_id:
      type: string

    execution_status:
      type: string
      enum:
        - completed
        - blocked
        - failed
        - skipped
        - needs_revision

    execution_result:
      type: object
      required:
        - target_step_found
        - target_step_ready
        - dependencies_satisfied
        - inputs_available
        - action_executed
        - output_generated
      properties:
        target_step_found:
          type: boolean
        target_step_ready:
          type: boolean
        dependencies_satisfied:
          type: boolean
        inputs_available:
          type: boolean
        action_executed:
          type: boolean
        output_generated:
          type: boolean
        notes:
          type: array
          items:
            type: string

    produced_output:
      type: object
      required:
        - description
        - content
        - output_type
      properties:
        description:
          type: string
        content:
          type:
            - string
            - object
            - array
            - "null"
        output_type:
          type: string
          enum:
            - artifact
            - analysis
            - decision
            - code
            - document
            - configuration
            - test_result
            - review_result
            - other

    evidence:
      type: array
      items:
        type: object
        required:
          - evidence_type
          - description
          - reference
        properties:
          evidence_type:
            type: string
            enum:
              - produced_output
              - inspection_note
              - test_result
              - review_note
              - decision_record
              - artifact_reference
              - other
          description:
            type: string
          reference:
            type:
              - string
              - "null"

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

    blockers:
      type: array
      items:
        type: object
        required:
          - id
          - blocker
          - reason
          - required_resolution
          - severity
        properties:
          id:
            type: string
          blocker:
            type: string
          reason:
            type: string
          required_resolution:
            type: string
          severity:
            type: string
            enum:
              - critical
              - high
              - medium
              - low

    state_update:
      type: object
      required:
        - previous_step_status
        - new_step_status
        - completed_step_ids
        - newly_available_step_ids
      properties:
        previous_step_status:
          type: string
        new_step_status:
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
        completed_step_ids:
          type: array
          items:
            type: string
        newly_available_step_ids:
          type: array
          items:
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
            - validate_stage_result
            - expand_stage_to_steps
            - null
        reason:
          type: string
        suggested_target_step_id:
          type:
            - string
            - "null"
```
