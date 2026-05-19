Different academic research types should not mechanically apply all 7 phases. Select phases based on project type.

```yaml
research_type_patterns:
  survey_or_literature_review:
    required_phases:
      - P1: Literature Discovery and Analysis
      - P6: Paper Writing and Compilation
      - P7: Research Audit and Revision
    optional_phases:
      - P2: Idea Generation and Validation (if survey identifies open problems)
    usually_skip:
      - P3: Experiment Planning and Protocol
      - P4: Code Implementation
      - P5: Experiment Execution and Analysis
    note: >
      Survey projects focus on coverage, taxonomy, comparison, and synthesis.
      Do not fabricate experiment or implementation phases. The survey itself
      is the research contribution.

  new_idea_exploration:
    required_phases:
      - P1: Literature Discovery and Analysis
      - P2: Idea Generation and Validation
      - P3: Experiment Planning and Protocol
    optional_phases:
      - P4: Code Implementation
      - P5: Experiment Execution and Analysis
      - P6: Paper Writing and Compilation
      - P7: Research Audit and Revision
    usually_skip: []
    note: >
      Exploration projects may stop after P3 if the goal is to validate an
      idea and produce a design brief. If preliminary experiments confirm
      the idea, continue through P4-P7 for a complete paper. If the idea
      fails novelty or feasibility checks in P2, return to literature with
      a broader search rather than proceeding to implementation.

  full_research_project:
    required_phases:
      - P1: Literature Discovery and Analysis
      - P2: Idea Generation and Validation
      - P3: Experiment Planning and Protocol
      - P4: Code Implementation
      - P5: Experiment Execution and Analysis
      - P6: Paper Writing and Compilation
      - P7: Research Audit and Revision
    optional_phases: []
    usually_skip: []
    note: >
      Full research projects follow the complete pipeline. No phase may be
      skipped. The literature survey must be completed before idea generation.
      The novelty gate must be passed before implementation. The protocol must
      be written before experiments are run. The audit must be completed before
      submission.

  paper_revision:
    required_phases:
      - P6: Paper Writing and Compilation
      - P7: Research Audit and Revision
    optional_phases:
      - P4: Code Implementation (if revisions require new code)
      - P5: Experiment Execution and Analysis (if revisions require new experiments)
    usually_skip:
      - P1: Literature Discovery and Analysis (unless related work section needs major update)
      - P2: Idea Generation and Validation (unless the core contribution changes)
      - P3: Experiment Planning and Protocol (unless new experiments are needed)
    note: >
      Paper revision projects assume prior work from earlier phases exists.
      If reviewer feedback requires new experiments, include P3-P5 with the
      revised experiment plan. Do not skip the audit phase even for revisions
      — new claims require the same integrity checks as original claims.

  experiment_reproduction:
    required_phases:
      - P1: Literature Discovery and Analysis (locate original paper and related work)
      - P3: Experiment Planning and Protocol (define reproduction protocol)
      - P5: Experiment Execution and Analysis (run reproduction and compare)
    optional_phases:
      - P4: Code Implementation (if re-implementing from scratch)
      - P6: Paper Writing and Compilation (if writing a reproduction report)
      - P7: Research Audit and Revision (if publishing the reproduction study)
    usually_skip:
      - P2: Idea Generation and Validation (no new idea being proposed)
    note: >
      Reproduction studies do not propose new ideas. The goal is to verify
      whether published results can be replicated. If the original code is
      available, P4 may be simplified to a verification stage. If
      re-implementing, P4 follows the standard pipeline. Always include P3
      to define the reproduction protocol before running anything.
```
