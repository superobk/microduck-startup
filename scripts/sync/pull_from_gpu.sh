#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
sync_require_mac_remote
md_require_cmd rsync

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
fi

args=("${SYNC_RSYNC_ARGS[@]}" --itemize-changes)
if [[ "${DRY_RUN}" == true ]]; then
  args+=(-n)
fi

paths=(
  "notes/handoffs"
  "notes/shared"
  "experiments/reports"
  "experiments/manifests"
  "artifacts/published"
)

printf 'Pulling immutable/reviewable outputs from %s\n' "${MICRODUCK_GPU_SSH}"
for rel in "${paths[@]}"; do
  mkdir -p "${MICRODUCK_HOME}/${rel}"
  printf '\n[sync] %s\n' "${rel}"
  rsync "${args[@]}" \
    "${MICRODUCK_GPU_SSH}:${MICRODUCK_GPU_HOME}/${rel}/" \
    "${MICRODUCK_HOME}/${rel}/"
done

printf '\nDone. No --delete was used; active logs, raw datasets, worktrees and .git directories were not synchronized.\n'
