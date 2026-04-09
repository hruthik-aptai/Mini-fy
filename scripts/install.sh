#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-$HOME/.openclaw/workspace}"
REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

items=(
  ".gitignore"
  "README.md"
  "AGENTS.md"
  "SOUL.md"
  "USER.md"
  "IDENTITY.md"
  "TOOLS.md"
  "HEARTBEAT.md"
  "BOOTSTRAP.md"
  "MEMORY.md"
  "docs"
  "data"
  "config"
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
printf '  2. Merge config snippets from config/\n'
printf '  3. Restart OpenClaw or start a new session\n'
printf '  4. Run: openclaw skills list\n'
