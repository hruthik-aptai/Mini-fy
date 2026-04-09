#!/usr/bin/env python3
import argparse
import json
import os
from copy import deepcopy
from datetime import datetime
from pathlib import Path


def strip_jsonc(text: str) -> str:
    out = []
    in_string = False
    escape = False
    in_line_comment = False
    in_block_comment = False
    i = 0

    while i < len(text):
        ch = text[i]
        nxt = text[i + 1] if i + 1 < len(text) else ""

        if in_line_comment:
            if ch == "\n":
                in_line_comment = False
                out.append(ch)
            i += 1
            continue

        if in_block_comment:
            if ch == "*" and nxt == "/":
                in_block_comment = False
                i += 2
            else:
                i += 1
            continue

        if in_string:
            out.append(ch)
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_string = False
            i += 1
            continue

        if ch == '"':
            in_string = True
            out.append(ch)
            i += 1
            continue

        if ch == "/" and nxt == "/":
            in_line_comment = True
            i += 2
            continue

        if ch == "/" and nxt == "*":
            in_block_comment = True
            i += 2
            continue

        out.append(ch)
        i += 1

    return "".join(out)


def load_jsonc(path: Path):
    if not path.exists():
        return {}
    return json.loads(strip_jsonc(path.read_text(encoding="utf-8")))


def deep_merge(base, overlay):
    if isinstance(base, dict) and isinstance(overlay, dict):
        merged = deepcopy(base)
        for key, value in overlay.items():
            if key in merged:
                merged[key] = deep_merge(merged[key], value)
            else:
                merged[key] = deepcopy(value)
        return merged
    return deepcopy(overlay)


def set_workspace(config, workspace_path: str):
    config.setdefault("agents", {}).setdefault("defaults", {})["workspace"] = workspace_path


def ensure_parent(path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)


def main():
    parser = argparse.ArgumentParser(description="Safely merge Mini-fy config snippets into an OpenClaw config.")
    parser.add_argument("--config", default="~/.openclaw/openclaw.json", help="Target OpenClaw config path.")
    parser.add_argument("--snippet", action="append", default=[], help="Snippet file to merge. Repeatable.")
    parser.add_argument("--profile", action="append", default=[], help="Mini-fy profile id to merge. Repeatable.")
    parser.add_argument("--set-workspace", help="Set agents.defaults.workspace to this path after merging.")
    parser.add_argument("--output", help="Write merged config to this path instead of the target config path.")
    parser.add_argument("--dry-run", action="store_true", help="Do not write anything; print the merged config.")
    parser.add_argument("--no-backup", action="store_true", help="Do not create a timestamped backup of the target config.")
    args = parser.parse_args()

    repo_root = Path(__file__).resolve().parent.parent
    config_path = Path(os.path.expanduser(args.config)).resolve()
    output_path = Path(os.path.expanduser(args.output)).resolve() if args.output else config_path

    merged = load_jsonc(config_path)

    snippet_paths = [Path(s).expanduser() for s in args.snippet]
    snippet_paths = [p if p.is_absolute() else (repo_root / p) for p in snippet_paths]

    for profile in args.profile:
      snippet_paths.append(repo_root / "profiles" / profile / "config.example.jsonc")

    for snippet_path in snippet_paths:
        if not snippet_path.exists():
            raise FileNotFoundError(f"Snippet not found: {snippet_path}")
        merged = deep_merge(merged, load_jsonc(snippet_path))

    if args.set_workspace:
        set_workspace(merged, args.set_workspace)

    rendered = json.dumps(merged, indent=2, sort_keys=False) + "\n"

    if args.dry_run:
        print(rendered, end="")
        return

    ensure_parent(output_path)

    if output_path == config_path and config_path.exists() and not args.no_backup:
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        backup_path = config_path.with_name(config_path.name + f".bak-{timestamp}")
        backup_path.write_text(config_path.read_text(encoding="utf-8"), encoding="utf-8")
        print(f"Backed up {config_path} -> {backup_path}")

    output_path.write_text(rendered, encoding="utf-8")
    print(f"Wrote merged config to {output_path}")


if __name__ == "__main__":
    main()
