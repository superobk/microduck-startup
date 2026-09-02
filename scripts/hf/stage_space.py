#!/usr/bin/env python3
"""Stage and optionally publish a Microduck policy in a duplicate HF Space.

The safe default is stage-only. `--duplicate --upload` creates/updates a Space
in the caller's namespace. `--create-pr --upload` opens a Community PR against
the source Space; it never writes directly to the official main branch.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re
import shutil
import subprocess
import tempfile


VALID_SLOTS = ("walk", "sitstand", "roll", "kickL", "kickR", "roller", "crouch")


def safe_slug(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9._-]+", "-", value).strip("-._")
    if not slug:
        raise ValueError("slug is empty after sanitization")
    return slug


def verify_onnx_contract(path: Path) -> None:
    try:
        import onnxruntime as ort
    except ImportError as exc:
        raise RuntimeError(
            "onnxruntime is required to stage a policy; run from the microduck_rl uv environment"
        ) from exc
    session = ort.InferenceSession(str(path), providers=["CPUExecutionProvider"])
    inputs = session.get_inputs()
    outputs = session.get_outputs()
    if len(inputs) != 1 or len(outputs) != 1:
        raise RuntimeError(
            f"expected one ONNX input/output, got {len(inputs)}/{len(outputs)}"
        )
    if inputs[0].shape[-1] != 61 or outputs[0].shape[-1] != 14:
        raise RuntimeError(
            f"expected ONNX 61->14, got {inputs[0].shape} -> {outputs[0].shape}"
        )


def patch_policy_slot(constants_path: Path, slot: str, relative_policy: str) -> str:
    text = constants_path.read_text(encoding="utf-8")
    pattern = re.compile(
        rf"(?m)^(\s*{re.escape(slot)}\s*:\s*)`\$\{{POLICY_DIR\}}/[^`]+`(\s*,?)"
    )
    replacement = rf"\1`${{POLICY_DIR}}/{relative_policy}`\2"
    updated, count = pattern.subn(replacement, text, count=1)
    if count != 1:
        raise RuntimeError(
            f"could not find exactly one {slot!r} policy mapping in {constants_path}"
        )
    constants_path.write_text(updated, encoding="utf-8")
    return replacement


def update_readme(
    readme: Path,
    *,
    slug: str,
    slot: str,
    source_space: str,
    source_sha: str,
    model_repo: str,
) -> None:
    text = readme.read_text(encoding="utf-8")
    start = "<!-- MICRODUCK_COMMUNITY_POLICY_START -->"
    end = "<!-- MICRODUCK_COMMUNITY_POLICY_END -->"
    model_line = (
        f"- Model bundle: `https://huggingface.co/{model_repo}`"
        if model_repo
        else "- Model bundle: included with this staged Space"
    )
    section = f"""
{start}
## Community policy preview

- Policy: `{slug}`
- Replaces preview slot: `{slot}`
- Upstream Space snapshot: `{source_space}@{source_sha}`
{model_line}
- Preview video: `app/public/community/{slug}/preview.mp4`
- Replay metrics: `app/public/community/{slug}/metrics.json`

