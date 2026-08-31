#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

POLICY="${1:-}"
if [[ -z "${POLICY}" && -f "${STATE_ROOT}/latest_onnx.txt" ]]; then
  POLICY="$(cat "${STATE_ROOT}/latest_onnx.txt")"
fi
[[ -f "${POLICY}" ]] || fatal "Custom ONNX not found. Export first or pass a path."

log "Running custom policy: ${POLICY}"
cd "${RL_DIR}"
uv run scripts/infer_policy.py \
  --walking "${POLICY}" \
  --new-cmd-obs \
  --save-csv "${ARTIFACT_ROOT}/custom_walk.csv"
