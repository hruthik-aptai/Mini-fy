# Mini-fy

Mini-fy is a public, portability-first OpenClaw workspace pack built to make agents faster, leaner, and more reliable without cutting away core capability.

This repository is intentionally **not** a mirror of "the whole internet." That would be a bad OpenClaw workspace for three reasons:

1. It would be legally messy.
2. It would explode prompt size and reduce efficiency.
3. Most external material is low-signal compared with a curated set of primary sources plus tight operating instructions.

Instead, Mini-fy packages the things OpenClaw can actually ingest and use well:

- Root workspace files that OpenClaw loads every session
- A small skill pack for high-value workflows
- Config snippets for cost, latency, memory, and safety tuning
- A machine-readable source index
- Public docs that point back to official sources

The goal is simple: **increase shipped outcomes per token, per minute, and per context window**.

## What This Repo Optimizes

- Faster agent startup by keeping root instruction files small and purposeful
- Better factual reliability by pushing the agent toward primary-source verification
- Lower token waste by moving detailed process into skills and docs instead of bloating the session prefix
- Better long-session behavior through pruning, compaction, heartbeat, and memory-search guidance
- Safer operation by separating public template content from private OpenClaw state
- Better iteration quality by making evals and verification a first-class part of prompt and workspace changes

## What This Repo Does Not Do

- It does not scrape or republish copyrighted docs wholesale
- It does not ship secrets, auth state, transcripts, or `~/.openclaw/` internals
- It does not assume one model vendor is always best
- It does not "optimize" by stripping away functionality the agent still needs
- It does not turn the workspace into a giant wiki that costs more to load than it helps

## Why The Layout Looks Like This

OpenClaw's own documentation says the workspace files that matter most are `AGENTS.md`, `SOUL.md`, `USER.md`, `IDENTITY.md`, `TOOLS.md`, `HEARTBEAT.md`, `MEMORY.md`, and `skills/`. Those are the surfaces the agent sees often, so Mini-fy keeps them sharp and compact.

Everything that is useful but not worth paying for every turn lives outside that hot path:

- `docs/` for human-readable explanation
- `data/` for machine-readable source indexing
- `config/` for merge-in examples
- `scripts/` for installing into an existing workspace

That separation is the core design choice of this repo.

## Repo Map

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Main operating instructions for the agent |
| `SOUL.md` | Tone, persona, and behavioral boundaries |
| `USER.md` | Default assumptions about the human collaborator |
| `IDENTITY.md` | Minimal self-description for the workspace pack |
| `TOOLS.md` | Local-tool template for machine-specific notes |
| `HEARTBEAT.md` | Tiny low-cost checklist for heartbeat runs |
| `BOOT.md` | Always-on startup checklist for agents entering the workspace |
| `BOOTSTRAP.md` | One-time setup ritual; delete after personalization |
| `MEMORY.md` | Public-safe long-term reminders for this workspace |
| `CONTRIBUTING.md` | Rules for keeping the repo lean, source-backed, and useful |
| `SECURITY.md` | Public-repo security policy and secret-handling guidance |
| `skills/` | Task-specific depth that should not live in the root prompt |
| `config/` | Example `openclaw.json` snippets to merge into local config |
| `docs/` | Detailed install notes, design rationale, and source notes |
| `data/source-index.json` | Machine-readable map of official references used here |
| `scripts/install.ps1` | Safe Windows installer for merging this into an existing workspace |
| `scripts/install.sh` | Safe Unix-like installer for merging this into an existing workspace |
| `scripts/doctor.ps1` | Windows verification script for active-workspace detection and OpenClaw health checks |
| `scripts/doctor.sh` | Unix-like verification script for active-workspace detection and OpenClaw health checks |

## If You Are The Agent

If an OpenClaw agent opens this repo and needs to know what to do next, the intended order is:

1. Read `AGENTS.md`
2. Read `BOOT.md`
3. Read `BOOTSTRAP.md` if it still exists
4. Use `docs/AGENT_QUICKSTART.md` for the exact install vs verify workflow
5. Confirm whether this repo is the active workspace or only a cloned template
6. Run `scripts/doctor.ps1` or `scripts/doctor.sh`
7. Verify with `openclaw skills list`, `openclaw status`, and `openclaw memory status` when OpenClaw is available

