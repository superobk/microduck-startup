#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RUNTIME_DIR}/policies"

expected=(
  alpha_walking.onnx
  alpha_stand.onnx
  alpha_sitstand.onnx
  alpha_ground_pick.onnx
  ball_kick_left.onnx
  ball_kick_right.onnx
  roulade.onnx
  roller.onnx
  roller_crouch.onnx
)

missing=0
printf '%-32s %-12s %s\n' MODEL BYTES SHA256
for name in "${expected[@]}"; do
  path="${RUNTIME_DIR}/policies/${name}"
  if [[ ! -f "${path}" ]]; then
    printf '%-32s MISSING\n' "${name}"
    missing=1
    continue
  fi
  bytes="$(wc -c < "${path}")"
  hash="$(sha256sum "${path}" | awk '{print $1}')"
  printf '%-32s %-12s %s\n' "${name}" "${bytes}" "${hash}"
done

(( missing == 0 )) || fatal "One or more official ONNX policies are missing. Check the pinned runtime checkout."
printf '\nPASS: all official ONNX policies are present.\n'
