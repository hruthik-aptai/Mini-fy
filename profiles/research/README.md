# Research Profile

Use this profile when the agent is primarily gathering, validating, comparing, or synthesizing external information.

It biases Mini-fy toward:

- primary-source retrieval
- explicit dates and version numbers
- source matrices
- clear fact vs inference boundaries
- low-trust handling of secondary summaries

## Apply It

1. Run `scripts/apply_profile.ps1 -Profile research` on Windows or `./scripts/apply_profile.sh research` on Unix-like systems.
2. Merge `profiles/research/config.example.jsonc` with `scripts/patch_openclaw_config.ps1` or `scripts/patch_openclaw_config.sh`.
3. Start a new session or restart the gateway.
4. Run the doctor and eval scripts.
