```yaml
name: create_project_context
version: 1.0.0
type: guidetree_skill

description: >
  Initialize a structured project context from the user's raw project description.
  This skill only extracts, normalizes, infers, and evaluates project context.
  It must not generate phases, stages, steps, or any project plan.

input_schema:
  type: object
  required:
    - project_goal_raw
  properties:
    project_goal_raw:
      type: string
      description: The user's original project description.

    user_role:
      type:
        - string
        - "null"
      description: The user's role, such as founder, product_owner, engineer, researcher, manager, student.

    available_context:
      type: object
      description: Optional known project context.
      default: {}
      properties:
        background:
          type:
            - string
            - "null"

        target_users:
          type: array
          items:
            type: string
          default: []

        business_objectives:
          type: array
          items:
            type: string
          default: []

        known_requirements:
          type: array
          items:
            type: string
          default: []

        known_constraints:
          type: object
          default: {}
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
              default: []
            tech_stack:
              type: array
              items:
                type: string
              default: []
            compliance:
              type: array
              items:
                type: string
              default: []
            deployment_environment:
              type:
                - string
                - "null"
          additionalProperties: true

        success_criteria:
          type: array
          items:
            type: string
          default: []

        existing_assets:
          type: array
          items:
            type: string
          default: []

        non_goals:
          type: array
          items:
            type: string
          default: []

        risks:
          type: array
          items:
            type: string
          default: []

      additionalProperties: true

    init_policy:
      type: object
      description: Policy for assumptions, questions, and readiness judgment.
      default:
        ask_clarifying_questions: true
        max_questions: 5
        allow_assumptions: true
        minimum_confidence_to_continue: 0.7
      properties:
        ask_clarifying_questions:
          type: boolean
          default: true

        max_questions:
          type: integer
          minimum: 0
          maximum: 10
          default: 5

        allow_assumptions:
          type: boolean
          default: true

        minimum_confidence_to_continue:
          type: number
          minimum: 0
          maximum: 1
          default: 0.7

  additionalProperties: false

output_schema:
  type: object
  required:
    - skill
    - version
    - summary
    - explicit_information
    - inferred_information
    - project_context
    - next_action
  properties:
    skill:
      type: string
      const: create_project_context

    version:
      type: string

    summary:
      type: string

    explicit_information:
      type: object
      required:
        - project_goal_raw
        - mentioned_requirements
        - mentioned_constraints
        - mentioned_success_criteria
        - mentioned_users
        - mentioned_assets
        - mentioned_non_goals
      properties:
        project_goal_raw:
          type: string

        mentioned_requirements:
          type: array
          items:
            type: string

        mentioned_constraints:
          type: array
          items:
            type: string

        mentioned_success_criteria:
          type: array
          items:
            type: string

        mentioned_users:
          type: array
          items:
            type: string

        mentioned_assets:
          type: array
          items:
            type: string

        mentioned_non_goals:
          type: array
          items:
            type: string

    inferred_information:
      type: object
      required:
        - likely_project_type
        - likely_target_users
        - likely_business_objectives
      properties:
        likely_project_type:
          type: string

        likely_target_users:
          type: array
          items:
            type: object
            required:
              - name
              - reason
              - confidence
            properties:
              name:
                type: string
              reason:
                type: string
              confidence:
                type: string
                enum:
                  - high
                  - medium
                  - low

        likely_business_objectives:
          type: array
          items:
            type: object
            required:
              - objective
              - reason
              - confidence
            properties:
              objective:
                type: string
              reason:
                type: string
              confidence:
                type: string
                enum:
                  - high
                  - medium
                  - low

    project_context:
      type: object
      required:
        - project_id
        - project_name
        - project_goal
        - background
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

    next_action:
      type: object
      required:
        - recommended_skill
        - reason
      properties:
        recommended_skill:
          type: string
          enum:
            - generate_phase_skeleton
            - null

        reason:
          type: string

instructions: |
  You are the GuideTree create_project_context skill.

  Your only responsibility is to initialize project context from the user's raw project description.

  You must:
  1. Extract explicit information from project_goal_raw and available_context.
  2. Normalize the project name.
  3. Normalize the project goal into a clear, concise, deliverable-oriented statement.
  4. Extract known requirements, constraints, success criteria, users, assets, non-goals, and risks.
  5. Infer likely project type, likely users, and likely business objectives only when reasonable.
  6. Mark all inferred information with confidence: high, medium, or low.
  7. Put uncertain but useful assumptions into project_context.assumptions.
  8. Generate open questions only for important missing information.
  9. Limit open questions to init_policy.max_questions.
  10. Prioritize questions affecting scope, delivery form, target users, constraints, or success criteria.
  11. Make success_criteria as verifiable as possible.
  12. Evaluate whether the context is ready for phase-level planning.
  13. Recommend exactly one next skill:
      - generate_phase_skeleton
      - stop for operator clarification

  You must not:
  1. Generate phases.
  2. Generate stages.
  3. Generate steps.
  4. Generate a project plan.
  5. Design technical architecture.
  6. Choose a technology stack unless explicitly provided by the user.
  7. Treat assumptions as facts.
  8. Invent specific users, departments, metrics, deadlines, tools, or constraints as facts.
  9. Ask low-level implementation questions unless implementation details are the main project goal.
  10. Output vague success criteria such as:
      - good experience
      - better performance
      - high quality
      - works well
      - reasonable solution
      - improved results

readiness_rule: |
  Set project_context.readiness.ready_for_phase_planning to true only if:
  1. The project has a recognizable goal.
  2. The project type can be reasonably identified or inferred.
  3. There is at least one plausible deliverable direction.
  4. There is at least one explicit or inferable success criterion.
  5. Critical unknowns can be represented as assumptions or open questions.

  Set project_context.readiness.ready_for_phase_planning to false if:
  1. The project goal is too vague.
  2. The intended deliverable cannot be identified.
  3. The project type cannot be inferred.
  4. The target outcome is unclear.
  5. There is no meaningful basis for phase-level planning.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - project_goal_raw must be preserved in explicit_information.project_goal_raw.
  - project_context.project_goal must be normalized and not merely copied unless already clear.
  - explicit_information and inferred_information must be separated.
  - inferred information must include confidence.
  - assumptions must not be stated as facts.
  - success_criteria must be verifiable where possible.
  - open_questions must include id, question, impact, and priority.
  - readiness must include ready_for_phase_planning, confidence, and reason.
  - next_action.recommended_skill must be either generate_phase_skeleton or null.
  - output must not contain phases, stages, steps, or guide_tree.
```