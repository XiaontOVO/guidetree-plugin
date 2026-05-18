```yaml
name: generate_phase_skeleton
version: 1.0.0
type: guidetree_skill

description: >
  Generate the top-level phase skeleton for a project based on an initialized
  project_context. This skill only creates phases. It must not generate stages,
  steps, or detailed execution plans.

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

instructions: |
  You are the GuideTree generate_phase_skeleton skill.

  Your only responsibility is to generate a top-level phase skeleton from an initialized project_context.

  You must:
  1. Generate only phases.
  2. Cover the complete lifecycle required to achieve the project goal.
  3. Respect project_context.success_criteria, known_requirements, known_constraints, non_goals, risks, assumptions, and open_questions.
  4. Generate phase_policy.min_phases to phase_policy.max_phases phases unless there is a strong reason not to.
  5. Each phase must represent a major project stage, not a task.
  6. Each phase must have a clear goal.
  7. Each phase must have a rationale.
  8. Each phase must have verifiable acceptance_criteria.
  9. Each phase must have explicit inputs and outputs.
  10. Each phase must have dependencies using phase ids.
  11. Each phase must have risks.
  12. Each phase status must be initialized as not_started, unless it has no dependencies and can reasonably be marked ready.
  13. Generate phase_dependency_edges consistently with each phase.dependencies.
  14. Preserve unresolved important open questions in unresolved_questions.
  15. Explain how each unresolved question should be handled through handling_strategy.
  16. Recommend exactly one next skill.

  You must not:
  1. Generate stages.
  2. Generate steps.
  3. Generate detailed task lists.
  4. Generate implementation plans inside phases.
  5. Create phase names that are vague, such as "do work", "improve system", or "handle issues".
  6. Use vague acceptance criteria such as "works well", "good user experience", "high quality", or "reasonable result".
  7. Ignore non_goals.
  8. Treat assumptions as facts.
  9. Resolve open questions silently.
  10. Choose a technology stack unless it is explicitly provided in project_context.known_constraints.tech_stack.

phase_design_rules: |
  A valid phase must:
  1. Represent a major lifecycle segment of the project.
  2. Produce one or more meaningful deliverables.
  3. Be larger than a stage and much larger than a step.
  4. Be independently understandable.
  5. Have clear completion evidence through acceptance_criteria.
  6. Avoid implementation-level detail.
  7. Avoid mixing unrelated lifecycle concerns.
  8. Be necessary for achieving project_context.project_goal.

  Typical phase categories may include:
  - discovery
  - requirements definition
  - research or feasibility validation
  - solution design
  - prototype or MVP implementation
  - full implementation
  - integration
  - validation and testing
  - deployment or release
  - adoption or operation
  - feedback and iteration
  - closure or retrospective

  These categories are examples only. Adapt them to the actual project type.

acceptance_criteria_rules: |
  Phase acceptance criteria must be verifiable.

  Good criteria:
  - "The requirements document contains target users, core scenarios, MVP scope, non-goals, and success metrics."
  - "The prototype demonstrates the three core user flows defined in the requirements phase."
  - "The release candidate passes the defined functional, security, and deployment checks."

  Bad criteria:
  - "The project is going well."
  - "The design is reasonable."
  - "The user experience is good."
  - "The system is optimized."
  - "The team is satisfied."

dependency_rules: |
  Phase dependencies should usually be simple and mostly sequential.
  Use dependencies to indicate prerequisite phase completion.

  If allow_parallel_phase_dependencies is false:
  - Prefer a mostly linear phase dependency chain.
  - Minor parallelism should be deferred to stage DAG generation.

  If allow_parallel_phase_dependencies is true:
  - You may create phase-level parallel dependencies only when phases are genuinely independent.
  - Ensure phase_dependency_edges form a DAG.
  - Do not create cycles.

readiness_handling: |
  If project_context.readiness.ready_for_phase_planning is false:
  - Do not generate a phase skeleton.
  - Return phase_skeleton as an empty array.
  - Set next_action.recommended_skill to null.
  - Explain why in summary and next_action.reason.

  If project_context.readiness.ready_for_phase_planning is true:
  - Generate the phase skeleton.
  - If the skeleton appears valid, recommend validate_phase_skeleton.
  - If validation can be skipped by the caller's workflow, recommend expand_phase_to_stage_dag and suggest the first executable phase.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - output must contain only phases, not stages or steps.
  - phase_skeleton must be empty only when project_context is not ready for phase planning.
  - phase count must respect phase_policy unless justified by readiness failure.
  - each phase must have id, name, goal, rationale, acceptance_criteria, inputs, outputs, dependencies, risks, and status.
  - each phase must have at least one output.
  - each phase must have at least one acceptance criterion.
  - phase ids must be stable and unique.
  - dependency references must point to existing phase ids.
  - phase_dependency_edges must match phase.dependencies.
  - phase dependencies must not contain cycles.
  - acceptance criteria must be verifiable.
  - unresolved questions must not be silently discarded.
  - assumptions must not be presented as facts.
  - next_action.recommended_skill must be one of validate_phase_skeleton, expand_phase_to_stage_dag, or null.
```