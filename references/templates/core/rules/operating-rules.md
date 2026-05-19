---
rule_id: "operating-rules-core"
rule_name: "Core Operating Rules"
description: "Operating rules that apply to all GuideTree projects regardless of domain."
enforcement: "hard"
---

# Core Operating Rules

## Rule OPS-1: One Skill at a Time

The orchestrator selects exactly one skill per invocation. No parallel skill execution within a single pipeline.

## Rule OPS-2: Maintain the Hierarchy

Project -> phase -> stage -> step. Never skip a level. Each level must be validated before the next is expanded.

## Rule OPS-3: Repair Is Regeneration

When validation fails, route back to the appropriate generate/expand skill with validation feedback. No separate repair skills.

## Rule OPS-4: Pipeline State Is Truth

The project state file (`project.state.yaml`) is the single source of truth for pipeline progress. Always read it before acting.

## Rule OPS-5: Cross-Model for Independence

When a fresh, independent perspective is needed (review, audit, adversarial), use a separate Agent thread with zero prior context.
