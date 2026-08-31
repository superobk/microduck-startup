#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

log "RL smoke test: task=${TASK_ID}, envs=${SMOKE_ENVS}, iterations=${SMOKE_ITERS}, GPU=${CUDA_VISIBLE_DEVICES}"
cd "${RL_DIR}"
CUDA_VISIBLE_DEVICES="${CUDA_VISIBLE_DEVICES}" \
uv run train "${TASK_ID}" \
  --env.scene.num-envs "${SMOKE_ENVS}" \
  --agent.max_iterations "${SMOKE_ITERS}" \
  --agent.logger "${LOGGER}" \
  --agent.run-name "${SMOKE_RUN_NAME}" \
  --agent.seed "${SEED}"

cat <<'TXT'

PASS CRITERIA
  - The environment compiles and reaches iteration 5.
  - No NaN/Inf or observation/action shape exception appears.
  - A run directory is created under logs/rsl_rl/.
  - Do not start the long run until this step passes.
TXT
