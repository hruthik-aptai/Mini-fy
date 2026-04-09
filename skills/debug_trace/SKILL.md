---
name: debug_trace
description: Triage agent, tool, config, and integration failures by isolating the failing layer and verifying the fix.
---

# Debug Trace

Use this skill when something is:

- broken
- flaky
- stuck
- unexpectedly slow
- hard to explain

## Workflow

1. Reproduce the narrowest failing symptom.
2. Classify the failing layer: prompt, files, model, auth, tool policy, sandbox, network, or external service.
3. Inspect the highest-signal evidence first: exact error, logs, failing command, config diff, or trace.
4. Fix the smallest layer that explains the symptom.
5. Re-run the failing path and one nearby healthy path.
6. If the cause is still uncertain, list the leading hypotheses and what evidence would resolve them.

## OpenClaw-specific checks

- workspace path vs actual repo path
- missing or oversized bootstrap files
- skills not loading until a new session or gateway restart
- sandbox access mismatch
- caching, pruning, and compaction interactions
- memory-search provider or index state
