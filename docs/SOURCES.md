# Sources

This file records the official references used to shape Mini-fy's structure and guidance.

Checked: **2026-04-09**

Mini-fy deliberately links to source material instead of mirroring it. That keeps the workspace lean, easier to maintain, and safer from licensing problems.

## OpenClaw

- [Agent Workspace](https://docs.openclaw.ai/concepts/agent-workspace)
  - Why it matters: defines which workspace files OpenClaw loads, what belongs in the workspace, and what must stay out of git.
- [Skills](https://docs.openclaw.ai/tools/skills)
  - Why it matters: defines skill loading, precedence, security notes, and format expectations.
- [Creating Skills](https://docs.openclaw.ai/tools/creating-skills)
  - Why it matters: confirms skill layout, frontmatter requirements, and best-practice guidance to stay concise.
- [Compaction](https://docs.openclaw.ai/concepts/compaction)
  - Why it matters: explains how OpenClaw keeps long conversations alive and where compaction settings belong.
- [Session Pruning](https://docs.openclaw.ai/concepts/session-pruning)
  - Why it matters: explains cache-TTL pruning, what gets pruned, and why tool-result trimming is different from compaction.
- [Prompt Caching](https://docs.openclaw.ai/reference/prompt-caching)
  - Why it matters: informs heartbeat and cache-retention guidance for cost/latency-aware setups.
- [Memory Search](https://docs.openclaw.ai/concepts/memory-search)
  - Why it matters: shows how to configure retrieval instead of stuffing durable knowledge into the prompt prefix.
- [Built-in Memory Engine](https://docs.openclaw.ai/concepts/memory-builtin)
  - Why it matters: clarifies indexing behavior for `MEMORY.md` and `memory/*.md`.
- [Security](https://docs.openclaw.ai/security)
  - Why it matters: grounds filesystem guardrails, workspace-only settings, and read-only sandbox posture.
- [Onboarding (CLI)](https://docs.openclaw.ai/start/wizard)
  - Why it matters: confirms modern onboarding flow and supports the recommendation to start conservative.
- [Personal Assistant Setup](https://docs.openclaw.ai/start/openclaw)
  - Why it matters: reinforces workspace expectations and heartbeat caution for real deployments.

## OpenAI

- [Prompting](https://platform.openai.com/docs/guides/prompting)
  - Why it matters: supports stable prompt structure, reusable prompt discipline, and concise task specification.
- [Prompt Engineering](https://platform.openai.com/docs/guides/prompt-engineering/strategies-to-improve-reliability)
  - Why it matters: reinforces precise instructions, model-aware prompting, and pinning behavior-sensitive setups.
- [Evaluation Best Practices](https://platform.openai.com/docs/guides/evaluation-best-practices)
  - Why it matters: the clearest basis here for eval-driven prompt and workflow changes.
- [Prompt Optimizer](https://platform.openai.com/docs/guides/prompt-optimizer/)
  - Why it matters: reinforces the value of dataset-backed prompt refinement over intuition alone.
- [Agent Evals](https://platform.openai.com/docs/guides/agent-evals)
  - Why it matters: useful for thinking about agent-level quality, not just one-off prompt outputs.
- [Trace Grading](https://platform.openai.com/docs/guides/trace-grading)
  - Why it matters: supports the `debug_trace` and `eval_flywheel` mindset of tracing why an agent fails.
- [Safety Best Practices](https://platform.openai.com/docs/guides/safety-best-practices/constrain-user-input-and-limit-output-tokens.pls)
  - Why it matters: supports prompt-injection caution, human oversight, and limiting unnecessary surface area.
- [Safety in Building Agents](https://platform.openai.com/docs/guides/agent-builder-safety)
  - Why it matters: supports stronger base models, approvals, guardrails, and structure around untrusted inputs.

## Anthropic

- [Be Clear, Direct, and Detailed](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/be-clear-and-direct)
  - Why it matters: reinforces explicit instructions, contextual clarity, and sequential task structure.
- [Claude 4 Prompt Engineering Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices)
  - Why it matters: supports the repo's emphasis on explicit instructions and clear task framing.
- [Define Your Success Criteria](https://docs.anthropic.com/claude/docs/empirical-performance-evaluations)
  - Why it matters: one of the strongest sources here for turning vague optimization into measurable outcomes.
- [Prompt Improver](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-improver)
  - Why it matters: useful reminder that improved prompts often trade speed for accuracy and must still be tested.
- [How to Implement Tool Use](https://docs.anthropic.com/en/docs/agents-and-tools/tool-use/implement-tool-use)
  - Why it matters: supports the repo's insistence on explicit skill and tool descriptions.
- [Reduce Prompt Leak](https://docs.anthropic.com/en/docs/test-and-evaluate/strengthen-guardrails/reduce-prompt-leak)
  - Why it matters: supports the principle that overcomplicated leak defenses can hurt performance.
- [Mitigate Jailbreaks and Prompt Injections](https://docs.anthropic.com/en/docs/test-and-evaluate/strengthen-guardrails/mitigate-jailbreaks)
  - Why it matters: supports isolating untrusted content and keeping permissions tight.
- [Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
  - Why it matters: informs the cache-aware guidance behind stable prefixes and warm-cache usage.

## Model Context Protocol

- [Specification 2025-06-18](https://modelcontextprotocol.io/specification/2025-06-18)
  - Why it matters: grounds the repo's assumptions about tools, prompts, resources, and host/server boundaries.
- [Versioning](https://modelcontextprotocol.io/specification/)
  - Why it matters: confirms the current MCP protocol version and date-based versioning model.
- [Architecture Overview](https://modelcontextprotocol.io/docs/learn/architecture)
  - Why it matters: useful for understanding where MCP sits in the agent stack.
- [Server Concepts](https://modelcontextprotocol.io/docs/learn/server-concepts)
  - Why it matters: clarifies tools, resources, and templates as separate capability types.
- [Prompts](https://modelcontextprotocol.io/specification/2025-06-18/server/prompts)
  - Why it matters: supports Mini-fy's separation of stable prompts from general context.
- [Transports](https://modelcontextprotocol.io/specification/2025-06-18/basic/transports)
  - Why it matters: useful for compatibility-aware MCP operations and protocol-version awareness.

## How To Update This File

When the repo's guidance changes:

1. Add or replace the relevant source here.
2. Update the matching entry in `data/source-index.json`.
3. Record the new check date.
4. Only promote a source into root files or skills if it changes real behavior.
