#!/usr/bin/env python3
"""Create an immutable, Hub-ready bundle from a one-day Microduck run."""

from __future__ import annotations

import argparse
import datetime as dt
import hashlib
import json
from pathlib import Path
import shutil
import subprocess


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def git_head(path: Path) -> str | None:
    try:
        return subprocess.check_output(
            ["git", "-C", str(path), "rev-parse", "HEAD"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return None


def copy_required(source: Path, destination: Path) -> None:
    if not source.is_file():
        raise FileNotFoundError(source)
    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, destination)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--run-id", required=True)
    parser.add_argument("--profile", required=True)
    parser.add_argument("--task-id", required=True)
    parser.add_argument("--space-slot", default="")
    parser.add_argument("--run-dir", type=Path, required=True)
    parser.add_argument("--checkpoint", type=Path, required=True)
    parser.add_argument("--onnx", type=Path, required=True)
    parser.add_argument("--replay-dir", type=Path, required=True)
    parser.add_argument("--bundle-dir", type=Path, required=True)
    parser.add_argument("--startup", type=Path, required=True)
    parser.add_argument("--rl-dir", type=Path, required=True)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    bundle = args.bundle_dir.expanduser().resolve()
    if bundle.exists():
        shutil.rmtree(bundle)
    bundle.mkdir(parents=True)

    copy_required(args.onnx.resolve(), bundle / "policy.onnx")
    copy_required(args.checkpoint.resolve(), bundle / "checkpoint.pt")
    for name in ("rollout.npz", "metrics.json", "preview.mp4"):
        candidate = args.replay_dir.resolve() / name
        if candidate.exists():
            copy_required(candidate, bundle / name)

    params_dir = args.run_dir.resolve() / "params"
    for name in ("env.yaml", "agent.yaml"):
        candidate = params_dir / name
        if candidate.exists():
            copy_required(candidate, bundle / "training" / name)

    upstreams = args.startup.resolve() / "configs" / "upstreams.env"
    if upstreams.exists():
        copy_required(upstreams, bundle / "training" / "upstreams.env")

    provenance = {
        "schema_version": 1,
        "generated_at": dt.datetime.now(dt.timezone.utc).isoformat(),
        "run_id": args.run_id,
        "profile": args.profile,
        "task_id": args.task_id,
        "space_slot": args.space_slot or None,
        "source": {
            "microduck_startup_commit": git_head(args.startup.resolve()),
            "microduck_rl_commit": git_head(args.rl_dir.resolve()),
        },
        "paths": {
            "source_run_dir": str(args.run_dir.resolve()),
            "source_checkpoint": str(args.checkpoint.resolve()),
        },
    }
    (bundle / "provenance.json").write_text(
        json.dumps(provenance, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    metrics: dict = {}
    metrics_path = bundle / "metrics.json"
    if metrics_path.exists():
        metrics = json.loads(metrics_path.read_text(encoding="utf-8"))

    slot_text = (
        f"`{args.space_slot}` in the current browser simulator"
        if args.space_slot
        else "no existing browser slot; JavaScript/UI integration is required"
    )
    card = f"""---
tags:
- reinforcement-learning
- robotics
- mujoco
- onnx
- microduck
library_name: onnxruntime
pipeline_tag: reinforcement-learning
---

# Microduck policy — {args.run_id}

This bundle was produced by the reproducible one-day pipeline in
`superobk/microduck-startup`.

## Contract

- Task: `{args.task_id}`
- Profile: `{args.profile}`
- Browser integration: {slot_text}
- Actor input: `float32[1, 61]`
- Actor output: `float32[1, 14]`
- Control rate: 50 Hz
- Observation normalization: exported through the official `microduck_rl/scripts/export.py`

## Files

- `policy.onnx` — deployment actor
- `checkpoint.pt` — RSL-RL checkpoint
- `preview.mp4` — deterministic evaluation preview
- `rollout.npz` — post-training evaluation observations/actions/rewards/dones
- `metrics.json` — replay metrics
- `training/env.yaml`, `training/agent.yaml` — resolved run configuration
- `provenance.json`, `manifest.json`, `SHA256SUMS` — traceability

## Replay summary

- Steps: {metrics.get("steps", "not recorded")}
- Total reward: {metrics.get("total_reward", "not recorded")}
- Done count: {metrics.get("done_count", "not recorded")}
- Action RMS: {metrics.get("action_rms", "not recorded")}

## Scope and safety

This is a simulation result, not proof of safe deployment on physical
hardware. Validate observation order, joint order, default pose, action scale,
control timing and safety limits before any real-robot test.
"""
    (bundle / "README.md").write_text(card, encoding="utf-8")

    entries = []
    for path in sorted(p for p in bundle.rglob("*") if p.is_file()):
        rel = path.relative_to(bundle).as_posix()
        if rel in {"manifest.json", "SHA256SUMS"}:
            continue
        entries.append(
            {
                "path": rel,
                "bytes": path.stat().st_size,
                "sha256": sha256_file(path),
            }
        )

    manifest = {
        "schema_version": 1,
        "run_id": args.run_id,
        "profile": args.profile,
        "task_id": args.task_id,
        "space_slot": args.space_slot or None,
        "files": entries,
    }
    (bundle / "manifest.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    checksum_paths = sorted(p for p in bundle.rglob("*") if p.is_file())
    with (bundle / "SHA256SUMS").open("w", encoding="utf-8") as handle:
        for path in checksum_paths:
            if path.name == "SHA256SUMS":
                continue
            handle.write(f"{sha256_file(path)}  {path.relative_to(bundle).as_posix()}\n")

    print(bundle)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
