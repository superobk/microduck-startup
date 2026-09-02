#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTUP="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ROOT="${1:-${MICRODUCK_HOME:-${HOME}/Microduck}}"
ROOT="$(realpath -m "${ROOT}")"
if [[ -d "${ROOT}/startup" ]]; then
  STARTUP="${ROOT}/startup"
else
  ROOT="$(realpath -m "${STARTUP}/..")"
fi

PYTHON="$(command -v python3)"
UNIT_DIR="${HOME}/.config/systemd/user"
ENV_DIR="${HOME}/.config/microduck"
OUTPUT_ROOT="${ROOT}/intelligence/local"
mkdir -p "${UNIT_DIR}" "${ENV_DIR}" "${OUTPUT_ROOT}"

python3 - \
  "${STARTUP}/ops/systemd/microduck-intelligence.service.in" \
  "${UNIT_DIR}/microduck-intelligence.service" \
  "${STARTUP}" \
  "${OUTPUT_ROOT}" \
  "${PYTHON}" <<'PY'
from pathlib import Path
import sys

source, destination, startup, output, python = map(Path, sys.argv[1:])
text = source.read_text(encoding="utf-8")
text = text.replace("@STARTUP_ROOT@", str(startup))
text = text.replace("@OUTPUT_ROOT@", str(output))
text = text.replace("@PYTHON@", str(python))
destination.write_text(text, encoding="utf-8")
PY

cp "${STARTUP}/ops/systemd/microduck-intelligence.timer" \
   "${UNIT_DIR}/microduck-intelligence.timer"

ENV_FILE="${ENV_DIR}/intelligence.env"
if [[ ! -e "${ENV_FILE}" ]]; then
  cat > "${ENV_FILE}" <<'EOF'
# Optional public RSS/Atom or compliant API feed.
# Quote values that contain spaces or special characters.
# MICRODUCK_SOCIAL_FEED_URL="https://your-feed.example/account.xml"
EOF
  chmod 600 "${ENV_FILE}"
fi

systemctl --user daemon-reload
systemctl --user enable --now microduck-intelligence.timer
systemctl --user list-timers microduck-intelligence.timer --no-pager

printf '\nInstalled local refresh timer.\n'
printf 'Environment file: %s\n' "${ENV_FILE}"
printf 'Output root:      %s\n' "${OUTPUT_ROOT}"
printf 'Run immediately: systemctl --user start microduck-intelligence.service\n'
printf 'Read logs:       journalctl --user -u microduck-intelligence.service -n 100\n'
