Different literature review subtypes do not all need the same 5 phases. Select phases based on the review type.

```yaml
research_type_patterns:
  quick_survey:
    required_phases:
      - Paper Discovery and Search
      - Reading and Triage
    optional_phases:
      - Deep Analysis (shallow: core findings and project relevance only)
      - Library Management and Maintenance (abbreviated)
    usually_skip:
      - Comparison and Synthesis
    note: >
      Quick survey focuses on breadth over depth. Triage is the primary reading
      mechanism. Deep analysis, if any, is shallow — covering only core findings
      and project relevance without full five-dimension scoring. Do not invent
      systematic review rigor for a quick survey.

  systematic_review:
    required_phases:
      - Paper Discovery and Search
      - Reading and Triage
      - Deep Analysis
      - Comparison and Synthesis
      - Library Management and Maintenance
    optional_phases: []
    usually_skip: []
    note: >
      Systematic review requires all five phases with rigorous acceptance
      standards. Search protocol must be documented with inclusion/exclusion
      criteria. Triage must follow explicit criteria. Deep analysis must use
      full five-dimension scoring. Comparison must produce a complete matrix.
      Library audit must be thorough. Do not abbreviate any phase.

  gap_analysis:
    required_phases:
      - Paper Discovery and Search
      - Deep Analysis
      - Comparison and Synthesis
    optional_phases:
      - Library Management and Maintenance
    usually_skip:
      - Reading and Triage (may be abbreviated; analysis focuses on identifying limitations)
    note: >
      Gap analysis emphasizes broad discovery (P1), deep analysis focused on
      limitations and missing work (P3), and gap-focused comparison (P4).
      Triage (P2) may be abbreviated because the goal is to find what is
      missing, not to comprehensively read everything. The comparison matrix
      should explicitly highlight gaps per dimension.

  literature_update:
    required_phases:
      - Paper Discovery and Search
      - Reading and Triage
      - Library Management and Maintenance
    optional_phases:
      - Deep Analysis (only for papers that change prior conclusions)
      - Comparison and Synthesis (only if new papers significantly alter the landscape)
    usually_skip: []
    note: >
      Literature update checks for new work since a prior review. Focus on P1
      (searching for new papers since the cutoff date) and P2 (triaging new
      papers against the existing review). Skip P3-P4 if new papers do not
      change prior conclusions. Always update the library (P5) with new
      additions. Do not re-analyze papers already covered in the prior review.
```
