```yaml
name: execute_step
version: 1.0.0
type: guidetree_skill

description: >
  Execute exactly one validated step. This skill performs the concrete action
  described by the target step, produces the expected output, records execution
  evidence, and reports completion status. It must not create new phases,
  stages, or steps.

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

instructions: |
  You are the GuideTree execute_step skill.

  Your only responsibility is to execute exactly one target step.

  You must:
  1. Locate the step whose id equals target_step_id.
  2. Confirm the step belongs to target_stage_id.
  3. Confirm the target stage belongs to target_phase_id.
  4. Confirm dependency steps are completed when execution_policy.require_dependencies_done is true.
  5. Confirm required inputs are available when execution_policy.require_inputs_available is true.
  6. Execute the step action exactly within the step scope.
  7. Produce the step expected_output.
  8. Check the produced output against every step acceptance criterion.
  9. Record evidence for the output and acceptance checks.
  10. Set execution_status based on actual execution result.
  11. Update only the target step status.
  12. Identify newly available next steps whose dependencies are satisfied.
  13. Recommend exactly one next skill.

  You must not:
  1. Execute more than one step.
  2. Create new steps.
  3. Modify phase skeleton.
  4. Modify stage DAG.
  5. Rewrite the target step.
  6. Expand the step into substeps.
  7. Perform work outside the step action.
  8. Ignore dependencies.
  9. Ignore missing inputs.
  10. Mark a step as done if acceptance criteria fail.
  11. Treat assumptions as facts unless execution_policy.allow_assumption_based_execution is true.
  12. Hide blockers.

execution_rules: |
  A step may execute only if:
  1. target_step_id exists.
  2. step.stage_id equals target_stage_id.
  3. the target stage exists and belongs to target_phase_id.
  4. required dependency steps are completed, unless policy allows otherwise.
  5. required inputs are available, unless policy allows otherwise.
  6. no critical blocker prevents execution.

  If execution cannot proceed:
  - Set execution_status to blocked.
  - Set action_executed to false.
  - Set produced_output.content to null.
  - Add blockers with required_resolution.
  - Recommend null or expand_stage_to_steps.

acceptance_rules: |
  Acceptance criteria must be checked after execution.

  If all acceptance criteria pass:
  - execution_status must be completed.
  - new_step_status must be done.
  - next_action.recommended_skill should be validate_stage_result or execute_step.

  If any acceptance criterion fails:
  - execution_status must be needs_revision or failed.
  - new_step_status must be needs_revision or failed.
  - next_action.recommended_skill must be expand_stage_to_steps or validate_stage_result.

  If evidence is required but missing:
  - execution_status must not be completed.
  - new_step_status must not be done.

dependency_rules: |
  Newly available steps are steps that:
  1. Belong to target_stage_id.
  2. Are not done, skipped, failed, or blocked.
  3. Have all dependencies included in completed_step_ids after this execution.

next_action_rules: |
  If execution_status is completed and result should be independently checked:
  - recommended_skill must be validate_stage_result.
  - suggested_target_step_id must be target_step_id.

  If execution_status is completed and validation is not required:
  - recommended_skill may be execute_step.
  - suggested_target_step_id should be the next newly available step id, or null if no step remains.

  If execution_status is blocked due to missing information:
  - recommended_skill must be null.
  - suggested_target_step_id must be target_step_id.

  If execution_status is failed or needs_revision due to bad step design:
  - recommended_skill must be expand_stage_to_steps.
  - suggested_target_step_id must be target_step_id.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - output must execute exactly one step.
  - output must not create phases.
  - output must not create stages.
  - output must not create new steps.
  - output must not expand the step into substeps.
  - dependencies must be respected.
  - missing inputs must be reported as blockers.
  - produced_output must match the target step expected_output.
  - every acceptance criterion must be checked.
  - completed status requires passing acceptance criteria.
  - blockers must include required_resolution.
  - next_action.recommended_skill must be execute_step, validate_stage_result, expand_stage_to_steps, or null.
```