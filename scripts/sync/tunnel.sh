#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
sync_require_mac_remote

printf 'Forwarding browser=%s, TensorBoard=%s, Viser=%s through %s\n' \
  "${MICRODUCK_BROWSER_PORT}" \
  "${MICRODUCK_TENSORBOARD_PORT}" \
  "${MICRODUCK_VISER_PORT}" \
  "${MICRODUCK_GPU_SSH}"

exec ssh -N \
  -o ExitOnForwardFailure=yes \
  -o ServerAliveInterval=30 \
  -o ServerAliveCountMax=4 \
  -L "${MICRODUCK_BROWSER_PORT}:127.0.0.1:${MICRODUCK_BROWSER_PORT}" \
  -L "${MICRODUCK_TENSORBOARD_PORT}:127.0.0.1:${MICRODUCK_TENSORBOARD_PORT}" \
  -L "${MICRODUCK_VISER_PORT}:127.0.0.1:${MICRODUCK_VISER_PORT}" \
  "${MICRODUCK_GPU_SSH}"
