#!/usr/bin/env python3
import argparse
import json
from pathlib import Path


def load_report(path):
    return json.loads(Path(path).read_text(encoding="utf-8"))


def main():
    parser = argparse.ArgumentParser(description="Compare two Mini-fy eval reports.")
    parser.add_argument("baseline")
    parser.add_argument("candidate")
    args = parser.parse_args()

    baseline = load_report(args.baseline)
    candidate = load_report(args.candidate)

    baseline_passed = baseline.get("passed", 0)
    candidate_passed = candidate.get("passed", 0)
    baseline_failed = baseline.get("failed", 0)
    candidate_failed = candidate.get("failed", 0)
    baseline_avg = baseline.get("avg_duration_seconds", 0.0)
    candidate_avg = candidate.get("avg_duration_seconds", 0.0)

    print("Mini-fy eval comparison")
    print(f"Baseline passed: {baseline_passed}")
    print(f"Candidate passed: {candidate_passed}")
    print(f"Delta passed: {candidate_passed - baseline_passed}")
    print(f"Baseline failed: {baseline_failed}")
    print(f"Candidate failed: {candidate_failed}")
    print(f"Delta failed: {candidate_failed - baseline_failed}")
    print(f"Baseline avg duration (s): {baseline_avg}")
    print(f"Candidate avg duration (s): {candidate_avg}")
    print(f"Delta avg duration (s): {round(candidate_avg - baseline_avg, 3)}")


if __name__ == "__main__":
    main()
