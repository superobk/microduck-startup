SHELL := /usr/bin/env bash

.PHONY: help preflight clone browser-setup browser rl-setup rl-test smoke train checkpoint export infer-official infer-custom browser-install-policy no-push manifest replica-setup replica-build tensorboard models-check validate syllabus \
	workspace-bootstrap workspace-sync workspace-status handoff intelligence-refresh intelligence-timer-install \
	sync-doctor sync-refresh sync-pull sync-push tunnel macos-agent-install \
	one-day one-day-setup one-day-smoke one-day-train one-day-export one-day-replay one-day-package one-day-publish-model one-day-publish-space

help:
	@printf '%s\n' \
	  'WORKSPACE / SYNC' \
	  '  make workspace-bootstrap       Create ~/Microduck and clone pinned repos' \
	  '  make workspace-sync            Fetch official/community remotes without moving pins' \
	  '  make workspace-status          Show branch/SHA/dirty state' \
	  '  make sync-doctor               Check Mac/GPU roles, SSH and workspace markers' \
	  '  make sync-refresh              Safe ff-only startup refresh + upstream fetch + Mac pull' \
	  '  make sync-pull                 Mac: pull handoffs/reports/published bundles from GPU' \
	  '  make sync-push                 Mac: upload artifacts/to-gpu into GPU inbox' \
	  '  make tunnel                    Mac: forward Vite/TensorBoard/Viser ports' \
	  '  make macos-agent-install       Install six-hour launchd refresh on macOS' \
	  '  make handoff                   Generate notes/handoffs/LATEST.md' \
	  '' \
	  'ONE-DAY PPO PIPELINE' \
	  '  make one-day                  setup -> smoke -> train -> export -> replay -> package' \
	  '  make one-day-setup            CUDA environment and tests' \
	  '  make one-day-smoke            64-env / 5-iteration gate' \
	  '  make one-day-train            PPO on-policy collection and training' \
	  '  make one-day-export           official checkpoint -> ONNX' \
	  '  make one-day-replay           headless replay -> NPZ + MP4 + metrics' \
	  '  make one-day-package          Hub-ready immutable bundle' \
	  '  make one-day-publish-model    publish bundle to configured HF model repo' \
	  '  make one-day-publish-space    publish to configured personal duplicate Space' \
	  '' \
	  'LEGACY / LOW-LEVEL' \
	  '  make preflight                Inspect host, GPU and tools' \
	  '  make clone                    Clone pinned upstreams into startup/work' \
	  '  make models-check             Verify official ONNX policies' \
	  '  make browser-setup            npm ci + production browser build' \
	  '  make browser                  Start browser simulator' \
	  '  make rl-setup                 Install uv/RL env and verify CUDA' \
	  '  make rl-test                  List envs and run tests' \
	  '  make smoke                    Baseline walking smoke test' \
	  '  make tensorboard              Start TensorBoard' \
	  '  make train                    Baseline walking training' \
	  '  make checkpoint              Locate latest model_*.pt' \
	  '  make export                   Export latest ONNX' \
	  '  make validate                 Static validation and self-tests'

workspace-bootstrap:
	bash scripts/workspace/bootstrap.sh "$${MICRODUCK_HOME:-$$HOME/Microduck}"

workspace-sync:
	bash scripts/workspace/sync.sh "$${MICRODUCK_HOME:-$$HOME/Microduck}"

workspace-status:
	bash scripts/workspace/status.sh "$${MICRODUCK_HOME:-$$HOME/Microduck}"

sync-doctor:
	bash scripts/sync/doctor.sh

sync-refresh:
	bash scripts/sync/refresh_local.sh

sync-pull:
	bash scripts/sync/pull_from_gpu.sh

sync-push:
	bash scripts/sync/push_to_gpu_inbox.sh

tunnel:
	bash scripts/sync/tunnel.sh

macos-agent-install:
	bash scripts/sync/install_macos_agent.sh

handoff:
	bash scripts/workspace/handoff.sh "$${MICRODUCK_HOME:-$$HOME/Microduck}"

intelligence-refresh:
	python3 scripts/intelligence/refresh.py --config configs/intelligence-sources.json --output-root intelligence

intelligence-timer-install:
	bash scripts/intelligence/install_user_timer.sh

one-day:
	bash scripts/one_day/run.sh all

one-day-setup:
	bash scripts/one_day/run.sh setup

one-day-smoke:
	bash scripts/one_day/run.sh smoke

one-day-train:
	bash scripts/one_day/run.sh train

one-day-export:
	bash scripts/one_day/run.sh export

one-day-replay:
	bash scripts/one_day/run.sh replay

one-day-package:
	bash scripts/one_day/run.sh package

one-day-publish-model:
	bash scripts/one_day/run.sh publish-model

one-day-publish-space:
	bash scripts/one_day/run.sh publish-space

preflight:
	bash scripts/00_preflight_host.sh

clone:
	bash scripts/01_clone_upstreams.sh

models-check:
	bash scripts/20_check_official_models.sh

browser-setup:
	bash scripts/02_setup_browser.sh

browser:
	bash scripts/03_run_browser.sh

rl-setup:
	bash scripts/04_setup_rl.sh

rl-test:
	bash scripts/05_rl_tests.sh

smoke:
	bash scripts/06_rl_smoke.sh

tensorboard:
	bash scripts/19_tensorboard.sh

train:
	bash scripts/07_train_walking.sh

checkpoint:
	bash scripts/08_find_checkpoint.sh

export:
	bash scripts/09_export_onnx.sh

infer-official:
	bash scripts/11_infer_official.sh

infer-custom:
	bash scripts/12_infer_custom.sh

browser-install-policy:
	bash scripts/13_install_policy_browser.sh

no-push:
	bash scripts/14_create_no_push_worktree.sh

manifest:
	bash scripts/15_record_manifest.sh

replica-setup:
	bash scripts/16_setup_replica.sh

replica-build:
	bash scripts/17_rebuild_replica.sh

syllabus:
	@cat docs/00-system-and-code-map.md
	@cat docs/01-two-day-runbook.md
	@cat docs/14-macos-gpu-sync-v2.md
	@cat docs/15-one-day-ppo-e2e.md
	@cat docs/16-huggingface-space-integration.md

validate:
	find scripts -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
	python3 -m compileall -q scripts
	python3 -m json.tool configs/workspace-repos.json >/dev/null
	python3 -m json.tool configs/intelligence-sources.json >/dev/null
	python3 -m json.tool configs/one-day-profiles.json >/dev/null
	python3 -m json.tool configs/hf-space-slots.json >/dev/null
	python3 scripts/one_day/replay_checkpoint.py --self-test
	python3 scripts/hf/stage_space.py --self-test
	@echo 'PASS: startup, sync, one-day and HF publication scripts'
