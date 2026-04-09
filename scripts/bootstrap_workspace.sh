#!/usr/bin/env bash
set -euo pipefail

MODE="fresh"
TARGET="${HOME}/.openclaw/workspace"
CONFIG="${HOME}/.openclaw/openclaw.json"
PROFILE=""
SKIP_DOCTOR=0
SNIPPETS=(
  "config/openclaw.secure-baseline.example.jsonc"
  "config/openclaw.efficient.example.jsonc"
)

while [ "$#" -gt 0 ]; do
  case "$1" in
    --mode)
      MODE="$2"
      shift 2
      ;;
    --target)
      TARGET="$2"
      shift 2
      ;;
    --config)
      CONFIG="$2"
      shift 2
      ;;
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    --snippet)
      SNIPPETS+=("$2")
      shift 2
      ;;
    --skip-doctor)
      SKIP_DOCTOR=1
      shift
      ;;
    *)
      printf 'Unknown argument: %s\n' "$1" >&2
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
WORKSPACE_PATH="${REPO_ROOT}"

if [ "$MODE" = "merge" ]; then
  bash "${REPO_ROOT}/scripts/install.sh" "$TARGET"
  WORKSPACE_PATH="$(cd -- "$TARGET" && pwd)"
fi

PATCH_ARGS=(--config "$CONFIG" --set-workspace "$WORKSPACE_PATH")
for snippet in "${SNIPPETS[@]}"; do
  PATCH_ARGS+=(--snippet "$snippet")
done
if [ -n "$PROFILE" ]; then
  PATCH_ARGS+=(--profile "$PROFILE")
fi

bash "${REPO_ROOT}/scripts/patch_openclaw_config.sh" "${PATCH_ARGS[@]}"

if [ -n "$PROFILE" ]; then
  bash "${REPO_ROOT}/scripts/apply_profile.sh" "$PROFILE" "$WORKSPACE_PATH"
fi

if [ "$SKIP_DOCTOR" -ne 1 ]; then
  bash "${REPO_ROOT}/scripts/doctor.sh" "$WORKSPACE_PATH"
fi

printf '\nMini-fy bootstrap completed.\n'
printf 'Mode: %s\n' "$MODE"
printf 'Workspace: %s\n' "$WORKSPACE_PATH"
if [ -n "$PROFILE" ]; then
  printf 'Profile: %s\n' "$PROFILE"
fi
printf 'Next step: restart OpenClaw or start a new session, then run your evals.\n'
