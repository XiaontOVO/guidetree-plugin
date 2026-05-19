Different experiment types do not mechanically require all 4 phases. Select
phases based on the project type.

```yaml
research_type_patterns:
  ablation_study:
    required_phases:
      - Planning and Protocol
      - Execution and Monitoring
      - Analysis and Auditing
    optional_phases:
      - Deployment
    usually_skip: []
    note: >
      Ablation studies must design variants from a reviewer perspective. If
      experiment code already exists from a prior project, Deployment may be
      minimal (sanity re-check only). The Analysis phase must include ablation
      design as a stage, and every claim-critical component must have at least
      one ablation variant with a clear success criterion. Ablation results
      must come from actual runs, never from reasoning.

  scaling_experiment:
    required_phases:
      - Planning and Protocol
      - Deployment
      - Execution and Monitoring
      - Analysis and Auditing
    optional_phases: []
    usually_skip: []
    note: >
      Scaling experiments require all 4 phases because resource requirements
      change at different scales, making deployment verification critical. The
      protocol must specify scaling dimensions (data size, model size, batch
      size, sequence length, etc.) and the schema must capture resource
      utilization metrics. OOM retry logic is especially important. The
      analysis phase must include scaling law fitting and efficiency analysis.

  reproduction_study:
    required_phases:
      - Planning and Protocol
      - Deployment
      - Execution and Monitoring
      - Analysis and Auditing
    optional_phases: []
    usually_skip: []
    note: >
      Reproduction studies need minimal P1 (protocol focuses on matching
      original conditions) but thorough P2-P4. The protocol must document the
      original experiment's configuration in detail. Deployment must verify
      environment parity. Analysis must include direct comparison with original
      results, discrepancy investigation, and reproducibility assessment.

  dse_loop:
    required_phases:
      - Planning and Protocol
      - Execution and Monitoring
      - Analysis and Auditing
    optional_phases:
      - Deployment
    usually_skip: []
    note: >
      DSE projects focus on iterative parameter search. Planning defines the
      search space and evaluation metric. Execution dispatches DSE iterations
      with the standard 7-step protocol per iteration. Analysis runs the
      three-phase DSE loop (exploration, directed search, refinement) and
      includes convergence analysis and sensitivity reporting. If experiment
      code already exists, Deployment may be minimal.

  single_run_validation:
    required_phases:
      - Planning and Protocol
      - Deployment
    optional_phases:
      - Execution and Monitoring
      - Analysis and Auditing
    usually_skip: []
    note: >
      For simple validation experiments with a single configuration and a few
      seeds, the full 4-phase pipeline may be overkill. Planning and Deployment
      are always required. Execution and Analysis can be lightweight if the
      experiment is small, but statistical rigor and integrity audit are still
      recommended.
```
