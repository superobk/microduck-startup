#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_STARTUP="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ROOT="${1:-${MICRODUCK_HOME:-${HOME}/Microduck}}"
ROOT="$(realpath -m "${ROOT}")"
DEST_STARTUP="${ROOT}/startup"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf '[ERROR] missing command: %s\n' "$1" >&2
    exit 1
  }
}

require_cmd git
require_cmd python3
require_cmd realpath

printf '[workspace] root: %s\n' "${ROOT}"
mkdir -p "${ROOT}"

if [[ "$(realpath -m "${SOURCE_STARTUP}")" == "$(realpath -m "${DEST_STARTUP}")" ]]; then
  ORCH="${SOURCE_STARTUP}"
elif [[ -d "${DEST_STARTUP}/.git" ]]; then
  ORCH="${DEST_STARTUP}"
else
  origin="$(git -C "${SOURCE_STARTUP}" remote get-url origin 2>/dev/null || printf '%s' 'https://github.com/superobk/microduck-startup.git')"
  printf '[workspace] cloning startup -> %s\n' "${DEST_STARTUP}"
  git clone "${origin}" "${DEST_STARTUP}"
  ORCH="${DEST_STARTUP}"
fi

mkdir -p \
  "${ROOT}/official" \
  "${ROOT}/community" \
  "${ROOT}/hardware/mechanical/references" \
  "${ROOT}/hardware/mechanical/measurements" \
  "${ROOT}/hardware/mechanical/printable" \
  "${ROOT}/hardware/mechanical/validation" \
  "${ROOT}/hardware/electronics" \
  "${ROOT}/hardware/controller-alternatives" \
  "${ROOT}/hardware/bom" \
  "${ROOT}/simulation/envs" \
  "${ROOT}/simulation/browser" \
  "${ROOT}/simulation/policies/custom" \
  "${ROOT}/simulation/checkpoints" \
  "${ROOT}/simulation/mujoco/models" \
  "${ROOT}/simulation/mujoco/scenes" \
  "${ROOT}/simulation/mujoco/exports" \
  "${ROOT}/simulation/mujoco/system-id" \
  "${ROOT}/datasets/raw" \
  "${ROOT}/datasets/curated" \
  "${ROOT}/datasets/manifests" \
  "${ROOT}/datasets/frozen-eval" \
  "${ROOT}/experiments/runs" \
  "${ROOT}/experiments/worktrees" \
  "${ROOT}/experiments/manifests" \
  "${ROOT}/experiments/reports" \
  "${ROOT}/artifacts" \
  "${ROOT}/intelligence/local" \
  "${ROOT}/intelligence/exports" \
  "${ROOT}/notes/handoffs"

if command -v rsync >/dev/null 2>&1; then
  rsync -a --ignore-existing "${ORCH}/workspace-template/" "${ROOT}/"
else
  cp -an "${ORCH}/workspace-template/." "${ROOT}/"
fi

MANIFEST="${ORCH}/configs/workspace-repos.json"
[[ -f "${MANIFEST}" ]] || {
  printf '[ERROR] missing manifest: %s\n' "${MANIFEST}" >&2
  exit 1
}

while IFS=$'\t' read -r name category rel_path url ref checkout tracking required; do
  [[ "${name}" == "microduck-startup" ]] && continue
  dest="${ROOT}/${rel_path}"
  printf '[workspace] %-22s %s\n' "${name}" "${dest}"

  if [[ ! -d "${dest}/.git" ]]; then
    mkdir -p "$(dirname "${dest}")"
    git clone --filter=blob:none --no-checkout "${url}" "${dest}"
  fi

  git -C "${dest}" remote set-url origin "${url}"
  git -C "${dest}" fetch --prune origin "${tracking}" || true
  if ! git -C "${dest}" cat-file -e "${ref}^{commit}" 2>/dev/null; then
    git -C "${dest}" fetch --depth=1 origin "${ref}"
  fi

  if [[ -z "$(git -C "${dest}" status --porcelain)" ]]; then
    if [[ "${checkout}" == "detached" ]]; then
      git -C "${dest}" checkout --detach "${ref}"
    else
      git -C "${dest}" checkout "${ref}"
    fi
  else
    printf '[WARN] %s is dirty; fetched remote but left checkout unchanged\n' "${dest}" >&2
  fi
done < <(
  python3 - "${MANIFEST}" <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
for item in data["repos"]:
    fields = [
        item["name"],
        item["category"],
        item["path"],
        item["url"],
        item["ref"],
        item["checkout"],
        item.get("tracking_branch", ""),
        str(item.get("required", True)).lower(),
    ]
    print("\t".join(fields))
PY
)

safe_link() {
  local target="$1"
  local link="$2"
  mkdir -p "$(dirname "${link}")"
  if [[ -L "${link}" ]]; then
    ln -sfn "${target}" "${link}"
  elif [[ -e "${link}" ]]; then
    printf '[WARN] not replacing existing non-symlink: %s\n' "${link}" >&2
  else
    ln -s "${target}" "${link}"
  fi
}

mkdir -p "${ORCH}/work/upstream" "${ORCH}/work/state"
safe_link "../../../official/microduck" "${ORCH}/work/upstream/microduck"
safe_link "../../../official/microduck_rl" "${ORCH}/work/upstream/microduck_rl"
safe_link "../../../community/MicroDuckModels" "${ORCH}/work/upstream/MicroDuckModels"
safe_link "../../../community/microduck-replica" "${ORCH}/work/upstream/microduck-replica"
safe_link "../../../community/awesome-microduck" "${ORCH}/work/upstream/awesome-microduck"
safe_link "../../artifacts" "${ORCH}/work/artifacts"
safe_link "../../experiments/manifests" "${ORCH}/work/manifests"
safe_link "../../experiments/worktrees" "${ORCH}/work/variants"

safe_link "../../official/microduck_rl" "${ROOT}/simulation/envs/microduck_rl"
safe_link "../../community/MicroDuckModels" "${ROOT}/simulation/browser/MicroDuckModels"
safe_link "../../official/microduck/policies" "${ROOT}/simulation/policies/official"
safe_link "../../../official/microduck_rl/src/mjlab_microduck/robot/microduck" "${ROOT}/hardware/mechanical/references/official-assets"
safe_link "../../../community/microduck-replica" "${ROOT}/hardware/mechanical/references/microduck-replica"
safe_link "../startup/intelligence" "${ROOT}/intelligence/tracked"

python3 - "${ROOT}" "${ORCH}" <<'PY'
import datetime as dt
import json
import pathlib
import sys

root = pathlib.Path(sys.argv[1])
startup = pathlib.Path(sys.argv[2])
state = {
    "schema_version": 1,
    "workspace": str(root),
    "startup": str(startup),
    "created_or_refreshed_utc": dt.datetime.now(dt.timezone.utc).isoformat(),
}
(root / ".microduck-workspace.json").write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
PY

printf '\n[workspace] ready\n'
printf '  cd %s\n' "${ORCH}"
printf '  make workspace-status\n'
printf '  make preflight\n'
printf '  make rl-setup\n'
printf '  make rl-test\n'
printf '  make smoke\n'
