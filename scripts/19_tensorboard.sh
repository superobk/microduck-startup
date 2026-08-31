#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

cd "${RL_DIR}"
exec uv run --with tensorboard tensorboard \
  --logdir logs/rsl_rl \
  --host "${TENSORBOARD_HOST}" \
  --port "${TENSORBOARD_PORT}"
