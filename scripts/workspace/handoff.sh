#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STARTUP="$(cd "${SCRIPT_DIR}/../.." && pwd)"
ROOT="${1:-${MICRODUCK_HOME:-${HOME}/Microduck}}"
ROOT="$(realpath -m "${ROOT}")"
[[ -d "${ROOT}/startup" ]] || ROOT="$(realpath -m "${STARTUP}/..")"
OUT_DIR="${ROOT}/notes/handoffs"
mkdir -p "${OUT_DIR}"
STAMP="$(date -u +'%Y%m%dT%H%M%SZ')"
OUT="${OUT_DIR}/${STAMP}.md"
TMP="${OUT}.tmp"

{
  printf '# Microduck GPU Handoff\n\n'
  printf -- '- Generated UTC: `%s`\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  printf -- '- Workspace: `%s`\n' "${ROOT}"
  printf -- '- Host: `%s`\n' "$(hostname)"
  printf -- '- Kernel: `%s`\n\n' "$(uname -srmo)"

  printf '## GPU\n\n```text\n'
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=index,name,memory.total,memory.used,driver_version --format=csv,noheader || true
  else
    printf 'nvidia-smi unavailable\n'
  fi
  printf '```\n\n'

  printf '## Disk\n\n```text\n'
  df -h "${ROOT}" || true
  printf '```\n\n'

  printf '## Repository state\n\n```text\n'
  bash "${ROOT}/startup/scripts/workspace/status.sh" "${ROOT}" || true
  printf '```\n\n'

  printf '## Recent checkpoints and models\n\n```text\n'
  find "${ROOT}/official/microduck_rl/logs" "${ROOT}/simulation/checkpoints" "${ROOT}/simulation/policies/custom" \
    -type f \( -name 'model_*.pt' -o -name '*.onnx' \) -printf '%TY-%Tm-%TdT%TH:%TM:%TSZ %p\n' 2>/dev/null \
    | sort -r | head -n 30 || true
  printf '```\n\n'

  printf '## Intelligence\n\n'
  if [[ -f "${ROOT}/startup/intelligence/digests/latest.md" ]]; then
    printf -- '- Tracked digest: `%s`\n' "${ROOT}/startup/intelligence/digests/latest.md"
  else
    printf -- '- No tracked digest generated yet.\n'
  fi
  if [[ -f "${ROOT}/intelligence/local/digests/latest.md" ]]; then
    printf -- '- Local digest: `%s`\n' "${ROOT}/intelligence/local/digests/latest.md"
  fi
  printf '\n'

  printf '## Resume sequence\n\n```bash\n'
  printf 'cd %q\n' "${ROOT}/startup"
  printf 'make workspace-status\n'
  printf 'make preflight\n'
  printf 'make rl-test\n'
  printf '# Inspect the correct run/checkpoint before training or export.\n'
  printf '```\n\n'

  printf '## Operator notes\n\n'
  printf -- '- Current objective:\n- Last successful command:\n- Current blocker:\n- Next single-variable experiment:\n- Expected evidence/pass condition:\n'
} > "${TMP}"

mv "${TMP}" "${OUT}"
cp "${OUT}" "${OUT_DIR}/LATEST.md"
printf 'Handoff written: %s\n' "${OUT}"
printf 'Latest copy:     %s\n' "${OUT_DIR}/LATEST.md"
