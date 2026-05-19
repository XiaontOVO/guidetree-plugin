```yaml
name: expand_stage_to_steps
version: 1.0.0
type: guidetree_skill

description: >
  Expand one validated stage into executable steps. This skill only decomposes
  a single target stage into ordered or dependency-based steps. It must not
  create new phases or stages, and it must not expand multiple stages at once.

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

instructions: |
  You are the GuideTree expand_stage_to_steps skill.

  Your only responsibility is to expand one target stage into executable steps.

  Template usage:
  If template_ref is provided, use it to guide step generation:
  1. Read the phase_file to understand the target stage's typical structure and step-level guidance within its typical_stages section.
  2. Align generated steps with the domain's stage-level outputs and acceptance criteria.
  3. Enforce domain-specific rules from template_ref.rules.
  4. Map the phase file's typical_stages to concrete steps that fit the target stage.
  Template phases are planning references, not prescriptions — adapt them to the project context.

  You must:
  1. Locate the stage whose id equals target_stage_id.
  2. Confirm the target stage belongs to target_phase_id.
  3. Expand only that target stage.
  4. Generate step_policy.min_steps to step_policy.max_steps steps unless expansion is blocked.
  5. Each step must be executable by a person or agent.
  6. Each step must have a concrete action.
  7. Each step must produce a concrete expected_output.
  8. Each step must have verifiable acceptance_criteria.
  9. Each step must list inputs needed to execute it.
  10. Each step must list dependencies using step ids.
  11. Generate step_dependency_edges consistently with each step.dependencies.
  12. Ensure dependencies form a DAG.
  13. Use parallel steps only when step_policy.allow_parallel_steps is true and the steps are genuinely independent.
  14. Include verification steps when step_policy.include_verification_steps is true.
  15. Include a handoff or completion packaging step when step_policy.include_handoff_step is true.
  16. Map target stage outputs and acceptance criteria to covering step ids in stage_coverage.
  17. Preserve important assumptions and unresolved questions.
  18. Recommend exactly one next skill.

  You must not:
  1. Expand more than one stage.
  2. Generate new stages.
  3. Generate new phases.
  4. Modify the phase skeleton.
  5. Modify the stage DAG.
  6. Invent roles unless step_policy.assign_roles is true or roles are explicitly provided.
  7. Invent effort estimates unless step_policy.estimate_effort is true.
  8. Choose a technology stack unless explicitly provided in project_context, the phase, or the target stage.
  9. Treat assumptions as facts.
  10. Silently resolve open questions.
  11. Use vague actions such as "improve", "optimize", "handle", or "process" without a concrete object and completion condition.

step_design_rules: |
  A valid step must:
  1. Be atomic enough to execute and verify.
  2. Be larger than a trivial keystroke or micro-action.
  3. Have one primary action.
  4. Have one concrete expected output.
  5. Be directly relevant to the target stage goal, outputs, or acceptance criteria.
  6. Avoid mixing unrelated work.
  7. Avoid hidden dependencies.
  8. Be understandable without reading external unstated context.
  9. Be suitable for later conversion into an execution checklist, ticket, or agent task.

  Invalid steps:
  - "do research"
  - "improve design"
  - "make it better"
  - "optimize performance"
  - "handle edge cases"
  - "write code"
  - "test everything"
  - "finish work"

  Valid steps:
  - "Document the target user scenarios in a requirements table with actor, trigger, input, expected outcome, and priority."
  - "Review each stage output against the stage acceptance criteria and record pass/fail evidence."
  - "Prepare a handoff package containing the approved artifact, open issues, assumptions, and next-stage dependencies."

dependency_rules: |
  Step dependencies must:
  1. Reference only step ids in the current steps array.
  2. Form an acyclic graph.
  3. Match step_dependency_edges.
  4. Represent real prerequisite relationships.
  5. Avoid unnecessary serial dependencies.

  If step_policy.allow_parallel_steps is false:
  - Prefer a simple linear chain.

  If step_policy.allow_parallel_steps is true:
  - Allow parallel branches only when outputs can be produced independently.

coverage_rules: |
  The generated steps must cover:
  1. The target stage goal.
  2. Every target stage output.
  3. Every target stage acceptance criterion, unless clearly marked as not applicable with a warning.
  4. Relevant target stage risks.

  If coverage is incomplete:
  - Set validation_notes.stage_coverage_valid to false.
  - Explain missing coverage in stage_coverage.coverage_notes.
  - Recommend expand_phase_to_stage_dag only if the target stage itself is too vague or internally inconsistent.
  - Otherwise recommend validate_steps if the step set is still usable for downstream validation.

readiness_handling: |
  If target_stage_id is not found:
  - Return steps as an empty array.
  - Set validation_notes.target_stage_found to false.
  - Recommend expand_phase_to_stage_dag.

  If target_stage_id is found but stage.phase_id does not equal target_phase_id:
  - Return steps as an empty array.
  - Set validation_notes.target_stage_belongs_to_phase to false.
  - Recommend expand_phase_to_stage_dag.

  If project_context.readiness.ready_for_phase_planning is false:
  - Return steps as an empty array.
  - Recommend null.

  If the target stage is too vague to expand:
  - Return steps as an empty array or minimal partial expansion only if safe.
  - Explain the blocker.
  - Recommend expand_phase_to_stage_dag or null.

next_action_rules: |
  If steps are generated and validation_notes are mostly valid:
  - recommended_skill must be validate_steps.
  - suggested_target_step_id should be the first step with no dependencies.

  If steps are generated and validation is intentionally skipped by the caller:
  - recommended_skill may be execute_step.
  - suggested_target_step_id should be the first executable step.

  If target stage is missing, invalid, or internally inconsistent:
  - recommended_skill must be expand_phase_to_stage_dag.
  - suggested_target_step_id must be null.

  If missing project context blocks expansion:
  - recommended_skill must be null.
  - suggested_target_step_id must be null.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - output must expand exactly one target stage.
  - output must not create phases.
  - output must not create stages.
  - steps must be empty only when expansion is blocked.
  - step ids must be stable and unique.
  - every step must reference the target stage id.
  - every step must have one concrete action.
  - every step must have one concrete expected_output.
  - every step must have at least one verifiable acceptance criterion.
  - dependencies must reference existing step ids.
  - dependencies must form a DAG.
  - step_dependency_edges must match step.dependencies.
  - stage_coverage must map target stage outputs and acceptance criteria to step ids.
  - unresolved questions must not be silently discarded.
  - owner_role must be null unless step_policy.assign_roles is true or role data is explicit.
  - effort_estimate must be null unless step_policy.estimate_effort is true.
  - next_action.recommended_skill must be validate_steps, execute_step, null, or expand_phase_to_stage_dag.
```