#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/portable.sh"

if ! md_is_macos; then
  printf '[ERROR] this installer is for macOS launchd.\n' >&2
  exit 1
fi

STARTUP="$(md_abs_path "${SCRIPT_DIR}/../..")"
TEMPLATE="${STARTUP}/ops/launchd/com.superobk.microduck-refresh.plist.in"
DEST="${HOME}/Library/LaunchAgents/com.superobk.microduck-refresh.plist"
LOG_DIR="${HOME}/Library/Logs/Microduck"
mkdir -p "$(dirname "${DEST}")" "${LOG_DIR}"

python3 - "${TEMPLATE}" "${DEST}" "${STARTUP}" "${HOME}" "${LOG_DIR}" "${PATH}" <<'PY'
from pathlib import Path
from xml.sax.saxutils import escape
import sys

source, destination, startup, home, log_dir, path = sys.argv[1:]
text = Path(source).read_text(encoding="utf-8")
replacements = {
    "@REFRESH_SCRIPT@": f"{startup}/scripts/sync/refresh_local.sh",
    "@HOME@": home,
    "@LOG_DIR@": log_dir,
    "@PATH@": path,
}
for key, value in replacements.items():
    text = text.replace(key, escape(value))
Path(destination).write_text(text, encoding="utf-8")
PY

plutil -lint "${DEST}"

domain="gui/$(id -u)"
launchctl bootout "${domain}" "${DEST}" >/dev/null 2>&1 || true
if launchctl bootstrap "${domain}" "${DEST}"; then
  launchctl enable "${domain}/com.superobk.microduck-refresh" || true
  launchctl kickstart -k "${domain}/com.superobk.microduck-refresh" || true
else
  # Compatibility fallback for older macOS.
  launchctl load -w "${DEST}"
fi

cat <<EOF

Installed:
  ${DEST}

Runs at login and every six hours:
  ${STARTUP}/scripts/sync/refresh_local.sh

Inspect:
  launchctl print ${domain}/com.superobk.microduck-refresh
  tail -f ${LOG_DIR}/refresh.stdout.log
  tail -f ${LOG_DIR}/refresh.stderr.log
EOF
