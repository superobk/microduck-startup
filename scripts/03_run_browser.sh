#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${MODELS_DIR}/node_modules"

log "Starting browser simulator on ${BROWSER_HOST}:${BROWSER_PORT}"
printf 'Remote access from your Mac:\n'
printf '  ssh -L %s:127.0.0.1:%s USER@GPU_HOST\n' "${BROWSER_PORT}" "${BROWSER_PORT}"
printf 'Then open http://127.0.0.1:%s\n\n' "${BROWSER_PORT}"

cd "${MODELS_DIR}"
exec npm run dev -- --host "${BROWSER_HOST}" --port "${BROWSER_PORT}"
