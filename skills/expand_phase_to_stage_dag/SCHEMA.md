```yaml
name: expand_phase_to_stage_dag
version: 1.0.0
type: guidetree_skill

description: >
  Expand one validated phase into a stage-level DAG. This skill only decomposes
  a single target phase into stages and stage dependencies. It must not generate
  implementation steps or expand multiple phases at once.

body_ref: ./SKILL.md

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
    - target_phase_id
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
      description: The id of the phase to expand into stages.

    template_ref:
      type: object
      description: Domain template context loaded from references/templates/domains/<template_id>/. Used to guide stage generation from phase definitions.
      default: {}
      properties:
        template_id:
          type: string
          description: The domain template id (e.g. "academic-research").
        phase_file:
          type: string
          description: Path to the target phase YAML file from the template's phases/ directory, which includes typical_stages.
        rules:
          type: string
          description: Path to the template's rules.yaml file.

    stage_policy:
      type: object
      default:
        min_stages: 3
        max_stages: 9
        allow_parallel_stages: true
        require_stage_dag: true
        include_validation_stage: true
        preserve_phase_acceptance_criteria: true
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

        allow_parallel_stages:
          type: boolean
          default: true

        require_stage_dag:
          type: boolean
          default: true

        include_validation_stage:
          type: boolean
          default: true

        preserve_phase_acceptance_criteria:
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
    - phase_name
    - stage_dag
    - stage_dependency_edges
    - phase_coverage
    - expansion_assumptions
    - unresolved_questions
    - validation_notes
    - next_action
  properties:
    skill:
      type: string
      const: expand_phase_to_stage_dag

    version:
      type: string

    summary:
      type: string

    project_id:
      type: string

    phase_id:
      type: string

    phase_name:
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
            description: Stable stage id, such as phase_1_stage_1.

          directory_name:
            type: string
            description: >
              Filesystem directory name for this stage, following the convention
              stage-<NN>-<slug> where NN is zero-padded within the phase and slug
              is kebab-case derived from the stage name. Example: stage-01-research-objective.

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
            minItems: 1
            items:
              type: string

          inputs:
            type: array
            items:
              type: string

          outputs:
            type: array
            minItems: 1
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
      items:
        type: array
        minItems: 2
        maxItems: 2
        items:
          type: string

    phase_coverage:
      type: object
      required:
        - phase_goal_covered
        - phase_outputs_covered
        - phase_acceptance_criteria_covered
        - coverage_notes
      properties:
        phase_goal_covered:
          type: boolean

        phase_outputs_covered:
          type: array
          items:
            type: object
            required:
              - phase_output
              - covered_by_stage_ids
            properties:
              phase_output:
                type: string
              covered_by_stage_ids:
                type: array
                items:
                  type: string

        phase_acceptance_criteria_covered:
          type: array
          items:
            type: object
            required:
              - phase_acceptance_criterion
              - covered_by_stage_ids
            properties:
              phase_acceptance_criterion:
                type: string
              covered_by_stage_ids:
                type: array
                items:
                  type: string

        coverage_notes:
          type: array
          items:
            type: string

    expansion_assumptions:
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
              - block_stage_expansion
              - defer_to_step_planning
              - defer_to_execution

    validation_notes:
      type: object
      required:
        - target_phase_found
        - stage_count_valid
        - dependency_valid
        - phase_coverage_valid
        - no_steps_generated
      properties:
        target_phase_found:
          type: boolean

        stage_count_valid:
          type: boolean

        dependency_valid:
          type: boolean

        phase_coverage_valid:
          type: boolean

        no_steps_generated:
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
        - suggested_target_stage_id
      properties:
        recommended_skill:
          type: string
          enum:
            - validate_stage_dag
            - expand_stage_to_steps
            - null
            - generate_phase_skeleton

        reason:
          type: string

        suggested_target_stage_id:
          type:
            - string
            - "null"
```
