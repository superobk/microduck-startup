#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.venv"

log "Listing registered MicroDuck tasks"
cd "${RL_DIR}"
uv run list-envs | grep -E 'MicroDuck|microduck' || true

log "Running CPU configuration and reward regression tests"
uv run --with pytest pytest -q tests/
