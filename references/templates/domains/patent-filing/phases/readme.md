Different patent filing types; do not mechanically apply all 5 phases. Select by project type.
```yaml
research_type_patterns:
  cn_patent:
    required_phases:
      - Prior Art and Novelty
      - Invention Structuring
      - Claim Drafting
      - Specification Writing
      - Review and Jurisdiction Formatting
    optional_phases: []
    note: >
      CN patent: two-part claims mandatory, Song Ti/Hei Ti fonts, patent
      request form. Novelty under Art 22 CNPL, obviousness under Art 22.3.
      Absolute novelty standard: any public disclosure before priority date
      destroys novelty.

  us_patent:
    required_phases:
      - Prior Art and Novelty
      - Invention Structuring
      - Claim Drafting
      - Specification Writing
      - Review and Jurisdiction Formatting
    optional_phases: []
    note: >
      US patent: open claims with "comprising", "FIG. N" numbering, inventor's
      oath/declaration, ADS. Novelty under 35 USC 102, obviousness under 35
      USC 103 (Graham factors). Best mode disclosure required.

  ep_patent:
    required_phases:
      - Prior Art and Novelty
      - Invention Structuring
      - Claim Drafting
      - Specification Writing
      - Review and Jurisdiction Formatting
    optional_phases: []
    note: >
      EP patent: mandatory two-part claim form per EPC Guidelines, reference
      signs list, designation of contracting states, EPO Form 1001. Novelty
      under Art 54 EPC, obviousness under Art 56 EPC (problem-and-solution
      approach). Strict on functional claim language (Art 84 EPC).

  provisional_filing:
    required_phases:
      - Prior Art and Novelty
      - Invention Structuring
      - Claim Drafting
    optional_phases:
      - Specification Writing
      - Review and Jurisdiction Formatting
    usually_skip:
      - full jurisdiction formatting
    note: >
      Provisional applications require less formality but must still have at
      least one claim and adequate written description for priority claim.
      P4 may be simplified. P5 jurisdiction formatting is usually not needed
      but a basic review is recommended. Do not skip P1-P3 -- the priority
      date only protects what is adequately disclosed.
```
