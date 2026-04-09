---
name: lean_context
description: Keep long sessions fast and cheap by shrinking prompt surface, batching work, and avoiding low-value context.
---

# Lean Context

Use this skill when:

- the session is long
- tool output is noisy
- the task is broad
- the human explicitly cares about efficiency, latency, or cost

## Workflow

1. Read only the files and sections needed for the next decision.
2. Batch independent reads or lookups.
3. Summarize before exploring further so the next step starts from compact context.
4. Prefer structured files and indexes over re-reading long prose.
5. Move reusable detail into skills, docs, or data rather than bloating root bootstrap files.
6. Recommend cache-friendly settings such as heartbeat keep-warm, cache-TTL pruning, and stable prefixes when the provider supports them.

## Guardrails

- Preserve capability. Do not delete context the task still needs.
- Do not optimize on token count alone; optimize for shipped results per token.
- If removing detail may change behavior, add a verification step.
