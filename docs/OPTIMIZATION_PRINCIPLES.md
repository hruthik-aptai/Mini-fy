# Optimization Principles

Mini-fy is built around a few repeatable principles rather than one giant prompt.

## 1. The Hot Path Is Sacred

OpenClaw loads root workspace files frequently. Anything in that recurring prefix must justify its cost. Short, stable instructions beat large clever monologues.

Practical implication:

- keep `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, `TOOLS.md`, and `HEARTBEAT.md` lean
- move detailed workflows into `skills/`
- move explanation into `docs/`

## 2. Curate Instead Of Copying

A giant dump of external material looks comprehensive but usually harms the agent. It increases token cost, slows comprehension, creates licensing risk, and buries the useful parts.

Mini-fy therefore prefers:

- short summaries
- structured indexes
- links back to primary sources

## 3. Stable Instructions Should Sit Before Volatile Context

Prompt-caching and bootstrap efficiency both benefit when the stable prefix is consistent and compact. Vendor docs also recommend keeping reusable static context together.

Practical implication:

- keep durable operating rules in root files
- keep changing task detail out of the baseline
- prefer a small number of high-quality skills over many overlapping ones

## 4. Use Primary Sources For Moving Facts

Anything that can drift should be verified from primary sources: official docs, specs, release notes, source repos, or standards bodies. "Latest" claims decay quickly.

Practical implication:

- verify exact dates and version numbers
- cite sources when making repo changes based on external guidance
- mark inference as inference

## 5. Prune Tool Noise, Not User Intent

OpenClaw distinguishes compaction from session pruning for a reason. User and assistant meaning should remain intact, while stale oversized tool output is fair game to trim or clear.

Practical implication:

- use `contextPruning.mode: "cache-ttl"` where supported
- keep image-heavy or non-prunable outputs out of the critical path when possible
- rely on compaction for long conversations rather than carrying full raw history forever

## 6. Heartbeat Is A Cost Tool, Not A Toy

Heartbeat can keep caches warm and reduce repeated cache writes, but unnecessary background activity is just another form of waste.

Practical implication:

- keep `HEARTBEAT.md` tiny
- only run frequent heartbeat where warm caches materially help
- disable or slow heartbeat for bursty, notifier-style agents

## 7. Memory Search Beats Prompt Hoarding

OpenClaw's memory tooling exists so durable knowledge can be retrieved instead of permanently stuffed into the live prompt.

Practical implication:

- keep durable reminders in `MEMORY.md`
- keep daily notes in git-ignored `memory/*.md` if you use this as a private workspace
- configure `memorySearch.provider` explicitly when you want predictable recall behavior

## 8. Every Optimization Needs A Verification Path

Prompt tuning without evaluation is easy to overfit. Better wording does not automatically mean better outcomes.

Practical implication:

- define success criteria before changing prompts or config
- keep a small regression set of normal, hard, and adversarial tasks
- compare before and after instead of trusting instinct

## 9. Security Boundaries Come Before Model Cleverness

OpenClaw, MCP, and vendor docs all converge on the same idea: the safest agent is one whose permissions are scoped tightly before any model decision happens.

Practical implication:

- keep filesystem scope narrow
- use workspace-only guardrails where possible
- treat plugins, MCP servers, and third-party skills as trusted only after review
- keep real secrets outside the workspace repo

## 10. Public And Private State Must Stay Separate

The public repo should hold portable knowledge. The private workspace should hold personal memory, credentials, and local conventions.

Practical implication:

- public repo = baseline
- private fork/workspace = real memory
- sync improvements selectively in both directions

## 11. Tool Descriptions And Skill Triggers Must Be Explicit

When tools or skills are vague, models waste tokens guessing. Vendor docs consistently stress clear descriptions, explicit boundaries, and sequential instructions.

Practical implication:

- give each skill one clear job
- name triggers so the agent knows when to use them
- prefer operational clarity over stylistic cleverness

## 12. Optimize For Shipped Outcomes Per Token

The right metric is not "fewest tokens possible." It is the most reliable completed work for the prompt budget you spend.

That is why Mini-fy prefers:

- small root files
- targeted skills
- explicit source discipline
- safety guardrails
- reproducible validation

The result should be a workspace that feels lighter **and** more capable.
