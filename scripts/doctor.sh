#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_INPUT="${1:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}"
CONFIG_PATH="${2:-$HOME/.openclaw/openclaw.json}"

expand_home() {
  case "$1" in
    "~") printf '%s\n' "$HOME" ;;
    "~/"*) printf '%s/%s\n' "$HOME" "${1#~/}" ;;
    *) printf '%s\n' "$1" ;;
  esac
}

normalize_path() {
  local value
  value="$(expand_home "$1")"
  if [ -d "$value" ]; then
    (cd "$value" && pwd -P)
  else
    local parent
    parent="$(dirname "$value")"
    local base
    base="$(basename "$value")"
    if [ -d "$parent" ]; then
      printf '%s/%s\n' "$(cd "$parent" && pwd -P)" "$base"
    else
      printf '%s\n' "$value"
    fi
  fi
}

print_check() {
  printf '[%s] %s\n' "$1" "$2"
}

get_configured_workspace() {
  if [ ! -f "$CONFIG_PATH" ]; then
    return 0
  fi

  local raw candidate
  raw="$(tr '\n' ' ' < "$CONFIG_PATH")"
  candidate="$(printf '%s' "$raw" | sed -n 's/.*"workspace"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)"

  if [ -n "$candidate" ]; then
    candidate="${candidate//\\\\/\\}"
    normalize_path "$candidate"
  fi
}

WORKSPACE_PATH="$(normalize_path "$WORKSPACE_INPUT")"

printf 'Mini-fy doctor\n'
printf 'Workspace under test: %s\n\n' "$WORKSPACE_PATH"

if [ ! -d "$WORKSPACE_PATH" ]; then
  print_check "FAIL" "Workspace path does not exist."
  exit 1
fi

expected_paths=(
  "AGENTS.md"
  "BOOT.md"
  "SOUL.md"
  "USER.md"
  "IDENTITY.md"
  "TOOLS.md"
  "HEARTBEAT.md"
  "MEMORY.md"
  "skills"
  "scripts"
  "profiles"
  "docs"
  "config"
  "data"
)

missing=()
for relative in "${expected_paths[@]}"; do
  if [ ! -e "${WORKSPACE_PATH}/${relative}" ]; then
    missing+=("$relative")
  fi
done

if [ "${#missing[@]}" -eq 0 ]; then
  print_check "PASS" "Expected Mini-fy workspace files are present."
else
  print_check "WARN" "Missing expected paths: ${missing[*]}"
fi

configured_workspace="$(get_configured_workspace || true)"
if [ -n "$configured_workspace" ]; then
  print_check "INFO" "Configured OpenClaw workspace: $configured_workspace"
  if [ "$configured_workspace" = "$WORKSPACE_PATH" ]; then
    print_check "PASS" "Mini-fy matches the configured active workspace."
  else
    print_check "WARN" "Mini-fy is not the configured active workspace. This looks like a template-only clone or alternate workspace."
  fi
else
  print_check "WARN" "Could not determine the configured OpenClaw workspace from $CONFIG_PATH."
fi

if [ -f "${WORKSPACE_PATH}/BOOTSTRAP.md" ]; then
  print_check "INFO" "BOOTSTRAP.md still exists. One-time setup may still be pending."
fi

skill_count="$(find "${WORKSPACE_PATH}/skills" -name SKILL.md -type f 2>/dev/null | wc -l | tr -d ' ')"
print_check "INFO" "Detected ${skill_count} Mini-fy skill files."

if [ -f "${WORKSPACE_PATH}/AGENTS.md" ]; then
  profiles="$(grep -o 'MINI-FY PROFILE:[^ ]\+ START' "${WORKSPACE_PATH}/AGENTS.md" 2>/dev/null | sed 's/MINI-FY PROFILE://; s/ START//' | sort -u | tr '\n' ',' | sed 's/,$//')"
  if [ -n "$profiles" ]; then
    print_check "INFO" "Active Mini-fy profiles: ${profiles}"
  fi
fi

if ! command -v openclaw >/dev/null 2>&1; then
  print_check "WARN" "OpenClaw CLI is not on PATH, so live command checks were skipped."
  exit 0
fi

run_check() {
  local label="$1"
  shift

  local output
  if output="$("$@" 2>&1)"; then
    print_check "PASS" "${label} succeeded."
  else
    output="$(printf '%s' "$output" | head -n 3 | tr '\n' ' ')"
    [ -n "$output" ] || output="No output captured."
    print_check "WARN" "${label} failed. ${output}"
  fi
}

run_check "openclaw skills list" openclaw skills list
run_check "openclaw status" openclaw status
run_check "openclaw memory status" openclaw memory status
run_check "openclaw sandbox explain" openclaw sandbox explain
