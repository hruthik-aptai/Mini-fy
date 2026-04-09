---
name: openclaw_cli_runtime
description: Operate, verify, and troubleshoot Mini-fy specifically in an OpenClaw terminal / CLI environment.
---

# OpenClaw CLI Runtime

Use this skill when the task is specifically about running Mini-fy inside the OpenClaw terminal / CLI environment.

## Workflow

1. Assume terminal-first operation.
2. Prefer `openclaw` commands over generic UI guidance.
3. Determine whether the repo is only cloned, installed, or actively configured.
4. Use `scripts/doctor.ps1` or `scripts/doctor.sh` for workspace-level verification.
5. Use `scripts/openclaw_snapshot.ps1` or `scripts/openclaw_snapshot.sh` for a quick CLI health snapshot.
6. Report results as exact commands plus exact observed state.

## Core Commands

- `openclaw status`
- `openclaw skills list`
- `openclaw memory status`
- `openclaw sandbox explain`
- `openclaw setup --workspace <path>`

## Guardrails

- Do not describe Mini-fy as active unless the CLI checks support that.
- Do not assume GUI-based setup paths in a terminal-first environment.
- If `openclaw` is missing from `PATH`, say so explicitly and fall back to static checks.
