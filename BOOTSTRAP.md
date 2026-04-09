# BOOTSTRAP.md

One-time setup:

1. Decide whether this repo is:
   - the active workspace
   - a template to merge into the active workspace
2. If it is only a template:
   - run `scripts/install.ps1` on Windows
   - or run `scripts/install.sh` on Unix-like systems
3. If it is the active workspace, merge the relevant example from `config/` into `~/.openclaw/openclaw.json`.
4. Personalize `USER.md`, `TOOLS.md`, and `HEARTBEAT.md`.
5. Start a new session or restart the gateway.
6. Verify with:
   - `openclaw skills list`
   - `openclaw status`
   - `openclaw memory status`
7. Read `docs/AGENT_QUICKSTART.md` if any step is ambiguous.
8. Delete this file after setup to save recurring tokens.
