#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

REMOTE="${1:-}"
[[ -n "${REMOTE}" ]] || fatal "Usage: bash scripts/18_ssh_tunnel.sh USER@GPU_HOST"

exec ssh -N \
  -L "${BROWSER_PORT}:127.0.0.1:${BROWSER_PORT}" \
  -L "${TENSORBOARD_PORT}:127.0.0.1:${TENSORBOARD_PORT}" \
  -L "${VISER_PORT}:127.0.0.1:${VISER_PORT}" \
  "${REMOTE}"
