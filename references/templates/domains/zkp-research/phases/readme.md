choose the pattern depend on the actual research.
```yaml
research_type_patterns:
  survey_or_literature_review:
    required_phases:
      - Research Framing and Literature Grounding
      - Baseline Construction and Prior-Art Comparison
      - Research Synthesis and Final Deliverable
    optional_phases:
      - Formal Problem and Security Model Definition
      - Complexity and Performance Analysis
    usually_skip:
      - Proposed Protocol or Technique Development
      - Prototype, Experiment, and Benchmark
    note: >
      Survey project重点是覆盖、分类、比较、归纳，不要伪造协议开发阶段。

  new_protocol_construction:
    required_phases:
      - Research Framing and Literature Grounding
      - Formal Problem and Security Model Definition
      - Baseline Construction and Prior-Art Comparison
      - Proposed Protocol or Technique Development
      - Security and Correctness Analysis
      - Complexity and Performance Analysis
      - Research Synthesis and Final Deliverable
    optional_phases:
      - Prototype, Experiment, and Benchmark
    note: >
      新协议必须有 formal model 和 security analysis。没有这两个就不是合格协议研究。

  protocol_optimization:
    required_phases:
      - Research Framing and Literature Grounding
      - Baseline Construction and Prior-Art Comparison
      - Proposed Protocol or Technique Development
      - Security and Correctness Analysis
      - Complexity and Performance Analysis
      - Prototype, Experiment, and Benchmark
      - Research Synthesis and Final Deliverable
    optional_phases:
      - Formal Problem and Security Model Definition
    note: >
      优化类项目必须证明没有破坏原协议安全性质，并且必须有公平 baseline。

  implementation_benchmark:
    required_phases:
      - Research Framing and Literature Grounding
      - Baseline Construction and Prior-Art Comparison
      - Complexity and Performance Analysis
      - Prototype, Experiment, and Benchmark
      - Research Synthesis and Final Deliverable
    optional_phases:
      - Formal Problem and Security Model Definition
      - Security and Correctness Analysis
    note: >
      如果只是 benchmark，不要假装提出新 cryptographic construction。

  security_analysis_or_audit:
    required_phases:
      - Research Framing and Literature Grounding
      - Formal Problem and Security Model Definition
      - Baseline Construction and Prior-Art Comparison
      - Security and Correctness Analysis
      - Research Synthesis and Final Deliverable
    optional_phases:
      - Complexity and Performance Analysis
    note: >
      安全分析项目的主线是 model、assumption、proof obligation、gap，不是性能。

  arithmetization_research:
    required_phases:
      - Research Framing and Literature Grounding
      - Formal Problem and Security Model Definition
      - Baseline Construction and Prior-Art Comparison
      - Proposed Protocol or Technique Development
      - Complexity and Performance Analysis
      - Prototype, Experiment, and Benchmark
      - Research Synthesis and Final Deliverable
    optional_phases:
      - Security and Correctness Analysis
    note: >
      重点关注 constraint count、degree、lookup usage、witness generation、prover overhead。

  recursive_proof_or_folding_research:
    required_phases:
      - Research Framing and Literature Grounding
      - Formal Problem and Security Model Definition
      - Baseline Construction and Prior-Art Comparison
      - Proposed Protocol or Technique Development
      - Security and Correctness Analysis
      - Complexity and Performance Analysis
      - Prototype, Experiment, and Benchmark
      - Research Synthesis and Final Deliverable
    note: >
      必须显式处理 accumulation/folding invariant、recursive verifier cost、cycle/field constraints。