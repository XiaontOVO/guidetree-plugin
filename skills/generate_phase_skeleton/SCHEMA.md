```yaml
name: generate_phase_skeleton
version: 1.0.0
type: guidetree_skill

description: >
  Generate the top-level phase skeleton for a project based on an initialized
  project_context. This skill only creates phases. It must not generate stages,
  steps, or detailed execution plans.

body_ref: ./SKILL.md

input_schema:
  type: object
  required:
    - project_context
  properties:
    project_context:
      type: object
      required:
        - project_id
        - project_name
        - project_goal
        - target_users
        - business_objectives
        - success_criteria
        - known_requirements
        - known_constraints
        - existing_assets
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
            required:
              - name
              - description
              - confidence
            properties:
              name:
                type: string
              description:
                type: string
              confidence:
                type: string
                enum:
                  - high
                  - medium
                  - low

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
          required:
            - deadline
            - budget
            - team
            - tech_stack
            - compliance
            - deployment_environment
          properties:
            deadline:
              type:
                - string
                - "null"
            budget:
              type:
                - string
                - "null"
            team:
              type: array
              items:
                type: string
            tech_stack:
              type: array
              items:
                type: string
            compliance:
              type: array
              items:
                type: string
            deployment_environment:
              type:
                - string
                - "null"

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
            required:
              - id
              - question
              - impact
              - priority
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

    phase_policy:
      type: object
      description: Policy controlling phase generation.
      default:
        min_phases: 5
        max_phases: 9
        include_closure_phase: true
        allow_parallel_phase_dependencies: false
        respect_open_questions: true
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

        include_closure_phase:
          type: boolean
          default: true

        allow_parallel_phase_dependencies:
          type: boolean
          default: false

        respect_open_questions:
          type: boolean
          default: true

    template_ref:
      type: object
      description: Domain template context loaded from references/templates/domains/<template_id>/. Used to guide phase generation from template phase definitions.
      default: {}
      properties:
        template_id:
          type: string
          description: The domain template id (e.g. "academic-research").
        phase_files:
          type: array
          items:
            type: string
          description: Paths to phase YAML files from the template's phases/ directory.
        rules:
          type: string
          description: Path to the template's rules.yaml file.

  additionalProperties: false

output_schema:
  type: object
  required:
    - skill
    - version
    - summary
    - project_id
    - phase_skeleton
    - phase_dependency_edges
    - planning_assumptions
    - unresolved_questions
    - validation_notes
    - next_action
  properties:
    skill:
      type: string
      const: generate_phase_skeleton

    version:
      type: string

    summary:
      type: string

    project_id:
      type: string

    phase_skeleton:
      type: array
      minItems: 3
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
            description: Stable phase id, such as phase_1, phase_2.

          directory_name:
            type: string
            description: >
              Filesystem directory name for this phase, following the convention
              phase-<NN>-<slug> where NN is zero-padded and slug is kebab-case
              derived from the phase name. Example: phase-01-research-framing.

          name:
            type: string
            description: Clear phase name.

          goal:
            type: string
            description: The purpose of this phase.

          rationale:
            type: string
            description: Why this phase is needed.

          acceptance_criteria:
            type: array
            minItems: 1
            items:
              type: string
            description: Verifiable criteria for completing this phase.

          inputs:
            type: array
            items:
              type: string
            description: Inputs required to start or complete this phase.

          outputs:
            type: array
            minItems: 1
            items:
              type: string
            description: Deliverables produced by this phase.

          dependencies:
            type: array
            items:
              type: string
            description: Other phase ids this phase depends on.

          risks:
            type: array
            items:
              type: string
            description: Phase-specific risks.

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
      items:
        type: array
        minItems: 2
        maxItems: 2
        items:
          type: string
      description: Dependency edges between phases, represented as [from_phase_id, to_phase_id].

    planning_assumptions:
      type: array
      items:
        type: string
      description: Assumptions used to generate the phase skeleton.

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
              - block_phase_planning
              - defer_to_stage_planning
              - defer_to_step_planning

    validation_notes:
      type: object
      required:
        - phase_count_valid
        - coverage_valid
        - dependency_valid
        - acceptance_criteria_valid
        - no_stage_or_step_generated
      properties:
        phase_count_valid:
          type: boolean

        coverage_valid:
          type: boolean

        dependency_valid:
          type: boolean

        acceptance_criteria_valid:
          type: boolean

        no_stage_or_step_generated:
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
        - suggested_target_phase_id
      properties:
        recommended_skill:
          type: string
          enum:
            - validate_phase_skeleton
            - expand_phase_to_stage_dag
            - null

        reason:
          type: string

        suggested_target_phase_id:
          type:
            - string
            - "null"
```
