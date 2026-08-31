#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${MODELS_DIR}"

POLICY="${1:-}"
if [[ -z "${POLICY}" && -f "${STATE_ROOT}/latest_onnx.txt" ]]; then
  POLICY="$(cat "${STATE_ROOT}/latest_onnx.txt")"
fi
[[ -f "${POLICY}" ]] || fatal "Custom ONNX not found. Export first or pass a path."

DEST_NAME="bootcamp_walk.onnx"
DEST="${MODELS_DIR}/public/policies/${DEST_NAME}"
cp -f "${POLICY}" "${DEST}"

python3 - "${MODELS_DIR}/src/game/constants.js" "${DEST_NAME}" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
name = sys.argv[2]
text = path.read_text()
pattern = r'walk:\s*`\$\{POLICY_DIR\}/[^`]+`,'
replacement = f'walk: `${{POLICY_DIR}}/{name}`,'
new, count = re.subn(pattern, replacement, text, count=1)
if count != 1:
    raise SystemExit(f"could not patch walking policy line in {path}")
path.write_text(new)
print(f"patched {path}: {replacement}")
PY

cd "${MODELS_DIR}"
npm run build

cat <<TXT

Installed: ${DEST}
The simulator now points its walking slot at ${DEST_NAME}.
Run:
  bash scripts/03_run_browser.sh
To restore the pinned upstream browser source:
  git -C "${MODELS_DIR}" restore src/game/constants.js
TXT
