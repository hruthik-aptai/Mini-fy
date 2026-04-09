#!/usr/bin/env python3
import argparse
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path


def load_cases(case_paths):
    cases = []
    for case_path in case_paths:
        path = Path(case_path)
        with path.open(encoding="utf-8") as handle:
            data = json.load(handle)
        if not isinstance(data, list):
            raise ValueError(f"Case file must contain a list: {path}")
        for item in data:
            if "id" not in item or "prompt" not in item:
                raise ValueError(f"Case missing id or prompt in {path}")
            item.setdefault("required_substrings", [])
            item.setdefault("forbidden_substrings", [])
            item.setdefault("tags", [])
            item["_source"] = str(path)
            cases.append(item)
    return cases


def run_case(case, cwd):
    started = time.perf_counter()
    result = subprocess.run(
        ["openclaw", "agent", "--message", case["prompt"]],
        cwd=cwd,
        capture_output=True,
        text=True,
    )
    duration = round(time.perf_counter() - started, 3)
    output = (result.stdout or "").strip()
    error = (result.stderr or "").strip()
    combined = "\n".join(part for part in [output, error] if part).strip()
    lowered = combined.lower()

    missing_required = [
        token for token in case["required_substrings"] if token.lower() not in lowered
    ]
    present_forbidden = [
        token for token in case["forbidden_substrings"] if token.lower() in lowered
    ]

    passed = result.returncode == 0 and not missing_required and not present_forbidden

    return {
        "id": case["id"],
        "source": case["_source"],
        "duration_seconds": duration,
        "exit_code": result.returncode,
        "passed": passed,
        "missing_required": missing_required,
        "present_forbidden": present_forbidden,
        "output_preview": combined[:800],
        "tags": case["tags"],
    }


def write_report(path, report):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Run Mini-fy eval cases against the local OpenClaw CLI.")
    parser.add_argument("--cases", nargs="+", required=True, help="One or more eval case JSON files.")
    parser.add_argument("--workspace", default=".", help="Workspace path to run from.")
    parser.add_argument("--output", help="Write a JSON report to this path.")
    parser.add_argument("--skip-run", action="store_true", help="Validate case files only; do not invoke OpenClaw.")
    args = parser.parse_args()

    workspace = Path(os.path.expanduser(args.workspace)).resolve()
    cases = load_cases(args.cases)

    if args.skip_run:
        report = {
            "mode": "validation-only",
            "workspace": str(workspace),
            "case_count": len(cases),
            "passed": len(cases),
            "failed": 0,
            "results": [],
        }
        if args.output:
            write_report(Path(args.output), report)
        print(f"Validated {len(cases)} eval cases.")
        return

    if not shutil.which("openclaw"):
        print("OpenClaw CLI is required to run evals.", file=sys.stderr)
        sys.exit(1)

    results = [run_case(case, workspace) for case in cases]
    passed = sum(1 for result in results if result["passed"])
    failed = len(results) - passed
    avg_duration = round(sum(result["duration_seconds"] for result in results) / len(results), 3) if results else 0.0

    report = {
      "mode": "live-run",
      "workspace": str(workspace),
      "case_count": len(results),
      "passed": passed,
      "failed": failed,
      "avg_duration_seconds": avg_duration,
      "results": results,
    }

    if args.output:
        write_report(Path(args.output), report)

    print(f"Eval cases: {len(results)}")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    print(f"Average duration (s): {avg_duration}")

    if failed:
        print("Failing cases:")
        for result in results:
            if not result["passed"]:
                print(f"- {result['id']}")
                if result["missing_required"]:
                    print(f"  missing required: {', '.join(result['missing_required'])}")
                if result["present_forbidden"]:
                    print(f"  present forbidden: {', '.join(result['present_forbidden'])}")
        sys.exit(1)


if __name__ == "__main__":
    main()
