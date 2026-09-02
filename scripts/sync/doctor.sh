#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

failures=0
check() {
  local label="$1"
  shift
  if "$@" >/dev/null 2>&1; then
    printf '[OK]   %s\n' "${label}"
  else
    printf '[FAIL] %s\n' "${label}"
    failures=$((failures + 1))
  fi
}

printf 'Microduck sync doctor\n'
printf '  role:      %s\n' "${MICRODUCK_ROLE:-unset}"
printf '  workspace: %s\n\n' "${MICRODUCK_HOME}"

case "${MICRODUCK_ROLE}" in
  mac|gpu) ;;
  *)
    printf '[FAIL] MICRODUCK_ROLE must be mac or gpu in %s\n' "${MACHINE_ENV}" >&2
    failures=$((failures + 1))
    ;;
esac

check "workspace marker" test -f "${MICRODUCK_HOME}/.microduck-workspace.json"
check "startup repository" test -d "${MICRODUCK_HOME}/startup/.git"
check "git available" command -v git
check "python3 available" command -v python3
check "rsync available" command -v rsync
check "portable path helper" test "$(md_abs_path "${MICRODUCK_HOME}")" = "${MICRODUCK_HOME}"

if [[ -d "${MICRODUCK_HOME}/startup/.git" ]]; then
  printf '\nStartup Git state:\n'
  git -C "${MICRODUCK_HOME}/startup" status --short --branch
  git -C "${MICRODUCK_HOME}/startup" fetch --quiet origin main || {
    printf '[WARN] unable to fetch startup origin/main\n'
  }
  counts="$(git -C "${MICRODUCK_HOME}/startup" rev-list --left-right --count HEAD...origin/main 2>/dev/null || printf 'unknown')"
  printf '  HEAD...origin/main: %s (left=local-only, right=remote-only)\n' "${counts}"
fi

if [[ "${MICRODUCK_ROLE}" == "mac" ]]; then
  sync_require_mac_remote || failures=$((failures + 1))
  if [[ -n "${MICRODUCK_GPU_SSH:-}" && "${MICRODUCK_GPU_HOME:-}" == /* ]]; then
    printf '\nGPU link:\n'
    if ssh -o BatchMode=yes -o ConnectTimeout=8 "${MICRODUCK_GPU_SSH}" \
      "test -f '${MICRODUCK_GPU_HOME}/.microduck-workspace.json'"; then
      printf '[OK]   SSH and remote workspace marker\n'
      ssh "${MICRODUCK_GPU_SSH}" \
        "printf '  host: '; hostname; printf '  workspace: ${MICRODUCK_GPU_HOME}\n'; df -h '${MICRODUCK_GPU_HOME}' | tail -n 1"
    else
      printf '[FAIL] SSH alias or remote workspace is not ready\n'
      failures=$((failures + 1))
    fi
  fi
else
  printf '\nGPU checks:\n'
  check "nvidia-smi" command -v nvidia-smi
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=index,name,memory.total,driver_version --format=csv,noheader || true
  fi
fi

printf '\nHugging Face auth:\n'
if command -v hf >/dev/null 2>&1; then
  hf auth whoami || printf '[WARN] hf CLI is installed but not authenticated\n'
elif command -v uvx >/dev/null 2>&1; then
  printf '[INFO] use: uvx --from huggingface_hub hf auth whoami\n'
else
  printf '[INFO] install uv, then authenticate only when publishing\n'
fi

if (( failures > 0 )); then
  printf '\nSync doctor found %d blocking issue(s).\n' "${failures}" >&2
  exit 1
fi
printf '\nPASS: control-plane and compute-plane connection is ready.\n'
