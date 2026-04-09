# Verification

Mini-fy is strongest when it can prove what state it is in.

That means answering:

- Is this repo only cloned, or is it the active OpenClaw workspace?
- Are the expected Mini-fy files actually present?
- Are the skills visible to OpenClaw?
- Has OpenClaw been restarted or given a fresh session since install?
- Is memory healthy if memory search is enabled?

## One-Command Verification

### Windows

```powershell
.\scripts\doctor.ps1
```

### Unix-like

```bash
./scripts/doctor.sh
```

Both scripts:

- inspect the workspace under test
- check for the expected Mini-fy files
- try to detect the configured OpenClaw workspace from `~/.openclaw/openclaw.json`
- classify whether Mini-fy matches the active workspace
- run `openclaw skills list`, `openclaw status`, and `openclaw memory status` when the CLI is available

For repo-level validation rather than workspace-only validation, use:

- `scripts/selftest.ps1`
- `scripts/selftest.sh`

## Interpreting Results

### Good result

You want to see:

- expected files present
- Mini-fy matches the configured active workspace
- `openclaw skills list` succeeds
- `openclaw status` succeeds

### Common warnings

`Mini-fy is not the configured active workspace`

- The repo is probably just cloned and not yet installed into the real workspace.

`BOOTSTRAP.md still exists`

- One-time setup may still be pending.

`OpenClaw CLI is not on PATH`

- The static repo checks still worked, but live OpenClaw command checks were skipped.

## After Installation

The installers now try to run the doctor automatically when OpenClaw is available.

That means a good install flow is:

1. run the installer
2. let it copy files and make backups
3. let it run the doctor
4. merge any needed `config/` snippets
5. restart OpenClaw or begin a new session
6. run the doctor again if you changed config after the install

## Minimum Manual Verification Commands

If you want to verify without the doctor scripts:

```bash
openclaw skills list
openclaw status
openclaw memory status
openclaw agent --message "What workspace files are loaded every session?"
```

## Practical Standard

Mini-fy should only be described as fully active when:

1. the configured workspace path matches the intended Mini-fy path
2. the expected root files exist
3. the Mini-fy skill files exist
4. OpenClaw command checks pass
5. the human has been told whether setup is complete or still pending
