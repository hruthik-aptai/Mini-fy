# Coding Profile

Use this profile when the agent is primarily shipping code.

It biases Mini-fy toward:

- repo inspection before edits
- small diffs over broad rewrites
- explicit verification paths
- regression control and test updates
- clear residual-risk reporting

## Apply It

1. Run `scripts/apply_profile.ps1 -Profile coding` on Windows or `./scripts/apply_profile.sh coding` on Unix-like systems.
2. Merge `profiles/coding/config.example.jsonc` with `scripts/patch_openclaw_config.ps1` or `scripts/patch_openclaw_config.sh`.
3. Start a new session or restart the gateway.
4. Run the doctor and eval scripts.
