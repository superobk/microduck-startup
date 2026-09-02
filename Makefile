SHELL := /usr/bin/env bash

.PHONY: help preflight clone browser-setup browser rl-setup rl-test smoke train checkpoint export infer-official infer-custom browser-install-policy no-push manifest replica-setup replica-build tunnel tensorboard models-check workspace-bootstrap workspace-sync workspace-status handoff intelligence-refresh intelligence-timer-install validate

help:
	@printf '%s\n' \
	  'make workspace-bootstrap      Create ~/Microduck and clone/link every repository' \
	  'make workspace-sync           Fetch all official/community remotes without changing work' \
	  'make workspace-status         Show pins, branches, dirty state and local revisions' \
	  'make handoff                  Generate a GPU-workstation handoff snapshot' \
	  'make intelligence-refresh     Refresh GitHub and configured social feeds locally' \
	  'make intelligence-timer-install Install a six-hour user timer on the workstation' \
	  'make preflight               Inspect host, GPU and tools' \
	  'make clone                   Clone all pinned upstream repositories' \
	  'make models-check            Verify the nine official ONNX policies' \
	  'make browser-setup           npm ci + production build' \
	  'make browser                 Start Vite browser simulator' \
	  'make rl-setup                Install uv, resolve RL env, verify CUDA' \
	  'make rl-test                 List envs and run tests' \
	  'make smoke                   64-env / 5-iteration smoke test' \
	  'make tensorboard             Start TensorBoard on 127.0.0.1:6006' \
	  'make train                   Start walking training' \
	  'make checkpoint              Record latest model_*.pt path' \
	  'make export                  Export and verify latest ONNX' \
	  'make infer-official          Run official walking ONNX in native MuJoCo' \
	  'make infer-custom            Run latest custom ONNX in native MuJoCo' \
	  'make browser-install-policy  Install latest custom ONNX into browser sim' \
	  'make no-push                 Create the single-variable no-push worktree' \
	  'make manifest                Record versions, environment and hashes' \
	  'make replica-setup           Prepare mechanical reconstruction venv' \
	  'make replica-build           Rebuild drawings/STL/hole analysis' \
	  'make validate                Check shell, Python and JSON syntax'

workspace-bootstrap:
	bash scripts/workspace/bootstrap.sh

workspace-sync:
	bash scripts/workspace/sync.sh

workspace-status:
	bash scripts/workspace/status.sh

handoff:
	bash scripts/workspace/handoff.sh

intelligence-refresh:
	python3 scripts/intelligence/refresh.py

intelligence-timer-install:
	bash scripts/intelligence/install_user_timer.sh

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

tunnel:
	@echo 'Usage: bash scripts/18_ssh_tunnel.sh USER@GPU_HOST'

validate:
	@find scripts -type f -name '*.sh' -print0 | xargs -0 -n1 bash -n
	@find scripts -type f -name '*.py' -print0 | xargs -0 -n1 python3 -m py_compile
	@python3 -m json.tool configs/workspace-repos.json >/dev/null
	@python3 -m json.tool configs/intelligence-sources.json >/dev/null
	@echo 'PASS: shell, Python and JSON syntax'
