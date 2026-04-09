#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:?Usage: ./scripts/apply_profile.sh <profile> [target]}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
TARGET_ROOT="$(cd -- "${2:-${REPO_ROOT}}" && pwd)"
PROFILE_ROOT="${REPO_ROOT}/profiles/${PROFILE}"
TARGET_AGENTS="${TARGET_ROOT}/AGENTS.md"
TARGET_SKILLS="${TARGET_ROOT}/skills"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

if [ ! -d "$PROFILE_ROOT" ]; then
  printf 'Unknown profile: %s\n' "$PROFILE" >&2
  exit 1
fi

MARKER_START="<!-- MINI-FY PROFILE:${PROFILE} START -->"
MARKER_END="<!-- MINI-FY PROFILE:${PROFILE} END -->"
FRAGMENT="$(cat "${PROFILE_ROOT}/AGENTS.append.md")"

mkdir -p "$TARGET_SKILLS"

if grep -Fq "$MARKER_START" "$TARGET_AGENTS"; then
  printf 'Profile marker already present in AGENTS.md: %s\n' "$PROFILE"
else
  {
    printf '\n\n%s\n' "$MARKER_START"
    printf '%s\n' "$FRAGMENT"
    printf '%s\n' "$MARKER_END"
  } >> "$TARGET_AGENTS"
  printf 'Appended profile guidance to AGENTS.md\n'
fi

if [ -d "${PROFILE_ROOT}/skills" ]; then
  for skill_dir in "${PROFILE_ROOT}"/skills/*; do
    [ -d "$skill_dir" ] || continue
    skill_name="$(basename "$skill_dir")"
    destination="${TARGET_SKILLS}/${skill_name}"
    if [ -e "$destination" ]; then
      backup="${destination}.bak-${TIMESTAMP}"
      mv "$destination" "$backup"
      printf 'Backed up existing skill to %s\n' "$backup"
    fi
    cp -R "$skill_dir" "$TARGET_SKILLS/"
    printf 'Installed profile skill %s\n' "$skill_name"
  done
fi

printf '\nProfile %s applied to %s\n' "$PROFILE" "$TARGET_ROOT"
printf 'Next steps:\n'
printf '  1. Merge profiles/%s/config.example.jsonc with scripts/patch_openclaw_config.sh --profile %s\n' "$PROFILE" "$PROFILE"
printf '  2. Restart OpenClaw or start a new session\n'
printf '  3. Run the doctor script\n'
printf '  4. Run the matching eval file in data/evals/\n'
