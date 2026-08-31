#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

POLICY="${RUNTIME_DIR}/policies/alpha_walking.onnx"
[[ -f "${POLICY}" ]] || fatal "Official walking ONNX not found: ${POLICY}"

log "Running the official walking ONNX in native CPU MuJoCo"
printf 'Use the terminal keyboard described by infer_policy.py; Ctrl+C exits.\n'
cd "${RL_DIR}"
uv run scripts/infer_policy.py \
  --walking "${POLICY}" \
  --new-cmd-obs \
  --save-csv "${ARTIFACT_ROOT}/official_walk.csv"
