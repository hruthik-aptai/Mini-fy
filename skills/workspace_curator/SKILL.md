---
name: workspace_curator
description: Improve an OpenClaw workspace by keeping root instructions minimal, moving detail into skills, and separating public from private state.
---

# Workspace Curator

Use this skill when the task is about the workspace itself:

- root files
- memory layout
- skills
- install flow
- public template quality

## Workflow

1. Keep root bootstrap files short because they are loaded often.
2. Separate concerns cleanly:
   - `AGENTS.md` = operating rules
   - `SOUL.md` = tone and boundaries
   - `USER.md` = human preferences
   - `TOOLS.md` = machine-specific notes
   - `MEMORY.md` and `memory/*.md` = durable recall
   - `skills/*` = task-specific depth
3. Put long explanation and research notes in `docs/` or `data/` rather than the root prompt prefix.
4. Treat public templates as portable and non-secret.
5. When adding a skill, make the trigger obvious and the instructions concise.
6. Update install docs when the structure changes.

## Guardrails

- Do not turn the workspace into a generic wiki.
- Do not move local-only facts into shared skills.
- Prefer a small number of excellent skills over a huge noisy catalog.