That flow is now encoded directly into the root workspace files so the next agent has less ambiguity.

## Exact Agent Decision Tree

If you are an OpenClaw agent that just pulled or opened this repo, do not assume cloning equals installation.

Your first task is to classify the current state:

### State A: Template Only

This means:

- the repo exists on disk
- but OpenClaw may still be using a different workspace

In this state, the next action is:

1. tell the human this repo is only cloned
2. install it into the real workspace with:
   - `.\scripts\install.ps1` on Windows
   - `./scripts/install.sh` on Unix-like systems
3. merge the relevant snippets from `config/` into `~/.openclaw/openclaw.json`
4. restart the gateway or start a new session
5. run `scripts/doctor.ps1` or `scripts/doctor.sh`
6. run verification

### State B: Active Workspace

This means:

- OpenClaw is already pointed at this repo path
- the root files and skills should be live

In this state, the next action is:

1. read `BOOT.md`
2. read `BOOTSTRAP.md` if it still exists
3. run `scripts/doctor.ps1` or `scripts/doctor.sh`
4. verify the environment
5. report whether setup is complete or still missing config / restart steps

### State C: Installed But Not Verified

This means:

- Mini-fy has been copied into the workspace
- but no one has yet confirmed the skills, memory, and active path

In this state, run:

```bash
./scripts/doctor.sh
openclaw skills list
openclaw status
openclaw memory status
```

Then report one of these exact outcomes:

- `Mini-fy is only cloned; it is not yet the active workspace.`
- `Mini-fy is installed into the active workspace, but verification is still pending.`
- `Mini-fy is installed and verified; the loaded skills and workspace path match expectations.`

## Exact Installation Flow

Use this sequence when you want Mini-fy to become a real working workspace rather than just a GitHub clone.

### Fresh Workspace Flow

1. Clone the repo.
2. Point OpenClaw's workspace setting at the clone path.
3. Run `openclaw setup --workspace <that-path>`.
4. Merge the relevant `config/` examples into `~/.openclaw/openclaw.json`.
5. Restart the gateway or begin a new session.
6. Run the doctor script.
7. Verify the setup.

### Existing Workspace Flow

1. Run the platform installer from the repo root.
2. Let the installer back up conflicting files.
3. Merge the relevant `config/` examples into `~/.openclaw/openclaw.json`.
4. Restart the gateway or begin a new session.
5. Run the doctor script.
6. Verify the setup.

### Verification Commands

These are the minimum commands that should be run after installation:

```bash
./scripts/doctor.sh
openclaw skills list
openclaw status
openclaw memory status
openclaw agent --message "What workspace files are loaded every session?"
```

The setup should not be called complete until you can answer:

- What is the active workspace path?
- Are the Mini-fy skills loaded?
- Were the config examples actually merged where needed?
- Was the gateway restarted or a new session started?
- Is memory healthy if enabled?

## Exact Normal-Use Playbook

Once Mini-fy is installed and verified, use it like this:

### For recurring behavior

Read and obey:

- `AGENTS.md`
- `SOUL.md`
- `USER.md`
- `TOOLS.md`
- `HEARTBEAT.md`
- `MEMORY.md`

### For task-specific behavior

Use:

- `skills/latest_primary_sources` for fresh facts and version-sensitive work
- `skills/lean_context` for noisy or long sessions
- `skills/eval_flywheel` for tuning prompts, workflows, or config
- `skills/debug_trace` for failures, flakiness, or unexplained slowness
- `skills/workspace_curator` for improving the workspace itself

### For explanation and maintenance

Read:

- `docs/AGENT_QUICKSTART.md`
- `docs/INSTALL.md`
- `docs/VERIFICATION.md`
- `docs/WORKSPACE_MAP.md`
- `docs/OPTIMIZATION_PRINCIPLES.md`
- `docs/SOURCES.md`
- `data/source-index.json`

## What An Agent Should Never Assume

