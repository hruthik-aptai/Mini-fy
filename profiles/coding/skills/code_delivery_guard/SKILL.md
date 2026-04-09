---
name: code_delivery_guard
description: Ship code changes with small diffs, explicit verification, and clear residual-risk reporting.
---

# Code Delivery Guard

Use this skill when the task changes source code, tests, build configuration, or deployment logic.

## Workflow

1. Inspect the relevant code paths before editing.
2. Identify the smallest change set that can solve the task.
3. Choose a verification path before you patch.
4. Update tests or add a reproducible smoke check when behavior changes.
5. Report what changed, how it was verified, and what still carries risk.

## Guardrails

- Do not rewrite unrelated parts of the codebase.
- Do not claim success without running a check or stating why you could not.
- If a change is risky or hard to reverse, say so before shipping.
