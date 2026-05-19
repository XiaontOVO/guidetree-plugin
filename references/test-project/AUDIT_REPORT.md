# GuideTree Dry-Run Audit Report

**Project:** Folding Scheme Optimization for Recursive zkSNARKs
**Date:** 2026-05-18
**Auditor:** Automated self-audit after pipeline simulation
**Scope:** Pipeline simulation through P1 expansion (create_project_context -> generate_phase_skeleton -> validate -> expand_phase_to_stage_dag -> validate -> expand_stage_to_steps)

---

## Issue Summary

| Severity | Count |
|----------|-------|
| Critical | 2     |
| High     | 3     |
| Medium   | 4     |
| Low      | 4     |

---

## Critical Issues

### C1: template_id Enum Does Not Include Domain-Specific Templates

**File:** `d:/guidetree/references/test-project/guidetree/project_context.json` (line 58)
**File:** `d:/guidetree/skills/create_project_context/SKILL.md` (lines 291-299)

The `create_project_context` output_schema defines `template_id` as an enum with 8 values:
`academic-research`, `literature-review`, `idea-generation`, `experiment`, `paper-writing`, `patent-filing`, `code-implementation`, `research-audit`.

The value `"zkp-research"` is NOT in this enum, yet a `zkp-research` domain template directory exists at `d:/guidetree/references/templates/domains/zkp-research/` with comprehensive phase definitions (P1-P8), ZKP-specific rules, standards, and research type patterns.

The project_context.json uses `"academic-research"` to stay schema-compliant, but this means the orchestrator will load the generic academic-research template instead of the zkp-research template. The generic template lacks:
- ZKP-specific phase definitions (folding invariant, accumulator correctness, verifier circuit cost stages)
- STRICT.ZKP.1-10 enforcement rules
- ZKP.R1-R10 agent planning rules (especially ZKP.R7 for folding/recursive research)
- ZKP-specific acceptance standards and anti-patterns

**Impact:** The entire downstream pipeline will use the wrong template, missing domain-specific validation rules and stage guidance. Phase and stage generation will not benefit from the zkp-research domain knowledge.

**Fix:** Add `"zkp-research"` (and other domain-specific template IDs) to the `template_id` enum in `create_project_context/SKILL.md`. Alternatively, introduce a two-level template resolution: `template_id` selects the base template, and a `domain_id` field selects the domain overlay.

---

### C2: Skill-to-Template Bridge Fails for zkp-research Projects

**File:** `d:/guidetree/skills/orchestrate_project/SKILL.md` (lines 549-556)
**File:** `d:/guidetree/references/test-project/guidetree/project.state.yaml` (line 4)

The orchestrator's `skill_input_construction_rules` state:
> "Include template_ref loaded from `references/templates/domains/<template_id>/` based on `project_context.template_id`."

When `template_id` is `"academic-research"`, the orchestrator loads `references/templates/domains/academic-research/`, which has generic academic phases and rules -- not the ZKP-specific ones.

The `project.state.yaml` has both:
- `template_id: academic-research`
- `domain: zero_knowledge_proof_research`

But there is no documented mechanism for the orchestrator to use the `domain` field to override or supplement the template loaded via `template_id`. The `domain` field is not part of the `create_project_context` output_schema, so it would not be propagated from project_context.json to the orchestrator.

**Impact:** Even if a user explicitly targets ZKP research, the pipeline loads the generic academic template, losing all domain-specific phase structure, rules, and standards.

**Fix:** Either (a) add `domain_id` or `subdomain_template_id` to the project_context output_schema and teach the orchestrator to load it as an overlay, or (b) include all domain-specific template IDs in the `template_id` enum (as in C1).

---

## High Issues

### H1: No Documented Convention for Phase ID-to-Directory Mapping

**File:** `d:/guidetree/references/test-project/guidetree/phase_skeleton.json` (phase IDs: `phase_1`, `phase_2`, ...)
**File:** `d:/guidetree/references/templates/core/rules/directory-conventions.md` (DIR-3)
**Directory:** `d:/guidetree/references/test-project/guidetree/phases/phase-01-research-framing/`

