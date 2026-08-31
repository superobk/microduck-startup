#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

log "Host preflight"
printf 'startup root : %s\n' "${STARTUP_ROOT}"
printf 'work root    : %s\n' "${WORK_ROOT}"
printf 'kernel       : %s\n' "$(uname -srmo)"
printf 'architecture : %s\n' "$(uname -m)"
printf 'hostname     : %s\n' "$(hostname)"

if [[ -r /etc/os-release ]]; then
  printf '\nOS release:\n'
  sed -n '1,12p' /etc/os-release
fi

printf '\nCPU / memory:\n'
command -v lscpu >/dev/null 2>&1 && lscpu | sed -n '1,16p' || true
command -v free >/dev/null 2>&1 && free -h || true
printf '\nDisk:\n'
df -h "${STARTUP_ROOT}" || true

printf '\nRequired command status:\n'
for cmd in git curl python3; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  %-14s %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '  %-14s MISSING\n' "$cmd"
  fi
done

printf '\nOptional/current tools:\n'
for cmd in node npm uv nvidia-smi; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  %-14s %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '  %-14s not installed yet\n' "$cmd"
  fi
done

printf '\nGPU status:\n'
if command -v nvidia-smi >/dev/null 2>&1; then
  nvidia-smi --query-gpu=index,name,memory.total,driver_version \
    --format=csv,noheader || nvidia-smi
else
  warn "nvidia-smi is not available. Browser simulation can still run, but local RL training cannot."
fi

printf '\nNetwork checks (DNS + GitHub):\n'
if getent hosts github.com >/dev/null 2>&1; then
  getent hosts github.com | head -n 2
else
  warn "github.com did not resolve. Upstream cloning will fail until DNS/network access works."
fi

cat <<'TXT'

PASS CRITERIA
  - git, curl and python3 are present.
  - For training: nvidia-smi sees at least one NVIDIA GPU.
  - For browser setup: install Node.js 22+ before running scripts/02_setup_browser.sh.
  - The authoritative CUDA check happens after uv sync with torch.cuda.is_available().
TXT
