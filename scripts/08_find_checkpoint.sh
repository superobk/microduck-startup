#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/logs/rsl_rl"

CHECKPOINT="$(python3 - "${RL_DIR}/logs/rsl_rl" <<'PY'
from pathlib import Path
import sys

root = Path(sys.argv[1])
items = [p for p in root.rglob("model_*.pt") if p.is_file()]
if not items:
    raise SystemExit(1)
latest = max(items, key=lambda p: p.stat().st_mtime_ns)
print(latest.resolve())
PY
)" || fatal "No model_*.pt checkpoint found under ${RL_DIR}/logs/rsl_rl"

printf '%s\n' "${CHECKPOINT}" | tee "${STATE_ROOT}/latest_checkpoint.txt"
printf 'Latest checkpoint: %s\n' "${CHECKPOINT}"
