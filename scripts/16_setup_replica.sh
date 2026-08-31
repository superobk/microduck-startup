#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${REPLICA_DIR}"
require_dir "${RL_DIR}"
require_cmd python3

log "Preparing mechanical reconstruction environment"
python3 -m venv "${REPLICA_DIR}/.venv"
"${REPLICA_DIR}/.venv/bin/python" -m pip install --upgrade pip
"${REPLICA_DIR}/.venv/bin/python" -m pip install mujoco numpy pillow scipy

mkdir -p "${REPLICA_DIR}/upstream"
ln -sfn "${RL_DIR}" "${REPLICA_DIR}/upstream/microduck_rl"
ln -sfn "${RUNTIME_DIR}" "${REPLICA_DIR}/upstream/microduck"

cat <<TXT
Replica environment ready.
Rebuild drawings and transformed STL assemblies with:
  bash scripts/17_rebuild_replica.sh
TXT
