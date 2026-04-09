# BOOT.md

Run this checklist on startup or first contact with the workspace:

1. Confirm whether this repo is the active OpenClaw workspace.
2. If `BOOTSTRAP.md` exists, read it and follow the one-time setup steps.
3. Read `docs/AGENT_QUICKSTART.md` if installation or verification is still unclear.
4. If OpenClaw is available, verify:
   - `openclaw skills list`
   - `openclaw status`
   - `openclaw memory status`
5. If the workload is clearly coding, research, or ops heavy, consider applying the matching profile.
6. If Mini-fy is not yet installed into the real workspace, recommend or run:
   - `scripts/install.ps1` on Windows
   - `scripts/install.sh` on Unix-like systems
7. Tell the human the current state in one line:
   - template only
   - installed but not verified
   - installed and verified

Keep the report short. Do not dump long docs unless asked.