Phase IDs in the phase_skeleton use the format `phase_<N>` (underscore, no zero-padding, no name). Directory names use `phase-<NN>-<name>` (hyphen, zero-padded, kebab-case name). There is no documented convention or mapping mechanism for resolving `phase_1` to `phase-01-research-framing`.

The same gap applies at the stage level: `phase_1_stage_1` maps to `stages/stage-01-research-objective/`, but no documented algorithm produces this mapping.

**Impact:** The orchestrator and runtime cannot programmatically navigate from a phase/stage ID to its directory. This breaks file persistence, state loading, and artifact retrieval.

**Fix:** Add one of:
1. A `slug` or `directory_name` field to the phase/stage objects in the output schemas of `generate_phase_skeleton` and `expand_phase_to_stage_dag`.
2. A documented ID-to-slug conversion algorithm (e.g., `phase_1` -> extract number `1` -> zero-pad `01` -> slugify name -> `phase-01-research-framing`).
3. A `paths.yml` or `paths.json` mapping file in each project's `guidetree/` directory that records the ID-to-path mapping.

---

### H2: Missing `references/paths.yml`

**Referenced by:** `d:/guidetree/skills/create_project_context/SKILL.md` (line 290):
> "Must match an id in references/paths.yml templates.available_domains."

The `references/paths.yml` file does not exist anywhere in the repository. This file is referenced by the `create_project_context` skill as the authoritative source for available domain templates, but it has not been created.

**Impact:** The skill has no way to validate that a `template_id` is valid at runtime. The available domain templates can only be discovered by scanning the `references/templates/domains/` directory, but the skill cannot do this itself (it does not have filesystem access).

**Fix:** Create `references/paths.yml` with a `templates.available_domains` list that includes all 9 domain template IDs (the 8 in the enum plus `zkp-research`).

---

### H3: Template Ref Construction Depends on Undocumented Domain-Phase Resolution

**File:** `d:/guidetree/skills/orchestrate_project/SKILL.md` (lines 563-569)

For `expand_phase_to_stage_dag`, the orchestrator must construct `template_ref` with:
```yaml
template_ref:
  template_id: <from project_context>
  phase_file: <path to target phase YAML>
  rules: <path to template's rules.yaml>
```

The `phase_file` must point to the correct phase file for the target phase. For the `zkp-research` template, phase_1 maps to `references/templates/domains/zkp-research/phases/P1.yaml`. But there is no documented mapping from `phase_1` (the skill's phase ID) to `P1` (the template's phase file name).

Furthermore, the orchestrator would need to know that the project should use the `zkp-research` template (not `academic-research`) to construct the correct `phase_file` path. Without the `domain` field being propagated (see C2), this is impossible.

**Impact:** The orchestrator cannot construct correct `template_ref` inputs for downstream skills. Stage and step generation will not receive ZKP-specific guidance.

**Fix:** Define a phase-ID-to-template-file mapping convention. For example, `phase_<N>` maps to `P<N>.yaml` in the template's `phases/` directory. Document this in the orchestration rules or paths.yml.

---

## Medium Issues

### M1: Phase Name Normalization Inconsistency

**File:** `d:/guidetree/references/test-project/guidetree/phase_skeleton.json` (phases 4 and 7)
**File:** `d:/guidetree/references/templates/domains/zkp-research/guidelines.yaml` (lines 56-70)

The `recommended_phase_pattern` in guidelines.yaml uses:
- Phase 4: `"Proposed Protocol / Technique Development"` (slashes)
- Phase 7: `"Prototype / Experiment / Benchmark"` (slashes)

The phase_skeleton.json uses:
- Phase 4: `"Proposed Protocol or Technique Development"` (uses "or")
- Phase 7: `"Prototype, Experiment, and Benchmark"` (uses commas and "and")

