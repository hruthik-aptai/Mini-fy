---
name: latest_primary_sources
description: Verify current external facts with primary sources, exact dates, and explicit citations before relying on them.
---

# Latest Primary Sources

Use this skill when the task depends on anything that can drift:

- versions
- model behavior
- prices
- schedules
- laws
- release status
- security guidance
- "latest" claims

## Workflow

1. Start with the narrowest official source that can answer the question.
2. Capture exact dates, version numbers, and model IDs.
3. If recency or authority is ambiguous, compare at least two primary sources.
4. Separate sourced facts from your own inference.
5. Cite links in the answer or repo update.
6. Prefer short paraphrase over long quotation.

## Guardrails

- Do not treat forum posts or SEO blogs as authoritative when a primary source exists.
- Do not mirror large copyrighted material into the workspace.
- If you cannot verify the fact, say so clearly and state what is missing.
