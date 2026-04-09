# OpenClaw CLI Playbook

Mini-fy is built specifically for **OpenClaw in a terminal / CLI environment**.

That means the default operating assumption is:

- the agent is running in a shell
- the primary interface is the `openclaw` command
- health, setup, and verification should be expressed as commands
- GUI-first instructions are a fallback, not the default

## Core Terminal Routine

When an agent lands in this repo, the minimum command flow is:

```bash
openclaw status
openclaw skills list
openclaw memory status
openclaw sandbox explain
```

If Mini-fy may not be active yet, also run:

```bash
./scripts/doctor.sh
```

Windows:

```powershell
.\scripts\doctor.ps1
```

## Best Command Entry Points

### Setup

- `scripts/bootstrap_workspace.ps1`
- `scripts/bootstrap_workspace.sh`

### Verify

- `scripts/doctor.ps1`
- `scripts/doctor.sh`
- `scripts/openclaw_snapshot.ps1`
- `scripts/openclaw_snapshot.sh`

### Patch Config

- `scripts/patch_openclaw_config.ps1`
- `scripts/patch_openclaw_config.sh`

### Apply Profile

- `scripts/apply_profile.ps1`
- `scripts/apply_profile.sh`

### Evaluate

- `scripts/eval.ps1`
- `scripts/eval.sh`

### Validate The Repo Itself

- `scripts/selftest.ps1`
- `scripts/selftest.sh`

## Terminal-Specific Guidance

When answering from this workspace:

- prefer runnable commands
- keep outputs concise
- report path names exactly
- mention when a command was not run
- distinguish command success from inferred success
- avoid telling a CLI user to click through a UI when a command exists

## OpenClaw-Specific Commands Worth Knowing

- `openclaw status`
- `openclaw status --all`
- `openclaw skills list`
- `openclaw memory status`
- `openclaw sandbox explain`
- `openclaw setup --workspace <path>`
- `openclaw agent --message "<prompt>"`

## If The CLI Is Missing

If `openclaw` is not on `PATH`:

1. say so explicitly
2. continue with static repo checks where possible
3. avoid pretending the live OpenClaw runtime was verified
4. recommend the exact command flow to run once the CLI is available

## Output Standard

For terminal-first work, a good response format is:

1. current state
2. exact command or script to run
3. verification result
4. remaining gap, if any
