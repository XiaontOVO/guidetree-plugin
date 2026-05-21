```yaml
name: orchestrate_project
version: 1.0.0
type: guidetree_skill

description: >
  Orchestrate the full GuideTree project workflow by selecting and invoking the
  correct next skill until the project reaches a terminal state. This skill does
  not perform project work directly. It controls sequencing, enforces workflow
  rules, prevents invalid transitions, and delegates work to the appropriate
  GuideTree skill.

body_ref: ./SKILL.md

input_schema:
  type: object
  required:
    - project_state
    - available_skills
  properties:
    project_state:
      type: object
      required:
        - project_id
        - status
        - artifacts
        - current_position
        - execution_history
      properties:
        project_id:
          type: string

        status:
          type: string
          enum:
            - initialized
            - planning
            - validating_plan
            - expanding
            - validating_structure
            - executing
            - validating_stage
            - validating_phase
            - validating_project
            - blocked
            - needs_revision
            - failed
            - completed

        artifacts:
          type: object
          properties:
            project_context:
              type:
                - object
                - "null"
            phase_skeleton:
              type:
                - array
                - "null"
            stage_dag:
              type:
                - array
                - "null"
            steps:
              type:
                - array
                - "null"
            step_execution_results:
              type:
                - array
                - "null"
            stage_validation_results:
              type:
                - array
                - "null"
            phase_validation_results:
              type:
                - array
                - "null"
            project_validation_result:
              type:
                - object
                - "null"

        current_position:
          type: object
          required:
            - phase_id
            - stage_id
            - step_id
          properties:
            phase_id:
              type:
                - string
                - "null"
            stage_id:
              type:
                - string
                - "null"
            step_id:
              type:
                - string
                - "null"

        execution_history:
          type: array
          items:
            type: object
            required:
              - skill
              - status
              - timestamp
            properties:
              skill:
                type: string
              status:
                type: string
              timestamp:
                type: string
              summary:
                type:
                  - string
                  - "null"
              output_ref:
                type:
                  - string
                  - "null"

        blockers:
          type: array
          default: []
          items:
            type: object

        operator_notes:
          type: array
          default: []
          items:
            type: string

    available_skills:
      type: array
      items:
        type: string
      default:
        - create_project_context
        - generate_phase_skeleton
        - validate_phase_skeleton
        - expand_phase_to_stage_dag
        - validate_stage_dag
        - expand_stage_to_steps
        - validate_steps
        - execute_step
        - validate_stage_result

    orchestration_policy:
      type: object
      default:
        auto_continue: true
        stop_on_blocker: true
        stop_on_failed_validation: true
        require_validation_before_execution: true
        require_stage_validation_before_next_stage: true
        require_phase_validation_before_next_phase: true
        max_skill_calls_per_run: 1
        allow_parallel_stage_execution: false
        allow_parallel_step_execution: false
      properties:
        auto_continue:
          type: boolean
          default: true
        stop_on_blocker:
          type: boolean
          default: true
        stop_on_failed_validation:
          type: boolean
          default: true
        require_validation_before_execution:
          type: boolean
          default: true
        require_stage_validation_before_next_stage:
          type: boolean
          default: true
        require_phase_validation_before_next_phase:
          type: boolean
          default: true
        max_skill_calls_per_run:
          type: integer
          default: 1
          minimum: 1
        allow_parallel_stage_execution:
          type: boolean
          default: false
        allow_parallel_step_execution:
          type: boolean
          default: false

  additionalProperties: false

output_schema:
  type: object
  required:
    - skill
    - version
    - project_id
    - orchestration_status
    - decision
    - selected_skill
    - selected_skill_input
    - state_assessment
    - transition_reason
    - blockers
    - next_orchestration_hint
  properties:
    skill:
      type: string
      const: orchestrate_project

    version:
      type: string

    project_id:
      type: string

    orchestration_status:
      type: string
      enum:
        - selected_next_skill
        - blocked
        - completed
        - failed
        - needs_operator_input

    decision:
      type: string
      enum:
        - invoke_skill
        - stop_for_blocker
        - stop_completed
        - stop_failed
        - request_clarification

    selected_skill:
      type:
        - string
        - "null"
      enum:
        - create_project_context
        - generate_phase_skeleton
        - validate_phase_skeleton
        - expand_phase_to_stage_dag
        - validate_stage_dag
        - expand_stage_to_steps
        - validate_steps
        - execute_step
        - validate_stage_result
        - null

    selected_skill_input:
      type:
        - object
        - "null"

    state_assessment:
      type: object
      required:
        - has_project_context
        - has_phase_skeleton
        - phase_skeleton_valid
        - has_stage_dag
        - stage_dag_valid
        - has_steps
        - steps_valid
        - executable_step_available
        - current_stage_ready_for_validation
        - current_phase_ready_for_validation
        - project_ready_for_validation
        - open_blockers_exist
      properties:
        has_project_context:
          type: boolean
        has_phase_skeleton:
          type: boolean
        phase_skeleton_valid:
          type: boolean
        has_stage_dag:
          type: boolean
        stage_dag_valid:
          type: boolean
        has_steps:
          type: boolean
        steps_valid:
          type: boolean
        executable_step_available:
          type: boolean
        current_stage_ready_for_validation:
          type: boolean
        current_phase_ready_for_validation:
          type: boolean
        project_ready_for_validation:
          type: boolean
        open_blockers_exist:
          type: boolean

    transition_reason:
      type: string

    blockers:
      type: array
      items:
        type: object
        required:
          - id
          - blocker
          - required_resolution
        properties:
          id:
            type: string
          blocker:
            type: string
          required_resolution:
            type: string

    next_orchestration_hint:
      type: object
      required:
        - should_continue_after_selected_skill
        - expected_next_state
        - notes
      properties:
        should_continue_after_selected_skill:
          type: boolean
        expected_next_state:
          type: string
        notes:
          type: array
          items:
            type: string
```
