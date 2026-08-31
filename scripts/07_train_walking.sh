#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

log "Walking training: task=${TASK_ID}, envs=${TRAIN_ENVS}, iterations=${TRAIN_ITERS}, GPU=${CUDA_VISIBLE_DEVICES}, seed=${SEED}"
cd "${RL_DIR}"
CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES}" \
uv run train "${TASK_ID}" \
  --env.scene.num-envs "${TRAIN_ENVS}" \
  --agent.max_iterations "${TRAIN_ITERS}" \
  --agent.logger "${LOGGER}" \
  --agent.run-name "${TRAIN_RUN_NAME}" \
  --agent.seed "${SEED}"
