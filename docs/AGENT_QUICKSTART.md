# Agent Quickstart

This file is for an OpenClaw agent that has just entered the Mini-fy repo and needs a direct answer to:

- what is this repo
- what should I do first
- how do I install it
- how do I verify it
- how do I use it during normal work

## What This Repo Is

Mini-fy is a public OpenClaw workspace pack. It is not guaranteed to already be the active workspace just because it was cloned.

There are two common states:

1. **Template only**
   - the repo is cloned somewhere
   - OpenClaw may still be using a different workspace
2. **Active workspace**
   - OpenClaw is pointed at this repo path
   - the root files and skills should be live

Your first job is to determine which state applies.

## First 60 Seconds

1. Check whether this repo path matches the active OpenClaw workspace path.
2. Read `BOOTSTRAP.md` if it exists.
3. Read `AGENTS.md` and `BOOT.md`.
4. Decide whether the next step is:
   - install
   - verify
   - patch config
   - apply profile
   - personalize
   - work normally

## If This Repo Is Only A Template

### Windows

Run from the repo root:

```powershell
.\scripts\install.ps1
```

Custom target:

```powershell
.\scripts\install.ps1 -Target "C:\path\to\workspace"
```

### Unix-like

Run from the repo root:

```bash
chmod +x ./scripts/install.sh
./scripts/install.sh
```

Custom target:

```bash
./scripts/install.sh /path/to/workspace
```

### After merging

1. Merge the relevant config snippets from `config/` into `~/.openclaw/openclaw.json`.
2. Optionally apply the matching workload profile from `profiles/`.
3. Start a new session or restart the gateway.
4. Run `scripts/doctor.ps1` or `scripts/doctor.sh`.
5. Run the verification commands below.

## If This Repo Is Already The Active Workspace

Use it directly, but still verify that the environment is healthy:

```bash
./scripts/doctor.sh
openclaw skills list
openclaw status
openclaw memory status
```

If any of these fail, switch to `skills/debug_trace`.

## Verification Standard

Mini-fy should be considered correctly installed only if you can answer all of these:

- What is the active workspace path?
- Are the Mini-fy skills loaded?
- Were the config examples actually merged into live config where needed?
- Has the gateway been restarted or has a new session been started since installation?
- Is memory search healthy if the user enabled it?

## How To Use Mini-fy During Normal Work

### Use the root files for recurring behavior

- `AGENTS.md` for core operating rules
- `SOUL.md` for tone and boundaries
- `USER.md` for collaboration preferences
- `TOOLS.md` for local notes
- `HEARTBEAT.md` for background checks
- `MEMORY.md` for durable public-safe reminders

### Use the skills for task-specific depth

- `latest_primary_sources` for fresh facts and version drift
- `lean_context` for token discipline
- `eval_flywheel` for prompt or workflow tuning
- `debug_trace` for failures and flakiness
- `workspace_curator` for improving the workspace itself

### Use the docs when you need explicit guidance

- `docs/INSTALL.md` for human-facing installation detail
- `docs/PROFILES.md` for workload-specific profile guidance
- `docs/VERIFICATION.md` for doctor-script and verification guidance
- `docs/EVALS.md` for benchmark and regression workflow
- `docs/WORKSPACE_MAP.md` for file placement decisions
- `docs/OPTIMIZATION_PRINCIPLES.md` for repo philosophy
- `docs/SOURCES.md` and `data/source-index.json` for official source grounding

## How To Report Status To The Human

Prefer a short explicit status:

- `Mini-fy is only cloned; it is not yet the active workspace.`
- `Mini-fy is installed into the active workspace, but verification is still pending.`
- `Mini-fy is installed and verified; the loaded skills and workspace path match expectations.`

Avoid vague statements like "it should be working."

## If You Need To Improve The Repo

1. Keep root files short.
2. Put deeper process into `skills/` or `docs/`.
3. Update `docs/SOURCES.md` and `data/source-index.json` if external guidance changed.
4. Preserve capability while reducing noise.
