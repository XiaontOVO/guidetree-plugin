Different code-implementation project types should not mechanically apply all 5 phases. Select based on project type.
```yaml
project_type_patterns:
  greenfield_project:
    required_phases:
      - Design and Brainstorming
      - Planning
      - Implementation
      - Review
      - Integration
    optional_phases: []
    note: >
      Greenfield projects need the full pipeline. No shortcuts -- the design
      spec is the contract for everything downstream.

  feature_addition:
    required_phases:
      - Planning
      - Implementation
      - Review
      - Integration
    optional_phases:
      - Design and Brainstorming
    usually_skip: []
    note: >
      Feature additions may have a lighter design phase, but must at least
      clarify requirements and document the chosen approach. Do not skip design
      entirely unless the feature is trivially specified.

  refactoring:
    required_phases:
      - Design and Brainstorming
      - Implementation
      - Review
      - Integration
    optional_phases:
      - Planning
    usually_skip: []
    note: >
      Refactoring must define scope and behavioral preservation criteria in
      design. Planning may be lighter but must at least list the refactoring
      steps. All existing tests must pass before and after.

  prototype_spike:
    required_phases:
      - Design and Brainstorming
      - Implementation
    optional_phases:
      - Planning
    usually_skip:
      - Review
      - Integration
    note: >
      Spikes exist to learn. Define the learning goal in design, implement
      enough to answer the question, then report findings. Do not invent
      formal review or integration phases for a spike.
