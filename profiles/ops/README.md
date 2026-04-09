# Ops Profile

Use this profile when the agent is primarily handling incidents, deployments, runtime debugging, or operational changes.

It biases Mini-fy toward:

- blast-radius awareness
- reversible changes
- preflight and post-change checks
- short incident timelines
- explicit rollback thinking

## Apply It

1. Run `scripts/apply_profile.ps1 -Profile ops` on Windows or `./scripts/apply_profile.sh ops` on Unix-like systems.
2. Merge `profiles/ops/config.example.jsonc` with `scripts/patch_openclaw_config.ps1` or `scripts/patch_openclaw_config.sh`.
3. Start a new session or restart the gateway.
4. Run the doctor and eval scripts.
