#!/usr/bin/env python3
"""Publish an immutable Microduck bundle to a Hugging Face model repository."""

from __future__ import annotations

import argparse
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bundle", type=Path, required=True)
    parser.add_argument("--repo-id", required=True)
    parser.add_argument("--private", action="store_true")
    parser.add_argument("--create-pr", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    bundle = args.bundle.expanduser().resolve()
    if not bundle.is_dir():
        raise SystemExit(f"bundle directory not found: {bundle}")

    required = ["README.md", "policy.onnx", "manifest.json", "SHA256SUMS"]
    missing = [name for name in required if not (bundle / name).is_file()]
    if missing:
        raise SystemExit(f"bundle is incomplete; missing: {', '.join(missing)}")

    print(f"bundle:  {bundle}")
    print(f"repo:    {args.repo_id}")
    print(f"private: {args.private}")
    print(f"PR:      {args.create_pr}")
    if args.dry_run:
        print("DRY RUN: no Hugging Face write performed")
        return 0

    from huggingface_hub import HfApi

    api = HfApi()
    api.create_repo(
        repo_id=args.repo_id,
        repo_type="model",
        private=args.private,
        exist_ok=True,
    )
    result = api.upload_folder(
        folder_path=str(bundle),
        repo_id=args.repo_id,
        repo_type="model",
        commit_message=f"publish Microduck policy bundle {bundle.name}",
        create_pr=args.create_pr,
        ignore_patterns=[
            ".DS_Store",
            ".rsync-partial/**",
            "*.tmp",
            "*.lock",
        ],
    )
    print(result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
