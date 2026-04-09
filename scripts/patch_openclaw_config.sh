#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_BIN=""

if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
else
  printf 'Python is required for scripts/patch_openclaw_config.py\n' >&2
  exit 1
fi

"$PYTHON_BIN" "${SCRIPT_DIR}/patch_openclaw_config.py" "$@"
