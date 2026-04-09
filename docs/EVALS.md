# Evals

Mini-fy should be judged by behavior, not by how confident the prompts sound.

This repo now ships a small eval and benchmark layer so you can check whether changes improve real outputs.

## Included Eval Sets

- `data/evals/core.json`
  - baseline workspace understanding, install verification, skill selection, and secret handling
- `data/evals/coding.json`
  - coding-profile behavior and code-delivery discipline
- `data/evals/research.json`
  - research-profile source discipline and source-matrix usage
- `data/evals/ops.json`
  - ops-profile change discipline and rollback awareness

## Validate Case Files Only

### Windows

```powershell
.\scripts\eval.ps1 -Cases data/evals/core.json -SkipRun
```

### Unix-like

```bash
./scripts/eval.sh --cases data/evals/core.json --skip-run
```

## Run Live Evals

These require the OpenClaw CLI on `PATH`.

### Windows

```powershell
.\scripts\eval.ps1 -Cases data/evals/core.json,data/evals/coding.json -Output reports\coding.json
```

### Unix-like

```bash
./scripts/eval.sh --cases data/evals/core.json data/evals/coding.json --output reports/coding.json
```

## Compare Before And After

Run a baseline, make your change, run again, then compare:

```bash
python scripts/compare_eval_reports.py reports/before.json reports/after.json
```

Useful patterns:

1. baseline Mini-fy
2. apply a profile
3. patch config
4. rerun evals
5. compare pass count and average duration

## What These Evals Measure

They are intentionally lightweight.

They currently check:

- whether key concepts are surfaced
- whether prohibited claims are avoided
- whether the output includes the expected operational guidance
- rough wall-clock duration per case

They do not replace human review for nuanced work. They are a guardrail, not a full judge.
