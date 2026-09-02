#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTUP="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ROOT="${MICRODUCK_HOME:-${HOME}/Microduck}"
APPLY_PINS=false

for arg in "$@"; do
  case "${arg}" in
    --pins) APPLY_PINS=true ;;
    *) ROOT="${arg}" ;;
  esac
done
ROOT="$(realpath -m "${ROOT}")"
MANIFEST="${ROOT}/startup/configs/workspace-repos.json"
[[ -f "${MANIFEST}" ]] || MANIFEST="${STARTUP}/configs/workspace-repos.json"

python3 - "${MANIFEST}" <<'PY' | while IFS=$'\t' read -r name rel_path url ref checkout tracking; do
import json
import sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
for x in data["repos"]:
    print("\t".join([x["name"], x["path"], x["url"], x["ref"], x["checkout"], x.get("tracking_branch", "")]))
PY
  repo="${ROOT}/${rel_path}"
  if [[ ! -d "${repo}/.git" ]]; then
    printf '[WARN] missing %-22s %s\n' "${name}" "${repo}" >&2
    continue
  fi
  printf '[fetch] %-22s origin/%s\n' "${name}" "${tracking}"
  git -C "${repo}" remote set-url origin "${url}"
  git -C "${repo}" fetch --prune --tags origin

  if [[ "${APPLY_PINS}" == true && "${checkout}" == "detached" ]]; then
    if [[ -z "$(git -C "${repo}" status --porcelain)" ]]; then
      git -C "${repo}" cat-file -e "${ref}^{commit}" 2>/dev/null || git -C "${repo}" fetch origin "${ref}"
      git -C "${repo}" checkout --detach "${ref}"
    else
      printf '[WARN] dirty; pin not applied: %s\n' "${repo}" >&2
    fi
  fi
done

bash "${ROOT}/startup/scripts/workspace/status.sh" "${ROOT}"
