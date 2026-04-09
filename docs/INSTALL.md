# Install Mini-fy

Mini-fy works best in one of two modes:

1. A clean dedicated OpenClaw workspace
2. A portable layer merged into an existing workspace

Which mode you choose depends on whether you want a public template, a real private assistant workspace, or both.

## Before You Start

OpenClaw's official docs recommend treating the real workspace as private memory. This repo is public, so use it as:

- a public baseline
- a template you fork privately
- a portable pack you selectively merge into your real workspace

Do **not** commit the following into this public repo:

- `~/.openclaw/openclaw.json`
- credentials or auth profiles
- session transcripts
- private memory logs

## Mode A: Fresh Dedicated Workspace

This is the cleanest option if you want Mini-fy to be the active workspace.

### 1. Clone the repo

```bash
git clone https://github.com/hruthik-aptai/Mini-fy.git ~/Mini-fy
```

### 2. Point OpenClaw at the clone

Merge the parts you want from `config/openclaw.efficient.example.jsonc` into:

```text
~/.openclaw/openclaw.json
```

At minimum, set:

```jsonc
{
  "agents": {
    "defaults": {
      "workspace": "~/Mini-fy"
    }
  }
}
```

### 3. Seed any missing workspace defaults

```bash
openclaw setup --workspace ~/Mini-fy
```

### 4. Verify the workspace and skills

```bash
openclaw skills list
openclaw status
```

### 5. Personalize the safe template files

Edit:

- `USER.md`
- `TOOLS.md`
- `HEARTBEAT.md`

Optional:

- `MEMORY.md`

Then:

1. patch config with `scripts/patch_openclaw_config.ps1` or `scripts/patch_openclaw_config.sh`
2. optionally apply a profile from `profiles/`
3. run the doctor script
4. run the matching evals
5. delete `BOOTSTRAP.md` after setup is complete

## Mode B: Merge Into An Existing Workspace

Use this mode when you already have a working workspace and want Mini-fy's structure, skills, and docs without replacing the whole thing.

### Windows

From the repo root:

```powershell
.\scripts\install.ps1
```

Custom target:

```powershell
.\scripts\install.ps1 -Target "C:\path\to\workspace"
```

### Unix-like

From the repo root:

```bash
chmod +x ./scripts/install.sh
./scripts/install.sh
```

Custom target:

```bash
./scripts/install.sh /path/to/workspace
```

### What the installers do

- create the target folder if it does not exist
- back up conflicting files and folders with a timestamp suffix
- copy Mini-fy's portable files into the target
- leave `~/.openclaw/` state alone
- try to run the doctor automatically when OpenClaw is available

### What to do after merging

1. Start a new session or restart the gateway.
2. Patch config with `scripts/patch_openclaw_config.ps1` or `scripts/patch_openclaw_config.sh`.
3. Optionally apply a workload profile.
4. Run the doctor script.
5. Run `openclaw skills list`.
6. Skim your merged `AGENTS.md`, `TOOLS.md`, and `USER.md`.
7. Remove or refine anything that conflicts with your existing workflow.

## Recommended Config Merge Order

If you are tuning from scratch, this order is sensible:

1. `openclaw.secure-baseline.example.jsonc`
2. `openclaw.efficient.example.jsonc`
3. `openclaw.memory.example.jsonc`
4. `openclaw.heartbeat.example.jsonc`

Security first, then performance, then memory, then background cadence.

## Verification Checklist

After installation, validate these:

- OpenClaw is pointed at the expected workspace path
- the Mini-fy skills appear in `openclaw skills list`
- `AGENTS.md` and `TOOLS.md` are the versions you expect
- memory search is healthy if enabled
- no secrets or private notes were added to git

Useful commands:

```bash
./scripts/doctor.sh
openclaw skills list
openclaw memory status
openclaw sandbox explain
openclaw status --all
```

## Best Practice For Real Use

The strongest setup is usually:

1. Keep this public repo as the portable baseline.
2. Maintain a private fork or private sibling workspace for real memory and local notes.
3. Pull public improvements into the private copy as needed.

That preserves both safety and portability.
