---
rule_id: "directory-conventions"
rule_name: "Directory Structure Conventions"
description: "Rules for the output directory tree structure with phases/ and stages/ intermediate directories"
enforcement: "hard"
---

1. **DIR-1**: Root is always `<project-root>/guidetree/`. All GuideTree artifacts, state files, and generated content reside within this directory. No artifacts are written outside the guidetree root.

2. **DIR-2**: All phase directories are grouped under `phases/`. This allows project-level reference files (e.g., `guidetree/references/`) to sit alongside the phases directory.

3. **DIR-3**: Phase directories use format `phases/phase-<NN>-<name>/` where `NN` is a zero-padded phase number and `name` is `snake_case`. Examples: `phases/phase-01-literature/`, `phases/phase-02-idea-generation/`.

4. **DIR-4**: All stage directories within a phase are grouped under `stages/`. This allows phase-level reference files (e.g., `phases/phase-01-literature/references/`) to sit alongside the stages directory.

5. **DIR-5**: Stage directories use format `stages/stage-<NN>-<name>/` under their parent phase's `stages/` directory. `NN` is zero-padded within the phase. Examples: `stages/stage-01-discovery/`, `stages/stage-02-analysis/`.

6. **DIR-6**: Step files use format `step-<NN>-<name>.md` directly inside their parent stage directory. `NN` is zero-padded within the stage. Examples: `step-01-search-zotero.md`, `step-02-search-external.md`.

7. **DIR-7**: State files (`project.state.yaml`, `phase.state.yaml`, `stage.state.yaml`) track the current position and status at each level. These are the authoritative source of truth for pipeline state.

8. **DIR-8**: Artifact files (JSON) store structured, machine-readable data. Step files (MD) store human-readable instructions, objectives, and verification criteria.

9. **DIR-9**: Domain templates may override naming conventions but must preserve the tree structure: `guidetree/` -> `phases/` -> `phase-*/` -> `stages/` -> `stage-*/` -> `step-*.md`.

10. **DIR-10**: The orchestrator resolves all paths relative to `<project-root>/guidetree/`. All path references in artifacts must be relative paths from this root.

11. **DIR-11**: Each `phase-*/` directory may contain a `references/` subdirectory for phase-level reference files (e.g., design briefs, prior art reports). The `guidetree/` root may contain a `references/` directory for project-level reference files (e.g., shared schemas, project-wide rules).
