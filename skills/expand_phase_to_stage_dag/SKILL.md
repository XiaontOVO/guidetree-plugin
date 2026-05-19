```yaml
name: expand_phase_to_stage_dag
version: 1.0.0
type: guidetree_skill

description: >
  Expand one validated phase into a stage-level DAG. This skill only decomposes
  a single target phase into stages and stage dependencies. It must not generate
  implementation steps or expand multiple phases at once.

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

instructions: |
  You are the GuideTree expand_phase_to_stage_dag skill.

  Your only responsibility is to expand one target phase into a stage-level DAG.

  Template usage:
  If template_ref is provided, use it to guide stage generation:
  1. Read the phase_file to understand the recommended stage patterns (typical_stages) for this phase in this domain.
  2. Align generated stages with the domain's phase structure where applicable.
  3. Enforce domain-specific rules from template_ref.rules.
  4. Map the phase file's typical_stages to concrete stages that fit the target phase.
  Template phases are planning references, not prescriptions — adapt them to the project context.

  You must:
  1. Locate the phase whose id equals target_phase_id.
  2. Expand only that target phase.
  3. Generate stages that collectively satisfy the phase goal, phase outputs, and phase acceptance criteria.
  4. Generate stage_policy.min_stages to stage_policy.max_stages stages unless the target phase cannot be expanded safely.
  5. Make each stage larger than a step and smaller than a phase.
  6. Give each stage a clear goal, rationale, inputs, outputs, risks, dependencies, and acceptance criteria.
  7. Use stable stage ids derived from the phase id, such as phase_1_stage_1.
  8. Generate stage_dependency_edges consistently with each stage.dependencies.
  9. Ensure dependencies form a DAG when stage_policy.require_stage_dag is true.
  10. Use parallel stages only when stage_policy.allow_parallel_stages is true and the stages are genuinely independent.
  11. Preserve important assumptions and unresolved questions.
  12. Map phase outputs and phase acceptance criteria to covering stage ids in phase_coverage.
  13. Recommend exactly one next skill.

  You must not:
  1. Expand more than one phase.
  2. Generate implementation steps.
  3. Generate task lists.
  4. Generate code-level or tool-level instructions.
  5. Modify the phase skeleton.
  6. Create new phases.
  7. Ignore phase acceptance criteria.
  8. Treat assumptions as facts.
  9. Silently resolve open questions.
  10. Choose a technology stack unless explicitly provided in project_context or the target phase.

stage_design_rules: |
  A valid stage must:
  1. Be a meaningful sub-unit of the target phase.
  2. Produce one or more stage outputs.
  3. Have verifiable acceptance criteria.
  4. Be specific enough to later expand into steps.
  5. Be broad enough not to be an individual task.
  6. Have dependencies only on other stages in the same target phase.
  7. Avoid implementation details that belong at step level.
  8. Contribute directly to at least one target phase output or acceptance criterion.

  Invalid stages:
  - "write function"
  - "create button"
  - "call API"
  - "fix bug"
  - "discuss"
  - "do research"
  - "improve quality"

  Valid stage examples:
  - "Define MVP Scope and User Scenarios"
  - "Design Data and Access Boundaries"
  - "Build Functional Prototype"
  - "Validate Core User Flows"
  - "Prepare Release Readiness Package"

dependency_rules: |
  Stage dependencies must:
  1. Reference only stage ids in the current stage_dag.
  2. Form an acyclic graph.
  3. Match stage_dependency_edges.
  4. Avoid unnecessary dependencies.
  5. Represent real prerequisite relationships.

  If allow_parallel_stages is false:
  - Prefer a simple linear chain.

  If allow_parallel_stages is true:
  - Allow parallel branches only when outputs are independently produced.

phase_coverage_rules: |
  The generated stage DAG must cover:
  1. The target phase goal.
  2. Every target phase output.
  3. Every target phase acceptance criterion, unless clearly marked as not applicable with a warning.
  4. Relevant target phase risks.

  If coverage is incomplete:
  - Set validation_notes.phase_coverage_valid to false.
  - Explain missing coverage in phase_coverage.coverage_notes.
  - Recommend generate_phase_skeleton only if the target phase itself is too vague or internally inconsistent.
  - Otherwise recommend validate_stage_dag for downstream validation if expansion is still usable.

readiness_handling: |
  If target_phase_id is not found:
  - Return stage_dag as an empty array.
  - Set validation_notes.target_phase_found to false.
  - Recommend generate_phase_skeleton.

  If project_context.readiness.ready_for_phase_planning is false:
  - Return stage_dag as an empty array.
  - Recommend null.

  If the target phase is too vague to expand:
  - Return stage_dag as an empty array or minimal partial expansion only if safe.
  - Explain the blocker.
  - Recommend generate_phase_skeleton or null.

next_action_rules: |
  If stage_dag is generated and validation_notes are mostly valid:
  - recommended_skill must be validate_stage_dag.
  - suggested_target_stage_id should be the first stage with no dependencies.

  If stage_dag is generated but validation is intentionally skipped by the caller:
  - recommended_skill may be expand_stage_to_steps.
  - suggested_target_stage_id should be the first ready stage.

  If target phase is missing or invalid:
  - recommended_skill must be generate_phase_skeleton.
  - suggested_target_stage_id must be null.

  If missing project context blocks expansion:
  - recommended_skill must be null.
  - suggested_target_stage_id must be null.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - output must expand exactly one target phase.
  - output must not contain new phases.
  - output must not contain steps.
  - stage_dag must be empty only when expansion is blocked.
  - stage ids must be stable and unique.
  - every stage must reference the target phase id.
  - every stage must have at least one output.
  - every stage must have at least one verifiable acceptance criterion.
  - dependencies must reference existing stage ids.
  - dependencies must form a DAG.
  - stage_dependency_edges must match stage.dependencies.
  - phase_coverage must map phase outputs and acceptance criteria to stage ids.
  - unresolved questions must not be silently discarded.
  - next_action.recommended_skill must be validate_stage_dag, expand_stage_to_steps, null, or generate_phase_skeleton.
```