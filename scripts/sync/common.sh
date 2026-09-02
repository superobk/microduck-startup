#!/usr/bin/env bash
set -euo pipefail

SYNC_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SYNC_SCRIPT_DIR}/../lib/portable.sh"

SYNC_STARTUP="$(md_abs_path "${SYNC_SCRIPT_DIR}/../..")"
MACHINE_ENV="${SYNC_STARTUP}/configs/machine.env"
if [[ ! -f "${MACHINE_ENV}" ]]; then
  printf '[ERROR] missing %s\n' "${MACHINE_ENV}" >&2
  printf 'Run scripts/workspace/bootstrap.sh, then edit the generated machine config.\n' >&2
  exit 1
fi
# shellcheck disable=SC1090
source "${MACHINE_ENV}"

MICRODUCK_HOME="$(md_abs_path "${MICRODUCK_HOME:-${HOME}/Microduck}")"
MICRODUCK_ROLE="${MICRODUCK_ROLE:-}"

SYNC_RSYNC_ARGS=(
  -a
  --partial
  --partial-dir=.rsync-partial
  --human-readable
  --exclude=.DS_Store
  --exclude=.rsync-partial/
)
if [[ "${MICRODUCK_RSYNC_BWLIMIT:-0}" != "0" ]]; then
  SYNC_RSYNC_ARGS+=("--bwlimit=${MICRODUCK_RSYNC_BWLIMIT}")
fi

sync_require_mac_remote() {
  [[ "${MICRODUCK_ROLE}" == "mac" ]] || {
    printf '[ERROR] this command is for the macOS control plane; role=%s\n' "${MICRODUCK_ROLE:-unset}" >&2
    return 1
  }
  [[ -n "${MICRODUCK_GPU_SSH:-}" ]] || {
    printf '[ERROR] set MICRODUCK_GPU_SSH in %s\n' "${MACHINE_ENV}" >&2
    return 1
  }
  [[ "${MICRODUCK_GPU_HOME:-}" == /* ]] || {
    printf '[ERROR] MICRODUCK_GPU_HOME must be an absolute remote path in %s\n' "${MACHINE_ENV}" >&2
    return 1
  }
}
