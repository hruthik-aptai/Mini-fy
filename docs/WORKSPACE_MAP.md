# Workspace Map

This page translates OpenClaw's workspace model into how Mini-fy uses it.

## Root Workspace Files

| File | Load behavior | What it should contain | How Mini-fy uses it |
| --- | --- | --- | --- |
| `AGENTS.md` | Loaded every session | operating rules and work habits | concise execution rules, source discipline, and safety posture |
| `SOUL.md` | Loaded every session | tone, boundaries, style | compact personality guidance without procedural bloat |
| `USER.md` | Loaded every session | who the human is and how they like to work | default assumptions for concise, outcome-oriented collaboration |
| `IDENTITY.md` | Loaded every session | agent name and self-concept | minimal identity so the workspace is legible without wasting tokens |
| `TOOLS.md` | Loaded every session | local machine/tool notes | public-safe template only; real local notes should stay non-sensitive |
| `HEARTBEAT.md` | Used by heartbeat runs | tiny background checklist | a four-line checklist designed to stay cheap |
| `BOOTSTRAP.md` | one-time setup aid | initial ritual and reminders | tells the user what to personalize, then should be deleted |
| `MEMORY.md` | optional long-term recall | durable high-value reminders | public-safe reminders about how this repo should stay structured |

## Optional High-Value Directories

| Path | Purpose | Mini-fy guidance |
| --- | --- | --- |
| `skills/` | task-specific depth | the main place for detailed workflows that should not live in the root prompt |
| `memory/` | daily memory logs | intentionally git-ignored here because this repo is public |
| `docs/` | human-readable explanation | detailed README-level guidance that the agent can open only when needed |
| `data/` | structured context | machine-readable source index for easy parsing by agents |
| `config/` | local config examples | merge snippets into `~/.openclaw/openclaw.json`; do not commit live credentials |

## What Should Stay Out Of This Repo

OpenClaw's docs are clear that real config, credentials, and sessions live under `~/.openclaw/`, not in the workspace repo.

Keep these out:

- `~/.openclaw/openclaw.json`
- auth profiles
- credentials
- session transcripts
- personal daily memory logs
- machine-specific secrets

## Why Mini-fy Splits Public And Private State

OpenClaw treats the workspace like memory. GitHub treats public repos like publication. Those two things only overlap safely when the repo is a portable template rather than the full private state of a live assistant.

That is why Mini-fy is structured as:

- public baseline in git
- private state kept elsewhere or in a private fork

## When To Put Something In A Skill Instead Of A Root File

A rule of thumb:

- If it helps on almost every turn, it may belong in a root file.
- If it only matters for a class of tasks, it belongs in a skill.
- If it is explanation for humans, it belongs in `docs/`.
- If another agent may need to parse it, it may belong in `data/`.

This is the most important structural choice in the repo.
