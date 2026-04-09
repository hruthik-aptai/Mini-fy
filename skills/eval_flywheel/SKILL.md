---
name: eval_flywheel
description: Improve prompts, skills, and agent workflows with explicit success criteria, regression cases, and repeatable checks.
---

# Eval Flywheel

Use this skill when changing:

- prompts
- skills
- model routing
- tool policy
- workflow logic
- workspace guidance

## Workflow

1. Define success before editing.
2. Collect a small regression set with normal, edge, and adversarial cases.
3. Choose objective checks where possible: tests, schemas, traces, links, or exact outputs.
4. Change one variable at a time when practical.
5. Compare before and after results.
6. Keep useful failures as future regression cases.

## Guardrails

- "Looks better" is not enough.
- Calibrate automated checks with human review on ambiguous tasks.
- Use stricter acceptance criteria when the task touches money, safety, or destructive actions.
