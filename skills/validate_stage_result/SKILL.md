```yaml
name: validate_stage_result
version: 1.0.0
type: guidetree_skill

description: >
  Validate the result of exactly one completed stage. This skill checks whether
  the executed steps and their outputs collectively satisfy the stage goal,
  required outputs, and stage acceptance criteria. It validates the stage as a
  delivery boundary, not individual steps.

input_schema:
  type: object
  required:
    - project_context
    - phase_skeleton
    - target_phase_id
    - stage_dag
    - target_stage_id
    - steps
    - step_execution_results
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
          - acceptance_criteria
          - dependencies
          - status
        properties:
          id:
            type: string
          name:
            type: string
          goal:
            type: string
          acceptance_criteria:
            type: array
            items:
              type: string
          dependencies:
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
            enum:
              - not_started
              - ready
              - in_progress
              - blocked
              - done
              - failed
              - needs_revision
              - skipped

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

    step_execution_results:
      type: array
      items:
        type: object
        required:
          - step_id
          - stage_id
          - status
          - produced_output
        properties:
          step_id:
            type: string
          stage_id:
            type: string
          status:
            type: string
            enum:
              - completed
              - blocked
              - failed
              - skipped
              - needs_revision
          produced_output:
            type:
              - object
              - string
              - array
              - "null"
          evidence:
            type: array
            default: []
            items:
              type: object
          blockers:
            type: array
            default: []
            items:
              type: object
          notes:
            type: array
            default: []
            items:
              type: string

    validation_policy:
      type: object
      default:
        require_all_required_steps_completed: true
        allow_skipped_optional_steps: true
        require_stage_outputs_covered: true
        require_all_stage_acceptance_criteria_passed: true
        require_no_open_blockers: true
        require_non_goal_compliance: true
        require_evidence_for_stage_claims: true
      properties:
        require_all_required_steps_completed:
          type: boolean
          default: true
        allow_skipped_optional_steps:
          type: boolean
          default: true
        require_stage_outputs_covered:
          type: boolean
          default: true
        require_all_stage_acceptance_criteria_passed:
          type: boolean
          default: true
        require_no_open_blockers:
          type: boolean
          default: true
        require_non_goal_compliance:
          type: boolean
          default: true
        require_evidence_for_stage_claims:
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
    - valid
    - stage_status_recommendation
    - validation_report
    - stage_output_assessment
    - acceptance_check
    - blocking_issues
    - non_blocking_warnings
    - next_action
  properties:
    skill:
      type: string
      const: validate_stage_result

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

    valid:
      type: boolean

    stage_status_recommendation:
      type: string
      enum:
        - done
        - blocked
        - failed
        - needs_revision
        - skipped

    validation_report:
      type: object
      required:
        - target_stage_found
        - phase_alignment_valid
        - required_steps_completed
        - step_outputs_usable
        - stage_goal_satisfied
        - stage_outputs_covered
        - acceptance_criteria_satisfied
        - blockers_resolved
        - non_goal_compliance_valid
      properties:
        target_stage_found:
          type: boolean
        phase_alignment_valid:
          type: boolean
        required_steps_completed:
          type: boolean
        step_outputs_usable:
          type: boolean
        stage_goal_satisfied:
          type: boolean
        stage_outputs_covered:
          type: boolean
        acceptance_criteria_satisfied:
          type: boolean
        blockers_resolved:
          type: boolean
        non_goal_compliance_valid:
          type: boolean

    stage_output_assessment:
      type: object
      required:
        - required_outputs
        - covered_outputs
        - missing_outputs
        - output_sources
      properties:
        required_outputs:
          type: array
          items:
            type: string
        covered_outputs:
          type: array
          items:
            type: string
        missing_outputs:
          type: array
          items:
            type: string
        output_sources:
          type: array
          items:
            type: object
            required:
              - stage_output
              - source_step_ids
              - evidence
            properties:
              stage_output:
                type: string
              source_step_ids:
                type: array
                items:
                  type: string
              evidence:
                type: string

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

    blocking_issues:
      type: array
      items:
        type: object
        required:
          - id
          - issue
          - reason
          - required_fix
        properties:
          id:
            type: string
          issue:
            type: string
          reason:
            type: string
          required_fix:
            type: string

    non_blocking_warnings:
      type: array
      items:
        type: object
        required:
          - id
          - warning
          - suggestion
        properties:
          id:
            type: string
          warning:
            type: string
          suggestion:
            type: string

    next_action:
      type: object
      required:
        - recommended_skill
        - reason
        - suggested_target_stage_id
        - suggested_target_phase_id
      properties:
        recommended_skill:
          type: string
          enum:
            - execute_step
            - expand_stage_to_steps
            - orchestrate_project
            - validate_stage_result
            - null
        reason:
          type: string
        suggested_target_stage_id:
          type:
            - string
            - "null"
        suggested_target_phase_id:
          type:
            - string
            - "null"

instructions: |
  You are the GuideTree validate_stage_result skill.

  Your only responsibility is to validate exactly one stage result.

  You must:
  1. Locate the target stage whose id equals target_stage_id.
  2. Confirm the target stage belongs to target_phase_id.
  3. Collect all steps whose stage_id equals target_stage_id.
  4. Review their execution statuses and produced outputs.
  5. Determine whether all required stage work has been completed.
  6. Determine whether step outputs collectively satisfy the stage goal.
  7. Determine whether step outputs collectively cover every required stage output.
  8. Check every stage acceptance criterion.
  9. Identify missing outputs, incomplete work, unresolved blockers, or contradictions.
  10. Check that the stage result does not violate project_context.non_goals.
  11. Recommend the stage status.
  12. Recommend exactly one next skill.

  You must not:
  1. Re-execute any step.
  2. Validate each step as a separate governance boundary.
  3. Create new phases.
  4. Create new stages.
  5. Create new steps unless recommending expand_stage_to_steps.
  6. Modify the stage DAG.
  7. Modify the steps list.
  8. Treat missing outputs as satisfied.
  9. Treat blocked or failed required steps as complete.
  10. Mark the stage valid if any stage acceptance criterion fails.
  11. Hide blockers.
  12. Infer evidence that is not present.

validation_rules: |
  A stage result is valid only if:
  1. target_stage_id exists in stage_dag.
  2. target stage phase_id equals target_phase_id.
  3. all required steps for the stage are completed, unless explicitly optional or skipped with acceptable rationale.
  4. no required step is blocked, failed, or needs_revision.
  5. produced step outputs collectively satisfy the stage goal.
  6. every required stage output is covered by one or more step outputs.
  7. every stage acceptance criterion passes.
  8. evidence exists for each passed stage acceptance criterion when required.
  9. no unresolved blocker remains.
  10. no output violates project_context.non_goals.
  11. no output contradicts known_requirements or known_constraints.

  If any blocking issue exists:
  - valid must be false.
  - stage_status_recommendation must not be done.

stage_status_rules: |
  Set stage_status_recommendation as follows:

  done:
    Use only when valid is true and all stage acceptance criteria pass.

  blocked:
    Use when required information, input, dependency, approval, or external artifact is missing.

  failed:
    Use when completed step outputs prove the stage goal cannot be satisfied without rework.

  needs_revision:
    Use when outputs are incomplete, inconsistent, low quality, or insufficient but repairable.

  skipped:
    Use only when the stage is explicitly unnecessary and skipping does not harm downstream stages.

output_coverage_rules: |
  For every item in target_stage.outputs:
  1. Find one or more step_execution_results that produced it or substantively support it.
  2. Record the source step ids.
  3. Record evidence explaining why the output is covered.
  4. If no sufficient source exists, add the output to missing_outputs.
  5. Missing required outputs are blocking issues.

acceptance_rules: |
  Stage acceptance criteria are checked at the stage level.

  A criterion passes only if:
  1. the combined step outputs satisfy it;
  2. evidence is available from produced outputs or execution evidence;
  3. no unresolved blocker contradicts it;
  4. it does not rely on assumptions unless explicitly allowed.

  If any stage acceptance criterion fails:
  - valid must be false.
  - stage_status_recommendation must be needs_revision, blocked, or failed.

blocking_issue_rules: |
  Add a blocking issue when:
  - target stage is missing.
  - target stage does not belong to target_phase_id.
  - a required step is not completed.
  - a required step is blocked, failed, or needs_revision.
  - a required stage output is missing.
  - a stage acceptance criterion fails.
  - evidence for a passed criterion is missing.
  - an unresolved blocker remains.
  - the result violates a non-goal.
  - the result violates known constraints.
  - the stage goal is not satisfied.

warning_rules: |
  Add a non-blocking warning when:
  - output is acceptable but weakly evidenced.
  - optional step was skipped with acceptable rationale.
  - risk remains but does not block stage completion.
  - documentation could be clearer.
  - downstream handoff should mention a limitation.

next_action_rules: |
  If valid is true and all stages in the target phase are complete or ready for phase validation:
  - recommended_skill must be orchestrate_project.
  - suggested_target_phase_id must be target_phase_id.
  - suggested_target_stage_id may be null.

  If valid is true but another stage in the same phase should be validated next:
  - recommended_skill may be validate_stage_result.
  - suggested_target_stage_id should be the next completed stage id.

  If valid is false because some required step is not executed:
  - recommended_skill must be execute_step.
  - suggested_target_stage_id must be target_stage_id.

  If valid is false because step definitions are insufficient or wrong:
  - recommended_skill must be expand_stage_to_steps.
  - suggested_target_stage_id must be target_stage_id.

  If valid is false because outputs are incomplete or inconsistent:
  - recommended_skill must be expand_stage_to_steps.
  - suggested_target_stage_id must be target_stage_id.

  If valid is false because missing information prevents judgment:
  - recommended_skill must be null.
  - suggested_target_stage_id must be target_stage_id.

output_format: |
  Return valid JSON only.
  Do not include markdown.
  Do not include comments.
  Do not include explanations outside the JSON object.
  The output must conform to output_schema.

quality_gates:
  - validates exactly one stage.
  - does not execute steps.
  - does not re-validate individual steps as separate governance units.
  - checks stage goal satisfaction.
  - checks coverage of every required stage output.
  - checks every stage acceptance criterion.
  - requires evidence for passed stage-level claims.
  - reports unresolved blockers.
  - reports missing outputs.
  - enforces project non-goals and constraints.
  - valid cannot be true if any blocking issue exists.
  - stage_status_recommendation cannot be done unless valid is true.
  - next_action.recommended_skill must be one of the allowed skills.
```