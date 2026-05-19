Different idea generation types should not mechanically apply all 4 phases.
Select phases based on project type.

```yaml
research_type_patterns:
  exploratory_brainstorming:
    required_phases:
      - Discovery and Brainstorming
      - Sharpening and Design
    optional_phases:
      - Novelty Verification
    usually_skip:
      - Roadmapping
    note: >
      Exploratory brainstorming focuses on generating and sharpening ideas.
      Novelty verification is optional because the goal is breadth, not
      commitment. Roadmapping is skipped unless the project explicitly
      requires an execution plan.

  targeted_idea_validation:
    required_phases:
      - Discovery and Brainstorming
      - Novelty Verification
    optional_phases:
      - Sharpening and Design
    usually_skip:
      - Roadmapping
    note: >
      Targeted validation starts from a pre-existing idea and checks whether
      it is genuinely novel. Sharpening is optional if the idea is already
      well-formed. Roadmapping is skipped unless validation passes and the
      project scope expands.

  full_idea_pipeline:
    required_phases:
      - Discovery and Brainstorming
      - Sharpening and Design
      - Novelty Verification
      - Roadmapping
    optional_phases: []
    note: >
      The full pipeline runs all four phases in order. Use when the goal is
      to take a vague direction all the way to an actionable research plan.
      Every gate must pass before advancing.

  robotics_idea:
    required_phases:
      - Discovery and Brainstorming
    optional_phases:
      - Sharpening and Design
      - Novelty Verification
      - Roadmapping
    note: >
      Robotics idea discovery uses the same Discovery and Brainstorming phase
      but with domain-specific constraints: embodiment specification, benchmark
      availability, and sim-first validation. The P1 stages are modified to
      include robotics-specific filtering criteria and problem framing.
```
