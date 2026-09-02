#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

PULL_ARTIFACTS=true
if [[ "${1:-}" == "--no-artifacts" ]]; then
  PULL_ARTIFACTS=false
fi

STARTUP_REPO="${MICRODUCK_HOME}/startup"
[[ -d "${STARTUP_REPO}/.git" ]] || {
  printf '[ERROR] startup repository missing: %s\n' "${STARTUP_REPO}" >&2
  exit 1
}

printf '[refresh] startup origin/main\n'
git -C "${STARTUP_REPO}" fetch --prune origin main
branch="$(git -C "${STARTUP_REPO}" symbolic-ref --short -q HEAD || printf detached)"
dirty="$(git -C "${STARTUP_REPO}" status --porcelain)"

if [[ "${branch}" == "main" && -z "${dirty}" ]]; then
  git -C "${STARTUP_REPO}" merge --ff-only origin/main
else
  printf '[WARN] startup checkout not auto-updated (branch=%s, dirty=%s)\n' \
    "${branch}" "$([[ -n "${dirty}" ]] && printf yes || printf no)" >&2
fi

printf '\n[refresh] official/community remotes (fetch only)\n'
bash "${STARTUP_REPO}/scripts/workspace/sync.sh" "${MICRODUCK_HOME}"

if [[ "${MICRODUCK_ROLE}" == "mac" && "${PULL_ARTIFACTS}" == true ]]; then
  printf '\n[refresh] GPU handoffs and published bundles\n'
  bash "${STARTUP_REPO}/scripts/sync/pull_from_gpu.sh"
fi

mkdir -p "${MICRODUCK_HOME}/sync/state"
date -u +'%Y-%m-%dT%H:%M:%SZ' > "${MICRODUCK_HOME}/sync/state/last-refresh-utc.txt"
printf '\nRefresh complete.\n'