This duplicate is an evaluation surface. A genuinely new action whose command
encoding, duration, termination or fallback differs from the existing slot also
requires changes in `app/src/game/game.js` and the React HUD/input modules.
{end}
"""
    marker_pattern = re.compile(
        re.escape(start) + r".*?" + re.escape(end), flags=re.DOTALL
    )
    if marker_pattern.search(text):
        text = marker_pattern.sub(section.strip(), text)
    else:
        text = text.rstrip() + "\n\n" + section.strip() + "\n"
    readme.write_text(text, encoding="utf-8")


def copy_optional(source: Path, destination: Path) -> None:
    if source.is_file():
        destination.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(source, destination)


def self_test() -> None:
    with tempfile.TemporaryDirectory() as tmp:
        path = Path(tmp) / "constants.js"
        path.write_text(
            'export const POLICY_DIR = "./policies";\n'
            "export const POLICIES = {\n"
            '  walk: `${POLICY_DIR}/old.onnx`,\n'
            '  roll: `${POLICY_DIR}/roll.onnx`,\n'
            "};\n",
            encoding="utf-8",
        )
        patch_policy_slot(path, "walk", "community/new.onnx")
        result = path.read_text(encoding="utf-8")
        assert "community/new.onnx" in result
        assert "old.onnx" not in result
    print("PASS: HF Space patch self-test")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--source-space",
        default="pollen-robotics/microduck-simulator",
    )
    parser.add_argument("--target-space", default="")
    parser.add_argument("--policy", type=Path)
    parser.add_argument("--bundle", type=Path)
    parser.add_argument("--slot", choices=VALID_SLOTS)
    parser.add_argument("--slug", default="")
    parser.add_argument("--model-repo", default="")
    parser.add_argument("--workdir", type=Path)
    parser.add_argument("--duplicate", action="store_true")
    parser.add_argument("--create-pr", action="store_true")
    parser.add_argument("--private", action="store_true")
    parser.add_argument("--build", action="store_true")
    parser.add_argument("--upload", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.self_test:
        self_test()
        return 0

    if args.policy is None or args.slot is None or args.workdir is None:
        raise SystemExit("--policy, --slot and --workdir are required")
    if args.duplicate and args.create_pr:
        raise SystemExit("choose either --duplicate or --create-pr")
    if args.upload and not (args.duplicate or args.create_pr):
        raise SystemExit("--upload requires --duplicate or --create-pr")
    if args.duplicate and not args.target_space:
        raise SystemExit("--duplicate requires --target-space")

    policy = args.policy.expanduser().resolve()
    if not policy.is_file():
        raise SystemExit(f"policy not found: {policy}")
    verify_onnx_contract(policy)
    bundle = args.bundle.expanduser().resolve() if args.bundle else policy.parent
    slug = safe_slug(args.slug or policy.stem)
    workdir = args.workdir.expanduser().resolve()
    if workdir.exists():
        shutil.rmtree(workdir)
    workdir.mkdir(parents=True)

    from huggingface_hub import HfApi, snapshot_download

    api = HfApi()
    info = api.space_info(args.source_space)
    source_sha = info.sha
    if not source_sha:
        raise RuntimeError(f"source Space returned no SHA: {args.source_space}")

    snapshot_download(
        repo_id=args.source_space,
        repo_type="space",
        revision=source_sha,
        local_dir=str(workdir),
    )

    policy_rel = f"community/{slug}.onnx"
    policy_dest = workdir / "app" / "public" / "policies" / policy_rel
    policy_dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(policy, policy_dest)

    constants_path = workdir / "app" / "src" / "game" / "constants.js"
    replacement = patch_policy_slot(constants_path, args.slot, policy_rel)

    community_dir = workdir / "app" / "public" / "community" / slug
    copy_optional(bundle / "preview.mp4", community_dir / "preview.mp4")
    copy_optional(bundle / "metrics.json", community_dir / "metrics.json")
    copy_optional(bundle / "manifest.json", community_dir / "manifest.json")

    integration = {
        "schema_version": 1,
        "slug": slug,
        "slot": args.slot,
        "policy_path": f"app/public/policies/{policy_rel}",
        "source_space": args.source_space,
        "source_space_sha": source_sha,
        "model_repo": args.model_repo or None,
        "mapping": replacement,
    }
    community_dir.mkdir(parents=True, exist_ok=True)
    (community_dir / "integration.json").write_text(
        json.dumps(integration, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    update_readme(
        workdir / "README.md",
        slug=slug,
        slot=args.slot,
        source_space=args.source_space,
        source_sha=source_sha,
        model_repo=args.model_repo,
    )

    if args.build:
        subprocess.run(["npm", "ci"], cwd=workdir / "app", check=True)
        subprocess.run(["npm", "run", "build"], cwd=workdir / "app", check=True)

    print(f"source:  {args.source_space}@{source_sha}")
    print(f"staged:  {workdir}")
    print(f"policy:  {policy_dest}")
    print(f"mapping: {replacement}")

    if not args.upload:
        print("STAGE ONLY: no Hugging Face write performed")
        return 0

    ignore = [
        ".cache/**",
        "**/.cache/**",
        "app/node_modules/**",
        "app/dist/**",
        ".DS_Store",
        "*.tmp",
        "*.lock",
    ]
    if args.duplicate:
        api.duplicate_space(
            from_id=args.source_space,
            to_id=args.target_space,
            private=args.private,
            exist_ok=True,
        )
        result = api.upload_folder(
            folder_path=str(workdir),
            repo_id=args.target_space,
            repo_type="space",
            commit_message=f"preview Microduck policy {slug} in slot {args.slot}",
            ignore_patterns=ignore,
        )
        print(result)
        print(f"Space: https://huggingface.co/spaces/{args.target_space}")
        return 0

    # Community PR path: never mutate the official main branch directly.
    result = api.upload_folder(
        folder_path=str(workdir),
        repo_id=args.source_space,
        repo_type="space",
        revision="main",
        create_pr=True,
        commit_message=f"community preview: Microduck policy {slug}",
        ignore_patterns=ignore,
    )
    print(result)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
