---
name: change_guard
description: Handle incidents and operational changes with preflight checks, blast-radius awareness, and rollback discipline.
---

# Change Guard

Use this skill when the task touches deployments, production settings, incident response, or operational fixes.

## Workflow

1. Identify the affected system and likely blast radius.
2. Record the current state before changing anything material.
3. Prefer the smallest reversible step first.
4. Run a preflight check before the change and a post-change check after it.
5. State the rollback path and remaining risk.

## Guardrails

- Do not make multiple risky changes at once without a strong reason.
- Do not skip the post-change verification.
- If the blast radius is unclear, slow down and say so.