Similarly, directory names derived from phase names will differ depending on which version of the name is used for slug generation.

**Impact:** Minor inconsistency that could cause confusion when comparing phase_skeleton output against the template's recommended pattern. Also affects directory name slug derivation.

**Fix:** Normalize phase names to match the template's `recommended_phase_pattern` exactly, or document that the skill may paraphrase template phase names as long as the semantic meaning is preserved.

---

### M2: `project.state.yaml` Has Undocumented `domain` Field

**File:** `d:/guidetree/references/test-project/guidetree/project.state.yaml` (line 5)

The project state YAML includes `domain: zero_knowledge_proof_research`, but this field is not part of the `orchestrate_project` input_schema's `project_state` definition. The orchestrator schema only defines `project_id`, `status`, `artifacts`, `current_position`, `execution_history`, `blockers`, and `operator_notes`.

**Impact:** The `domain` field will be ignored by the orchestrator if it strictly validates input against the schema. This means the ZKP domain context is lost at the orchestration layer, compounding the C2 issue.

**Fix:** Add `domain` (or `subdomain_template_id`) to the `project_state` definition in `orchestrate_project/SKILL.md`, or ensure it is propagated through `project_context` instead.

---

### M3: Missing Validation Output Artifacts

**File:** `d:/guidetree/references/test-project/guidetree/project.state.yaml` (lines 38-41)

The execution_history references `validate_phase_skeleton` and implies `validate_stage_dag` and `validate_steps` were run, but no validation output files exist in the project directory. In a real pipeline, each validate skill produces output that should be persisted as an artifact.

**Impact:** The orchestrator relies on validation results to make state assessments (e.g., `phase_skeleton_valid: true` requires a `validate_phase_skeleton` result). Without persisted validation artifacts, the orchestrator cannot re-assess state after a restart.

**Fix:** Create validation result files (e.g., `phase_skeleton_validation.json`, `stage_dag_validation.json`, `steps_validation.json`) and reference them in the project state.

---

### M4: Stage ID and Directory Name Format Mismatch

**File:** `d:/guidetree/references/test-project/guidetree/phases/phase-01-research-framing/stage_dag.json` (stage IDs: `phase_1_stage_1`, ...)
**Directory:** `stages/stage-01-research-objective/`

Stage IDs use `phase_1_stage_1` (underscores, hierarchical, no zero-padding for the stage number within the phase, no name). Directory names use `stage-01-research-objective` (hyphen, zero-padded, kebab-case name). The step IDs also differ in format: `phase_1_stage_1_step_1` vs `step-01-refine-research-question.md`.

While DIR-5 and DIR-6 in directory-conventions.md define the directory/file naming, they do not define the relationship between the ID format and the directory format.

**Impact:** Same as H1 but at the stage and step levels. Any code that needs to navigate from a step ID to its markdown file must implement an undocumented transformation.

**Fix:** Same as H1 -- add a slug/directory_name field or a documented mapping algorithm.

---

## Low Issues

### L1: `project.state.yaml` `artifacts` Section Incomplete

**File:** `d:/guidetree/references/test-project/guidetree/project.state.yaml` (lines 7-10)

The `artifacts` section only references `project_context.json`, `phase_skeleton.json`, and `phase_dependency_edges.json`. It does not reference:
- `stage_dag.json` or `stage_dependency_edges.json` (for the active phase)
- `steps.json` or `step_dependency_edges.json` (for the active stage)
- Validation result files (see M3)

The `orchestrate_project` input_schema defines `artifacts` with fields for `stage_dag`, `steps`, `step_execution_results`, etc., but these are not tracked in the project state file.

**Impact:** Minor for this dry run, but in a real pipeline, the orchestrator would not be able to locate the stage DAG or step artifacts without these references.

**Fix:** Extend the `artifacts` section to include all generated artifact paths, organized by the schema defined in `orchestrate_project/SKILL.md`.

---

### L2: Step 4 and 5 MD Files Not in Original Task Specification

