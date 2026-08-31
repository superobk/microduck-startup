#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_cmd git

clone_pinned() {
  local name="$1"
  local repo="$2"
  local ref="$3"
  local dest="$4"

  log "Preparing ${name} at ${ref}"
  if [[ ! -d "${dest}/.git" ]]; then
    git clone --filter=blob:none "${repo}" "${dest}"
  fi

  git -C "${dest}" remote set-url origin "${repo}"
  if ! git -C "${dest}" cat-file -e "${ref}^{commit}" 2>/dev/null; then
    git -C "${dest}" fetch --depth=1 origin "${ref}"
  fi
  git -C "${dest}" checkout --detach "${ref}"

  local actual
  actual="$(git -C "${dest}" rev-parse HEAD)"
  [[ "${actual}" == "${ref}" ]] || fatal "${name}: expected ${ref}, got ${actual}"
}

clone_pinned microduck_rl "${MICRODUCK_RL_REPO}" "${MICRODUCK_RL_REF}" "${RL_DIR}"
clone_pinned microduck-runtime "${MICRODUCK_RUNTIME_REPO}" "${MICRODUCK_RUNTIME_REF}" "${RUNTIME_DIR}"
clone_pinned MicroDuckModels "${MICRODUCK_MODELS_REPO}" "${MICRODUCK_MODELS_REF}" "${MODELS_DIR}"
clone_pinned microduck-replica "${MICRODUCK_REPLICA_REPO}" "${MICRODUCK_REPLICA_REF}" "${REPLICA_DIR}"
clone_pinned awesome-microduck "${AWESOME_MICRODUCK_REPO}" "${AWESOME_MICRODUCK_REF}" "${AWESOME_DIR}"

VERSIONS="${STATE_ROOT}/upstream-versions.tsv"
{
  printf 'name\trepository\tcommit\n'
  printf 'microduck_rl\t%s\t%s\n' "${MICRODUCK_RL_REPO}" "$(git -C "${RL_DIR}" rev-parse HEAD)"
  printf 'microduck\t%s\t%s\n' "${MICRODUCK_RUNTIME_REPO}" "$(git -C "${RUNTIME_DIR}" rev-parse HEAD)"
  printf 'MicroDuckModels\t%s\t%s\n' "${MICRODUCK_MODELS_REPO}" "$(git -C "${MODELS_DIR}" rev-parse HEAD)"
  printf 'microduck-replica\t%s\t%s\n' "${MICRODUCK_REPLICA_REPO}" "$(git -C "${REPLICA_DIR}" rev-parse HEAD)"
  printf 'awesome-microduck\t%s\t%s\n' "${AWESOME_MICRODUCK_REPO}" "$(git -C "${AWESOME_DIR}" rev-parse HEAD)"
} | tee "${VERSIONS}"

log "Pinned upstreams are ready"
printf 'Version record: %s\n' "${VERSIONS}"
