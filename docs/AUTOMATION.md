# Automation

Mini-fy now includes one-command bootstrap flows and a machine-readable manifest so another agent does not have to infer the intended sequence from prose alone.

## Machine-Readable Manifest

Use:

- `data/agent-manifest.json`

It records:

- the intended first-read order
- the workspace state model
- the important scripts
- the available profiles
- the verification commands

This is useful when another agent wants a compact structured view of the repo before opening multiple Markdown files.

## One-Command Bootstrap

### Fresh mode

Use when the clone itself should become the active workspace.

#### Windows

```powershell
.\scripts\bootstrap_workspace.ps1 -Mode fresh
```

#### Unix-like

```bash
./scripts/bootstrap_workspace.sh --mode fresh
```

### Merge mode

Use when Mini-fy should be copied into an existing workspace path.

#### Windows

```powershell
.\scripts\bootstrap_workspace.ps1 -Mode merge -Target "$HOME\.openclaw\workspace"
```

#### Unix-like

```bash
./scripts/bootstrap_workspace.sh --mode merge --target "$HOME/.openclaw/workspace"
```

## Optional Profile During Bootstrap

You can apply a workload profile during bootstrap:

### Windows

```powershell
.\scripts\bootstrap_workspace.ps1 -Mode fresh -Profile coding
```

### Unix-like

```bash
./scripts/bootstrap_workspace.sh --mode fresh --profile coding
```

## What Bootstrap Does

1. optionally installs Mini-fy into a target workspace
2. patches `~/.openclaw/openclaw.json`
3. optionally applies a profile
4. runs the doctor unless skipped
5. reports the resulting workspace path

## Repo Self-Test

Mini-fy also includes repo-level self-test scripts:

- `scripts/selftest.ps1`
- `scripts/selftest.sh`

Use them when you want to validate the repo's own tooling before pushing changes.