**User specification:** "step-01-refine-research-question.md, step-02-identify-technical-bottleneck.md, step-03-define-success-criteria.md"
**Actual files created:** step-01 through step-05

The steps.json contains 5 steps (matching the expand_stage_to_steps output), but the user only requested 3 step MD files. Steps 4 ("Scope Arithmetization Target") and 5 ("Verify Objective Completeness") were added because they are required by the schema (verification step and handoff step per `step_policy`), but they were not in the original specification.

**Impact:** None functionally -- the additional steps make the simulation more complete.

**Fix:** No fix needed. This is a documentation note only.

---

### L3: Empty `references/` Directories

**Directories:**
- `d:/guidetree/references/test-project/guidetree/references/` (empty)
- `d:/guidetree/references/test-project/guidetree/phases/phase-01-research-framing/references/` (empty)

DIR-11 in directory-conventions.md allows these directories, but they contain no files. In a real project, these would contain reference materials (shared schemas, prior-art reports, design briefs).

**Impact:** None for a dry run. Noted for completeness.

**Fix:** No fix needed for dry run. In a real project, the prior-art table from stage 3 would be stored in the phase-level references directory.

---

### L4: Step Markdown Files Lack Template-Referenced Content

**File:** `d:/guidetree/references/test-project/guidetree/phases/phase-01-research-framing/stages/stage-01-research-objective/step-01-refine-research-question.md` (and others)

The step MD files contain structured content (objective, action, expected output, acceptance criteria, inputs, dependencies, risks) but do not reference the zkp-research domain template's specific guidance for P1.S1. The template defines outputs ("refined research question", "target technical bottleneck", "success criteria") and acceptance criteria for P1.S1, but the step files don't explicitly cite or link to these template definitions.

**Impact:** Minor. In a real pipeline, the `expand_stage_to_steps` skill would use the template_ref to guide step generation and would ideally include cross-references to the template.

**Fix:** Consider adding a `template_ref` section to step MD files that cites the relevant template phase and stage IDs (e.g., "Template: zkp-research/P1.S1").

---

## Schema Compliance Verification

| File | Schema Source | Required Fields | Compliant | Notes |
|------|--------------|-----------------|-----------|-------|
| `project_context.json` | `create_project_context` output_schema | skill, version, summary, explicit_information, inferred_information, project_context, next_action | Partial | template_id uses "academic-research" instead of "zkp-research" (see C1) |
| `phase_skeleton.json` | `generate_phase_skeleton` output_schema | skill, version, summary, project_id, phase_skeleton, phase_dependency_edges, planning_assumptions, unresolved_questions, validation_notes, next_action | Yes | All required fields present and correctly typed |
| `stage_dag.json` | `expand_phase_to_stage_dag` output_schema | skill, version, summary, project_id, phase_id, phase_name, stage_dag, stage_dependency_edges, phase_coverage, expansion_assumptions, unresolved_questions, validation_notes, next_action | Yes | All required fields present and correctly typed |
| `steps.json` | `expand_stage_to_steps` output_schema | skill, version, summary, project_id, phase_id, stage_id, stage_name, steps, step_dependency_edges, stage_coverage, execution_assumptions, unresolved_questions, validation_notes, next_action | Yes | All required fields present and correctly typed |
| `phase_dependency_edges.json` | Implied by generate_phase_skeleton | Array of [from, to] pairs | Yes | Consistent with phase.dependencies |
| `stage_dependency_edges.json` | Implied by expand_phase_to_stage_dag | Array of [from, to] pairs | Yes | Consistent with stage.dependencies |
| `step_dependency_edges.json` | Implied by expand_stage_to_steps | Array of [from, to] pairs | Yes | Consistent with step.dependencies |

---

## Template Alignment Verification

