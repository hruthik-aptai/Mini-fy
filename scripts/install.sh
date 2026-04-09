#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-$HOME/.openclaw/workspace}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

items=(
  ".gitignore"
  "README.md"
  "AGENTS.md"
  "BOOT.md"
  "SOUL.md"
  "USER.md"
  "IDENTITY.md"
  "TOOLS.md"
  "HEARTBEAT.md"
  "BOOTSTRAP.md"
  "MEMORY.md"
  "CONTRIBUTING.md"
  "SECURITY.md"
  "LICENSE"
  "docs"
  "data"
  "config"
  "profiles"
  "scripts"
  "tests"
  "skills"
)

backup_path() {
  local dest="$1"

  if [ -e "$dest" ]; then
    local backup="${dest}.bak-${TIMESTAMP}"
    mv "$dest" "$backup"
    printf 'Backed up %s -> %s\n' "$dest" "$backup"
  fi
}

mkdir -p "$TARGET"

for item in "${items[@]}"; do
  src="${REPO_ROOT}/${item}"
  dest="${TARGET}/${item}"

  backup_path "$dest"

  if [ -d "$src" ]; then
    cp -R "$src" "$TARGET/"
  else
    cp "$src" "$dest"
  fi

  printf 'Installed %s\n' "$item"
done

printf '\nMini-fy installed into %s\n' "$TARGET"
printf 'Next steps:\n'
printf '  1. Review USER.md, TOOLS.md, and HEARTBEAT.md\n'
printf '  2. Patch config with scripts/patch_openclaw_config.sh\n'
printf '  3. Optionally apply a workload profile with scripts/apply_profile.sh\n'
printf '  4. Restart OpenClaw or start a new session\n'
printf '  5. Run scripts/doctor.sh and then your evals\n'

if command -v openclaw >/dev/null 2>&1 && [ -f "${REPO_ROOT}/scripts/doctor.sh" ]; then
  printf '\nRunning Mini-fy doctor...\n'
  bash "${REPO_ROOT}/scripts/doctor.sh" "$TARGET" || true
fi
