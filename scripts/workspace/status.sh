#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTUP="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ROOT="${MICRODUCK_HOME:-${HOME}/Microduck}"
REMOTE=false

for arg in "$@"; do
  case "${arg}" in
    --remote) REMOTE=true ;;
    *) ROOT="${arg}" ;;
  esac
done
ROOT="$(realpath -m "${ROOT}")"
MANIFEST="${ROOT}/startup/configs/workspace-repos.json"
[[ -f "${MANIFEST}" ]] || MANIFEST="${STARTUP}/configs/workspace-repos.json"

printf 'Microduck workspace: %s\n\n' "${ROOT}"
printf '%-23s %-11s %-13s %-12s %-8s %s\n' NAME CATEGORY BRANCH HEAD DIRTY EXPECTED

python3 - "${MANIFEST}" <<'PY' | while IFS=$'\t' read -r name category rel_path ref tracking; do
import json
import sys
with open(sys.argv[1], encoding="utf-8") as f:
    data = json.load(f)
for x in data["repos"]:
    print("\t".join([x["name"], x["category"], x["path"], x["ref"], x.get("tracking_branch", "")]))
PY
  repo="${ROOT}/${rel_path}"
  if [[ ! -d "${repo}/.git" ]]; then
    printf '%-23s %-11s %-13s %-12s %-8s %s\n' "${name}" "${category}" MISSING - - "${ref:0:12}"
    continue
  fi
  branch="$(git -C "${repo}" symbolic-ref --short -q HEAD || printf 'detached')"
  head="$(git -C "${repo}" rev-parse --short=12 HEAD)"
  if [[ -n "$(git -C "${repo}" status --porcelain)" ]]; then dirty=yes; else dirty=no; fi
  printf '%-23s %-11s %-13s %-12s %-8s %s\n' "${name}" "${category}" "${branch}" "${head}" "${dirty}" "${ref:0:12}"
  if [[ "${REMOTE}" == true && -n "${tracking}" ]]; then
    remote_head="$(git -C "${repo}" ls-remote origin "refs/heads/${tracking}" | awk 'NR==1{print substr($1,1,12)}')"
    printf '  remote origin/%s: %s\n' "${tracking}" "${remote_head:-unavailable}"
  fi
done

printf '\nLegend: detached + EXPECTED match is the reproducible baseline; remote fetch does not alter it.\n'
