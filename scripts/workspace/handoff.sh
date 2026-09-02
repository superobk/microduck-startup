#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/portable.sh"

STARTUP="$(md_abs_path "${SCRIPT_DIR}/../..")"
ROOT="$(md_abs_path "${1:-${MICRODUCK_HOME:-${HOME}/Microduck}}")"
[[ -d "${ROOT}/startup" ]] || ROOT="$(md_abs_path "${STARTUP}/..")"
OUT_DIR="${ROOT}/notes/handoffs"
mkdir -p "${OUT_DIR}"
STAMP="$(date -u +'%Y%m%dT%H%M%SZ')"
OUT="${OUT_DIR}/${STAMP}.md"
TMP="${OUT}.tmp"

{
  printf '# Microduck Workspace Handoff\n\n'
  printf -- '- Generated UTC: `%s`\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  printf -- '- Workspace: `%s`\n' "${ROOT}"
  printf -- '- Host: `%s`\n' "$(hostname)"
  printf -- '- OS: `%s`\n' "$(uname -srmo 2>/dev/null || uname -a)"
  printf -- '- Role: `%s`\n\n' "${MICRODUCK_ROLE:-unknown}"

  printf '## Compute\n\n```text\n'
  if command -v nvidia-smi >/dev/null 2>&1; then
    nvidia-smi --query-gpu=index,name,memory.total,memory.used,driver_version --format=csv,noheader || true
  else
    printf 'nvidia-smi unavailable (normal on macOS control plane)\n'
  fi
  printf '```\n\n'

  printf '## Disk\n\n```text\n'
  df -h "${ROOT}" || true
  printf '```\n\n'

  printf '## Repository state\n\n```text\n'
  bash "${ROOT}/startup/scripts/workspace/status.sh" "${ROOT}" || true
  printf '```\n\n'

  printf '## Recent checkpoints, ONNX and published bundles\n\n```text\n'
  python3 - "${ROOT}" <<'PY'
from pathlib import Path
import datetime as dt
import sys

root = Path(sys.argv[1])
roots = [
    root / "official/microduck_rl/logs",
    root / "simulation/checkpoints",
    root / "simulation/policies/custom",
    root / "artifacts/published",
]
rows = []
for base in roots:
    if not base.exists():
        continue
    for p in base.rglob("*"):
        if p.is_file() and (
            p.name.startswith("model_") and p.suffix == ".pt"
            or p.suffix == ".onnx"
            or p.name == "preview.mp4"
            or p.name == "manifest.json"
        ):
            rows.append((p.stat().st_mtime, p))
for mtime, path in sorted(rows, reverse=True)[:40]:
    stamp = dt.datetime.fromtimestamp(mtime, tz=dt.timezone.utc).isoformat()
    print(stamp, path)
PY
  printf '```\n\n'

  printf '## Hugging Face publication state\n\n'
  if command -v hf >/dev/null 2>&1; then
    printf '```text\n'
    hf auth whoami 2>&1 || true
    printf '```\n\n'
  else
    printf -- '- `hf` CLI is not installed in the base shell; use `uvx --from huggingface_hub hf auth whoami`.\n\n'
  fi

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
  printf 'make sync-doctor\n'
  printf 'make workspace-status\n'
  printf 'make preflight\n'
  if command -v nvidia-smi >/dev/null 2>&1; then
    printf 'make rl-test\n'
    printf '# Inspect the correct run/checkpoint before training, replay or export.\n'
  else
    printf '# macOS control plane: pull the latest handoff and published bundles.\n'
    printf 'make sync-pull\n'
  fi
  printf '```\n\n'

  printf '## Operator notes\n\n'
  printf -- '- Current objective:\n- Active repository/branch:\n- Active worktree:\n- Current run ID:\n- Last successful command:\n- Current blocker:\n- Next exact command:\n- Expected evidence/pass condition:\n'
} > "${TMP}"

mv "${TMP}" "${OUT}"
cp "${OUT}" "${OUT_DIR}/LATEST.md"
printf 'Handoff written: %s\n' "${OUT}"
printf 'Latest copy:     %s\n' "${OUT_DIR}/LATEST.md"
