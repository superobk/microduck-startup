#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

CHECKPOINT="${1:-}"
if [[ -z "${CHECKPOINT}" && -f "${STATE_ROOT}/latest_checkpoint.txt" ]]; then
  CHECKPOINT="$(cat "${STATE_ROOT}/latest_checkpoint.txt")"
fi
if [[ -z "${CHECKPOINT}" ]]; then
  bash "${STARTUP_ROOT}/scripts/08_find_checkpoint.sh"
  CHECKPOINT="$(cat "${STATE_ROOT}/latest_checkpoint.txt")"
fi
[[ -f "${CHECKPOINT}" ]] || fatal "Checkpoint does not exist: ${CHECKPOINT}"

OUT="${ARTIFACT_ROOT}/${CUSTOM_ONNX_NAME}"
log "Exporting ${CHECKPOINT} -> ${OUT}"
cd "${RL_DIR}"
uv run scripts/export.py "${TASK_ID}" \
  --checkpoint-file "${CHECKPOINT}" \
  --onnx-file "${OUT}" \
  --num-envs 1

uv run python "${STARTUP_ROOT}/scripts/10_verify_onnx.py" "${OUT}"
printf '%s\n' "${OUT}" > "${STATE_ROOT}/latest_onnx.txt"
