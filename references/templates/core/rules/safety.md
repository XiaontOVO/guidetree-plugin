---
rule_id: "safety-core"
rule_name: "Core Safety Rules"
description: "Safety rules that apply to all GuideTree projects regardless of domain."
enforcement: "hard"
---

# Core Safety Rules

## Rule SAFE-1: Never Fabricate

Never fabricate data, citations, experiment results, or code. If something is unknown, mark it as `[TODO]`, `[VERIFY]`, or `_STALLED_` rather than guessing.

## Rule SAFE-2: Validate Before Expanding

No artifact may be expanded (decomposed into finer granularity) until it has passed validation. Skip a gate only with explicit user approval.

## Rule SAFE-3: Evidence Required

Every claim must trace to evidence. Claims without evidence are assumptions and must be marked with confidence levels.

## Rule SAFE-4: Stop on Blockers

When a blocker is detected, stop and report. Do not silently work around blockers or fabricate a resolution.

## Rule SAFE-5: Read-Only on Source Material

When auditing or reviewing, never modify source material. Produce reports and recommendations, not edits.
