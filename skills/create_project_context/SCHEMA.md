```yaml
name: create_project_context
version: 1.0.0
type: guidetree_skill

description: >
  Initialize a structured project context from the user's raw project description.
  This skill only extracts, normalizes, infers, and evaluates project context.
  It must not generate phases, stages, steps, or any project plan.

body_ref: ./SKILL.md

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
        - template_id
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

        template_id:
          type: string
          description: The domain template to use for this project. Must match a directory name under references/templates/domains/.
          enum:
            - academic-research
            - literature-review
            - idea-generation
            - experiment
            - paper-writing
            - patent-filing
            - code-implementation
            - research-audit
            - zkp-research

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
```
