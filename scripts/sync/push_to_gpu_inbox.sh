#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
sync_require_mac_remote
md_require_cmd rsync

SOURCE="${1:-${MICRODUCK_HOME}/artifacts/to-gpu}"
[[ -d "${SOURCE}" ]] || {
  printf '[ERROR] source directory not found: %s\n' "${SOURCE}" >&2
  exit 1
}

ssh "${MICRODUCK_GPU_SSH}" "mkdir -p '${MICRODUCK_GPU_HOME}/artifacts/inbox-from-mac'"

rsync "${SYNC_RSYNC_ARGS[@]}" --itemize-changes \
  "${SOURCE}/" \
  "${MICRODUCK_GPU_SSH}:${MICRODUCK_GPU_HOME}/artifacts/inbox-from-mac/"

cat <<EOF

Uploaded to the GPU inbox only:
  ${MICRODUCK_GPU_HOME}/artifacts/inbox-from-mac/

Inspect checksums and contents on the GPU before moving anything into an
experiment, policy or hardware reference directory.
EOF
