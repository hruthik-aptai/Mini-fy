#!/usr/bin/env bash
set -euo pipefail

SKIP_DOCTOR=0
SKIP_EVAL_VALIDATION=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    --skip-doctor)
      SKIP_DOCTOR=1
      shift
      ;;
    --skip-eval-validation)
      SKIP_EVAL_VALIDATION=1
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
PYTHON_BIN=""

if command -v python3 >/dev/null 2>&1; then
  PYTHON_BIN="python3"
elif command -v python >/dev/null 2>&1; then
  PYTHON_BIN="python"
else
  printf 'Python is required for scripts/selftest.sh\n' >&2
  exit 1
fi

shell_checks=(
  "scripts/install.sh"
  "scripts/doctor.sh"
  "scripts/patch_openclaw_config.sh"
  "scripts/apply_profile.sh"
  "scripts/eval.sh"
  "scripts/openclaw_snapshot.sh"
  "scripts/bootstrap_workspace.sh"
  "scripts/selftest.sh"
)

for item in "${shell_checks[@]}"; do
  bash -n "${REPO_ROOT}/${item}"
done

"$PYTHON_BIN" -m py_compile \
  "${REPO_ROOT}/scripts/patch_openclaw_config.py" \
  "${REPO_ROOT}/scripts/eval_suite.py" \
  "${REPO_ROOT}/scripts/compare_eval_reports.py"

"$PYTHON_BIN" -m unittest discover -s "${REPO_ROOT}/tests" -p "test_*.py"

"$PYTHON_BIN" "${REPO_ROOT}/scripts/patch_openclaw_config.py" \
  --config "${TMPDIR:-/tmp}/mini-fy-selftest-config.json" \
  --snippet "${REPO_ROOT}/config/openclaw.secure-baseline.example.jsonc" \
  --snippet "${REPO_ROOT}/config/openclaw.efficient.example.jsonc" \
  --profile coding \
  --set-workspace "${REPO_ROOT}" \
  --output "${TMPDIR:-/tmp}/mini-fy-selftest-merged.json"

if [ "$SKIP_EVAL_VALIDATION" -ne 1 ]; then
  "$PYTHON_BIN" "${REPO_ROOT}/scripts/eval_suite.py" \
    --cases \
    "${REPO_ROOT}/data/evals/core.json" \
    "${REPO_ROOT}/data/evals/coding.json" \
    "${REPO_ROOT}/data/evals/research.json" \
    "${REPO_ROOT}/data/evals/ops.json" \
    --skip-run \
    --output "${TMPDIR:-/tmp}/mini-fy-selftest-evals.json"
fi

if [ "$SKIP_DOCTOR" -ne 1 ]; then
  bash "${REPO_ROOT}/scripts/doctor.sh" "${REPO_ROOT}"
fi

printf 'Mini-fy selftest passed.\n'