- Pulling the repo automatically makes it the active workspace.
- Example config files are already merged into live config.
- Skills are loaded without a new session or gateway restart.
- A public template repo should contain secrets or private memory.
- Bigger prompt context is automatically better.

## Quick Start

You have two good ways to use Mini-fy.

### Option A: Use It As A Fresh Workspace Template

This is the cleanest approach if you want a dedicated OpenClaw workspace.

```bash
git clone https://github.com/hruthik-aptai/Mini-fy.git ~/Mini-fy
```

Point OpenClaw at the clone by merging the relevant snippet from `config/openclaw.efficient.example.jsonc` into `~/.openclaw/openclaw.json`, then run:

```bash
openclaw setup --workspace ~/Mini-fy
openclaw skills list
```

Recommended next steps:

1. Personalize `USER.md`, `TOOLS.md`, and `HEARTBEAT.md`
2. Choose memory-search and model settings from `config/`
3. Start a new session or restart the gateway so the skills load
4. Delete `BOOTSTRAP.md` once setup is complete

### Option B: Merge It Into An Existing Workspace

If you already have a working OpenClaw workspace and want to layer Mini-fy on top:

Windows PowerShell:

```powershell
.\scripts\install.ps1
```

Unix-like shell:

```bash
./scripts/install.sh
```

Both installers:

- create timestamped backups of conflicting files or folders
- copy Mini-fy's portable files into the target workspace
- leave `~/.openclaw/` credentials and session state alone

By default, the target is `~/.openclaw/workspace`.

## Public Repo Safety Model

OpenClaw's official docs recommend treating the real workspace as private memory. That advice is right. A **public** workspace repo should stay portable and non-sensitive.

This repo is therefore designed as a **public template / shared baseline**, not as a place to commit your actual private memory.

If you want to turn this into your real workspace:

1. Prefer making a private fork.
2. Keep daily logs under `memory/` ignored by git.
3. Never commit `~/.openclaw/openclaw.json`, auth profiles, credentials, or session transcripts.
4. Keep machine-specific secrets out of `TOOLS.md`.

## The Core Operating Philosophy

Mini-fy is opinionated about how to improve agent efficiency:

### 1. Curate, Don't Hoard

The best workspace is not the largest one. It is the one that exposes the highest-value instructions and references with the lowest token overhead.

### 2. Stable Prefix, Deep On Demand

Everything loaded every session should be short. Deeper process belongs in skills, docs, and structured data that the agent can read only when needed.

### 3. Primary Sources Over Lore

If a fact can drift, verify it against an official source. If a recommendation is expensive or risky, prefer vendor docs, standards, release notes, or source repos over forum hearsay.

### 4. Efficiency Without Capability Loss

Mini-fy avoids "optimizations" that are just disguised amputations. The target is better execution density, not less functionality.

### 5. Eval-Driven Changes

Prompt, skill, and config changes should be judged with concrete success criteria and regression checks, not vibe.

### 6. Security Before Cleverness

Treat plugins, MCP servers, third-party skills, and untrusted content as risk boundaries. Put access control, sandboxing, and approval discipline ahead of model improvisation.

## Included Skills

Mini-fy ships five focused skills instead of a giant noisy catalog:

| Skill | What it is for |
| --- | --- |
| `latest_primary_sources` | Fresh facts, release notes, version drift, and "latest" research tasks |
| `lean_context` | Long or noisy sessions where token/latency discipline matters |
| `eval_flywheel` | Prompt, skill, config, or workflow changes that need repeatable validation |
| `debug_trace` | Broken, flaky, slow, or confusing agent/tool behavior |
| `workspace_curator` | Improving the workspace itself without bloating the root prompt |

Each skill is concise on purpose. Trigger clarity matters more than clever wording.

## Included Config Snippets

The `config/` folder contains merge-in examples for common tuning patterns:

- `openclaw.efficient.example.jsonc`
  - lean bootstrap limits
  - heartbeat keep-warm
  - cache TTL pruning
  - explicit compaction model
  - baseline cache-retention guidance
