#!/usr/bin/env bash
set -euo pipefail

if ! command -v openclaw >/dev/null 2>&1; then
  printf 'OpenClaw CLI is not on PATH.\n' >&2
  exit 1
fi

run_step() {
  local label="$1"
  shift

  printf '\n==> %s\n' "$label"
  if ! "$@" 2>&1 | head -n 20; then
    printf 'Command failed.\n'
  fi
}

run_step "openclaw status" openclaw status
run_step "openclaw skills list" openclaw skills list
run_step "openclaw memory status" openclaw memory status
run_step "openclaw sandbox explain" openclaw sandbox explain
