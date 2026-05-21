```yaml
name: expand_stage_to_steps
version: 1.0.0
type: guidetree_skill

description: >
  Expand one validated stage into executable steps. This skill only decomposes
  a single target stage into ordered or dependency-based steps. It must not
  create new phases or stages, and it must not expand multiple stages at once.

body_ref: ./SKILL.md

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
    - target_phase_id
    - stage_dag
    - target_stage_id
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
      description: The id of the stage to expand into executable steps.

    template_ref:
      type: object
      description: Domain template context loaded from references/templates/domains/<template_id>/. Used to guide step generation from phase definitions.
      default: {}
      properties:
        template_id:
          type: string
          description: The domain template id (e.g. "academic-research").
        phase_file:
          type: string
          description: Path to the target phase YAML file from the template's phases/ directory, which includes typical_stages with step-level guidance.
        rules:
          type: string
          description: Path to the template's rules.yaml file.

    step_policy:
      type: object
      default:
        min_steps: 4
        max_steps: 15
        allow_parallel_steps: true
        require_step_dependencies: true
        include_verification_steps: true
        include_handoff_step: true
        estimate_effort: false
        assign_roles: false
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

        allow_parallel_steps:
          type: boolean
          default: true

        require_step_dependencies:
          type: boolean
          default: true

        include_verification_steps:
          type: boolean
          default: true

        include_handoff_step:
          type: boolean
          default: true

        estimate_effort:
          type: boolean
          default: false

        assign_roles:
          type: boolean
          default: false

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
    - stage_name
    - steps
    - step_dependency_edges
    - stage_coverage
    - execution_assumptions
    - unresolved_questions
    - validation_notes
    - next_action
  properties:
    skill:
      type: string
      const: expand_stage_to_steps

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

    stage_name:
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
            description: Stable step id, such as phase_1_stage_1_step_1.

          file_name:
            type: string
            description: >
              Filesystem file name for this step's markdown file, following the convention
              step-<NN>-<slug>.md where NN is zero-padded within the stage and slug
              is kebab-case derived from the step name. Example: step-01-refine-research-question.md.

          stage_id:
            type: string

          name:
            type: string

          objective:
            type: string
            description: The purpose of this step.

          action:
            type: string
            description: A concrete action to perform.

          expected_output:
            type: string
            description: The concrete artifact, result, or decision produced by this step.

          acceptance_criteria:
            type: array
            minItems: 1
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
            description: Optional role responsible for this step when step_policy.assign_roles is true.

          effort_estimate:
            type:
              - string
              - "null"
            description: Optional coarse effort estimate when step_policy.estimate_effort is true.

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
      items:
        type: array
        minItems: 2
        maxItems: 2
        items:
          type: string

    stage_coverage:
      type: object
      required:
        - stage_goal_covered
        - stage_outputs_covered
        - stage_acceptance_criteria_covered
        - coverage_notes
      properties:
        stage_goal_covered:
          type: boolean

        stage_outputs_covered:
          type: array
          items:
            type: object
            required:
              - stage_output
              - covered_by_step_ids
            properties:
              stage_output:
                type: string
              covered_by_step_ids:
                type: array
                items:
                  type: string

        stage_acceptance_criteria_covered:
          type: array
          items:
            type: object
            required:
              - stage_acceptance_criterion
              - covered_by_step_ids
            properties:
              stage_acceptance_criterion:
                type: string
              covered_by_step_ids:
                type: array
                items:
                  type: string

        coverage_notes:
          type: array
          items:
            type: string

    execution_assumptions:
      type: array
      items:
        type: string

    unresolved_questions:
      type: array
      items:
        type: object
        required:
          - id
          - question
          - impact
          - priority
          - handling_strategy
        properties:
          id:
            type: string
          question:
            type: string
          impact:
            type: string
          priority:
            type: string
            enum:
              - high
              - medium
              - low
          handling_strategy:
            type: string
            enum:
              - proceed_with_assumption
              - block_step_expansion
              - defer_to_execution
              - require_user_decision

    validation_notes:
      type: object
      required:
        - target_stage_found
        - target_stage_belongs_to_phase
        - step_count_valid
        - dependency_valid
        - stage_coverage_valid
        - execution_level_valid
      properties:
        target_stage_found:
          type: boolean

        target_stage_belongs_to_phase:
          type: boolean

        step_count_valid:
          type: boolean

        dependency_valid:
          type: boolean

        stage_coverage_valid:
          type: boolean

        execution_level_valid:
          type: boolean

        warnings:
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
            - validate_steps
            - execute_step
            - null
            - expand_phase_to_stage_dag

        reason:
          type: string

        suggested_target_step_id:
          type:
            - string
            - "null"
```
