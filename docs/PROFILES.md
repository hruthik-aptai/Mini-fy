# Profiles

Mini-fy's base workspace is intentionally general. Profiles let you bias it toward a workload without bloating the always-on root prompt for everyone.

## Available Profiles

### Coding

- best for source-code editing, testing, and feature or bugfix work
- adds the `code_delivery_guard` skill
- appends a coding-specific section to `AGENTS.md`
- provides `profiles/coding/config.example.jsonc`
- maps to `data/evals/coding.json`

### Research

- best for fresh facts, comparisons, source synthesis, and external analysis
- adds the `source_matrix` skill
- appends a research-specific section to `AGENTS.md`
- provides `profiles/research/config.example.jsonc`
- maps to `data/evals/research.json`

### Ops

- best for incidents, deploys, runtime debugging, and operational changes
- adds the `change_guard` skill
- appends an ops-specific section to `AGENTS.md`
- provides `profiles/ops/config.example.jsonc`
- maps to `data/evals/ops.json`

## Apply A Profile

### Windows

```powershell
.\scripts\apply_profile.ps1 -Profile coding
.\scripts\patch_openclaw_config.ps1 -Profile coding
```

### Unix-like

```bash
./scripts/apply_profile.sh coding
./scripts/patch_openclaw_config.sh --profile coding
```

After applying:

1. start a new session or restart the gateway
2. run the doctor script
3. run the matching eval file

## Design Rule

Profiles should stay additive and workload-specific.

They should not:

- replace the whole workspace philosophy
- duplicate the entire base repo
- add giant prompt sections that belong in task-specific docs