- `openclaw.heartbeat.example.jsonc`
  - mixed-traffic heartbeat pattern
  - disable warm-cache behavior for bursty notifier-style agents
- `openclaw.memory.example.jsonc`
  - explicit memory-search provider selection
  - reminder to verify the memory index
- `openclaw.secure-baseline.example.jsonc`
  - workspace-only filesystem guardrails
  - read-only sandbox example

These are deliberately examples, not copy-paste gospel. Merge the parts that fit your OpenClaw version and deployment model.

## How This Repo Tries To Reduce Cost And Latency

Mini-fy bakes in several patterns pulled from official docs and generalized for a workspace:

- Keep root files short so the session prefix stays cheap and cache-friendly
- Put stable instructions before volatile task context
- Use heartbeat only where warm caches actually help
- Use cache-TTL pruning to avoid re-caching oversized stale tool output
- Use compaction for long chats instead of carrying the full raw history forever
- Use memory search for recall instead of stuffing everything into the live prompt
- Prefer structured source indexes and targeted lookups over re-reading large prose blocks

## Source Strategy

Mini-fy is backed by official documentation from:

- OpenClaw
- OpenAI
- Anthropic
- Model Context Protocol

Human-readable source notes live in `docs/SOURCES.md`.

Machine-readable equivalents live in `data/source-index.json`.

This matters because another agent can parse the JSON index while a human can audit the Markdown version quickly.

## Recommended Workflow For Improving This Repo Over Time

If you keep evolving Mini-fy, this loop works well:

1. Add a new source only if it changes behavior, quality, safety, or cost in a meaningful way.
2. Distill the lesson into the smallest useful workspace artifact.
3. Decide whether it belongs in:
   - root instructions
   - a skill
   - docs
   - config
   - structured data
4. Keep the hot path lean.
5. Validate the change with a small regression set or operational smoke test.
6. Update `docs/SOURCES.md` and `data/source-index.json` when the repo's guidance changes.

## Suggested Validation After Cloning

Run the following after wiring Mini-fy into your environment:

```bash
openclaw skills list
openclaw status
openclaw memory status
openclaw agent --message "What workspace files are loaded every session?"
```

You want to confirm:

- the workspace points to the expected path
- the bundled skills appear
- memory search is healthy if you enabled it
- the agent can describe the repo's structure accurately

## Why The README Is Detailed But The Root Prompt Files Are Not

This README is for humans and public GitHub visitors.

The root workspace files are for a running agent that pays for every extra byte of recurring context.

That is why the README is intentionally much more detailed than `AGENTS.md`, `SOUL.md`, or `USER.md`. The design is asymmetric on purpose.

## Best Pairing With Real Usage

The best practical setup is often:

1. Keep this public repo as the clean portable baseline.
2. Create a private fork or private sibling workspace for personal memory and secrets.
3. Periodically cherry-pick useful public improvements back and forth.

That gives you a strong public template without turning your real assistant memory into public Git history.

## Official Sources Used

The repo's current guidance was checked on **2026-04-09** against official sources. Start with:

- [OpenClaw Agent Workspace](https://docs.openclaw.ai/concepts/agent-workspace)
- [OpenClaw Skills](https://docs.openclaw.ai/tools/skills)
- [OpenClaw Creating Skills](https://docs.openclaw.ai/tools/creating-skills)
- [OpenClaw Session Pruning](https://docs.openclaw.ai/concepts/session-pruning)
- [OpenClaw Compaction](https://docs.openclaw.ai/concepts/compaction)
- [OpenClaw Security](https://docs.openclaw.ai/security)
- [OpenAI Prompting Guide](https://platform.openai.com/docs/guides/prompting)
- [OpenAI Evaluation Best Practices](https://platform.openai.com/docs/guides/evaluation-best-practices)
- [Anthropic Claude 4 Prompt Best Practices](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/claude-4-best-practices)
- [Model Context Protocol Specification](https://modelcontextprotocol.io/specification/2025-06-18)

The fuller list is in [`docs/SOURCES.md`](./docs/SOURCES.md).

## License

MIT. See [`LICENSE`](./LICENSE).