| Phase | Template (recommended_phase_pattern) | Phase Skeleton | Match |
|-------|--------------------------------------|----------------|-------|
| 1 | Research Framing and Literature Grounding | Research Framing and Literature Grounding | Exact |
| 2 | Formal Problem and Security Model Definition | Formal Problem and Security Model Definition | Exact |
| 3 | Baseline Construction and Prior-Art Comparison | Baseline Construction and Prior-Art Comparison | Exact |
| 4 | Proposed Protocol / Technique Development | Proposed Protocol or Technique Development | Minor wording |
| 5 | Security and Correctness Analysis | Security and Correctness Analysis | Exact |
| 6 | Complexity and Performance Analysis | Complexity and Performance Analysis | Exact |
| 7 | Prototype / Experiment / Benchmark | Prototype, Experiment, and Benchmark | Minor wording |
| 8 | Research Synthesis and Final Deliverable | Research Synthesis and Final Deliverable | Exact |

| Stage (P1) | Template (P1.yaml typical_stages) | Stage DAG | Match |
|------------|-----------------------------------|-----------|-------|
| P1.S1 | Research Objective Clarified | Research Objective Clarified | Exact |
| P1.S2 | ZKP Subdomain Classified | ZKP Subdomain Classified | Exact |
| P1.S3 | Prior-Art Landscape Mapped | Prior-Art Landscape Mapped | Exact |
| P1.S4 | Contribution Hypothesis Defined | Contribution Hypothesis Defined | Exact |

Research type pattern: `recursive_proof_or_folding_research` requires all 8 phases. Phase skeleton has 8 phases. Match confirmed.

---

## ID-to-Path Mapping Trace

| Level | ID Format | Directory/File Format | Mapping Mechanism |
|-------|-----------|----------------------|-------------------|
| Phase | `phase_1` | `phase-01-research-framing/` | **None documented** |
| Stage | `phase_1_stage_1` | `stage-01-research-objective/` | **None documented** |
| Step | `phase_1_stage_1_step_1` | `step-01-refine-research-question.md` | **None documented** |

The required transformation involves: (1) extracting the sequence number, (2) zero-padding it, (3) deriving a kebab-case name from the human-readable name, (4) combining with the prefix. None of these steps are documented or automated.

---

## Skill-to-Template Bridge Trace

```
create_project_context
  -> outputs project_context.template_id = "academic-research"
  -> should output "zkp-research" for this project, but enum prevents it

orchestrate_project
  -> reads project_context.template_id = "academic-research"
  -> constructs template_ref.template_id = "academic-research"
  -> loads references/templates/domains/academic-research/
  -> WRONG: should load references/templates/domains/zkp-research/

generate_phase_skeleton
  -> receives template_ref pointing to academic-research
  -> reads academic-research phases (generic), not zkp-research phases (domain-specific)
  -> generates generic phases, missing ZKP-specific guidance

expand_phase_to_stage_dag
  -> receives template_ref with phase_file pointing to academic-research/phases/P1.yaml
  -> reads generic P1 typical_stages, not ZKP-specific P1 typical_stages
  -> generates generic stages, missing folding-scheme-specific stages (folding invariant, accumulator correctness, verifier circuit cost)

expand_stage_to_steps
  -> same cascade: wrong template -> wrong guidance -> generic steps
```

The entire template bridge fails at the first step because `template_id` cannot be set to "zkp-research".

---

## Recommendations (Priority Order)

1. **Add "zkp-research" to the template_id enum** in `create_project_context/SKILL.md` (fixes C1, C2, H3).
2. **Define an ID-to-directory mapping convention** -- either add a `slug` field to phase/stage/step output schemas, or document a deterministic conversion algorithm (fixes H1, M4).
3. **Create `references/paths.yml`** with the `templates.available_domains` list (fixes H2).
4. **Add `domain` or `subdomain_template_id` to the orchestrate_project input_schema** so domain context is propagated (fixes M2).
5. **Create validation result artifact files** and reference them in the project state (fixes M3, L1).
6. **Normalize phase name wording** to match the template's recommended_phase_pattern exactly (fixes M1).
