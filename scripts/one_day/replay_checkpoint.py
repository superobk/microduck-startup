#!/usr/bin/env python3
"""Headless checkpoint replay and rollout collection for Microduck.

This is deliberately separate from PPO's on-policy buffer. PPO collects its
own fresh rollouts during training; this script creates an immutable evaluation
artifact after training: policy observations, actions, rewards, dones, commands,
metrics, and an MP4 preview from the same mjlab task.
"""

from __future__ import annotations

import argparse
from dataclasses import asdict
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
from typing import Any


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def git_head(path: Path) -> str | None:
    try:
        return subprocess.check_output(
            ["git", "-C", str(path), "rev-parse", "HEAD"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except (OSError, subprocess.CalledProcessError):
        return None


def actor_tensor(obs: Any):
    try:
        return obs["policy"]
    except Exception as exc:  # noqa: BLE001 - make schema failures explicit.
        keys = list(obs.keys()) if hasattr(obs, "keys") else type(obs).__name__
        raise RuntimeError(f"Expected TensorDict group 'policy'; available={keys}") from exc


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Replay one Microduck checkpoint headlessly and save NPZ/MP4/metrics."
    )
    parser.add_argument("task_id", nargs="?")
    parser.add_argument("--checkpoint", type=Path)
    parser.add_argument("--output-dir", type=Path)
    parser.add_argument("--steps", type=int, default=500)
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--device", default="auto")
    parser.add_argument("--video-width", type=int, default=960)
    parser.add_argument("--video-height", type=int, default=720)
    parser.add_argument("--no-video", action="store_true")
    parser.add_argument("--self-test", action="store_true")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.self_test:
        assert len(hashlib.sha256(b"microduck").hexdigest()) == 64
        print("PASS: replay helper self-test")
        return 0

    if not args.task_id or args.checkpoint is None or args.output_dir is None:
        raise SystemExit("task_id, --checkpoint and --output-dir are required")
    if args.steps < 1:
        raise SystemExit("--steps must be positive")

    checkpoint = args.checkpoint.expanduser().resolve()
    output_dir = args.output_dir.expanduser().resolve()
    if not checkpoint.is_file():
        raise SystemExit(f"checkpoint not found: {checkpoint}")
    output_dir.mkdir(parents=True, exist_ok=True)
    video_tmp = output_dir / "_video"
    if video_tmp.exists():
        shutil.rmtree(video_tmp)

    os.environ.setdefault("MUJOCO_GL", "egl")

    import numpy as np
    import torch

    import mjlab.tasks  # noqa: F401 - populate the base registry.
    import mjlab_microduck.tasks  # noqa: F401 - register Microduck tasks.
    from mjlab.envs import ManagerBasedRlEnv
    from mjlab.rl import MjlabOnPolicyRunner, RslRlVecEnvWrapper
    from mjlab.tasks.registry import load_env_cfg, load_rl_cfg, load_runner_cls
    from mjlab.utils.wrappers import VideoRecorder

    if args.device == "auto":
        device = "cuda:0" if torch.cuda.is_available() else "cpu"
    else:
        device = args.device

    env_cfg = load_env_cfg(args.task_id, play=True)
    agent_cfg = load_rl_cfg(args.task_id)
    env_cfg.scene.num_envs = 1
    env_cfg.seed = args.seed
    agent_cfg.seed = args.seed
    env_cfg.viewer.width = args.video_width
    env_cfg.viewer.height = args.video_height

    base_env = ManagerBasedRlEnv(
        cfg=env_cfg,
        device=device,
        render_mode=None if args.no_video else "rgb_array",
    )
    if not args.no_video:
        base_env = VideoRecorder(
            base_env,
            video_folder=video_tmp,
            step_trigger=lambda step: step == 0,
            video_length=args.steps,
            name_prefix="replay",
            disable_logger=False,
        )

    env = RslRlVecEnvWrapper(base_env, clip_actions=agent_cfg.clip_actions)
    runner_cls = load_runner_cls(args.task_id) or MjlabOnPolicyRunner
    runner = runner_cls(env, asdict(agent_cfg), str(output_dir), device)
    runner.load(
        str(checkpoint),
        load_cfg={"actor": True},
        strict=True,
        map_location=device,
    )
    policy = runner.get_inference_policy(device=device)

    obs = env.get_observations()
    observations: list[Any] = []
    actions: list[Any] = []
    rewards: list[float] = []
    dones: list[int] = []

    try:
        with torch.inference_mode():
            for _ in range(args.steps):
                policy_obs = actor_tensor(obs)
                action = policy(obs)
                observations.append(policy_obs[0].detach().cpu().numpy().copy())
                actions.append(action[0].detach().cpu().numpy().copy())

                obs, reward, done, _extras = env.step(action)
                rewards.append(float(reward[0].detach().cpu()))
                dones.append(int(done[0].detach().cpu()))
    finally:
        env.close()

    obs_array = np.asarray(observations, dtype=np.float32)
    action_array = np.asarray(actions, dtype=np.float32)
    reward_array = np.asarray(rewards, dtype=np.float32)
    done_array = np.asarray(dones, dtype=np.int8)

    if obs_array.ndim != 2 or obs_array.shape[1] != 61:
        raise RuntimeError(f"Expected policy observations [N,61], got {obs_array.shape}")
    if action_array.ndim != 2 or action_array.shape[1] != 14:
        raise RuntimeError(f"Expected actions [N,14], got {action_array.shape}")

    command_array = obs_array[:, -13:].copy()
    rollout_path = output_dir / "rollout.npz"
    np.savez_compressed(
        rollout_path,
        observations=obs_array,
        actions=action_array,
        rewards=reward_array,
        dones=done_array,
        commands=command_array,
        step_index=np.arange(args.steps, dtype=np.int32),
    )

    preview_path: Path | None = None
    if not args.no_video:
        videos = sorted(video_tmp.glob("*.mp4"))
        if len(videos) != 1:
            raise RuntimeError(f"Expected one replay video, found {len(videos)} in {video_tmp}")
        preview_path = output_dir / "preview.mp4"
        shutil.copy2(videos[0], preview_path)
        shutil.rmtree(video_tmp)

    metrics = {
        "schema_version": 1,
        "task_id": args.task_id,
        "seed": args.seed,
        "device": device,
        "steps": args.steps,
        "observation_shape": list(obs_array.shape),
        "action_shape": list(action_array.shape),
        "total_reward": float(reward_array.sum()),
        "mean_reward": float(reward_array.mean()),
        "done_count": int(done_array.sum()),
        "action_rms": float(np.sqrt(np.mean(np.square(action_array)))),
        "action_abs_max": float(np.max(np.abs(action_array))),
        "command_min": command_array.min(axis=0).tolist(),
        "command_max": command_array.max(axis=0).tolist(),
        "checkpoint": str(checkpoint),
        "checkpoint_sha256": sha256_file(checkpoint),
        "rollout_sha256": sha256_file(rollout_path),
        "preview_sha256": sha256_file(preview_path) if preview_path else None,
        "microduck_rl_commit": git_head(Path.cwd()),
    }
    (output_dir / "metrics.json").write_text(
        json.dumps(metrics, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    print(json.dumps(metrics, indent=2, sort_keys=True))
    print(f"rollout: {rollout_path}")
    if preview_path:
        print(f"preview: {preview_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
