#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTUP_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# shellcheck disable=SC1091
source "${STARTUP_ROOT}/configs/upstreams.env"
if [[ -f "${STARTUP_ROOT}/configs/experiment.env" ]]; then
  # shellcheck disable=SC1091
  source "${STARTUP_ROOT}/configs/experiment.env"
else
  # shellcheck disable=SC1091
  source "${STARTUP_ROOT}/configs/experiment.env.example"
fi

WORK_ROOT="${MICRODUCK_WORK_ROOT:-${STARTUP_ROOT}/work}"
UPSTREAM_ROOT="${WORK_ROOT}/upstream"
ARTIFACT_ROOT="${WORK_ROOT}/artifacts"
STATE_ROOT="${WORK_ROOT}/state"
MANIFEST_ROOT="${WORK_ROOT}/manifests"
VARIANT_ROOT="${WORK_ROOT}/variants"

RL_DIR="${UPSTREAM_ROOT}/microduck_rl"
RUNTIME_DIR="${UPSTREAM_ROOT}/microduck"
MODELS_DIR="${UPSTREAM_ROOT}/MicroDuckModels"
REPLICA_DIR="${UPSTREAM_ROOT}/microduck-replica"
AWESOME_DIR="${UPSTREAM_ROOT}/awesome-microduck"

mkdir -p "${WORK_ROOT}" "${UPSTREAM_ROOT}" "${ARTIFACT_ROOT}" \
  "${STATE_ROOT}" "${MANIFEST_ROOT}" "${VARIANT_ROOT}"

log() {
  printf '\n[%s] %s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')" "$*"
}

warn() {
  printf '\n[WARN] %s\n' "$*" >&2
}

fatal() {
  printf '\n[ERROR] %s\n' "$*" >&2
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || fatal "Missing command: $1"
}

require_dir() {
  [[ -d "$1" ]] || fatal "Missing directory: $1. Run the earlier setup step first."
}

short_sha() {
  git -C "$1" rev-parse --short=12 HEAD
}
