#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${REPLICA_DIR}/.venv"

cd "${REPLICA_DIR}"
PY="${REPLICA_DIR}/.venv/bin/python"

log "Rendering assembly drawings"
"${PY}" scripts/render_assembly.py upstream/microduck_rl assembly-drawings

log "Exporting world-transformed STL assemblies"
"${PY}" scripts/export_assembly_stl.py upstream/microduck_rl cad

log "Scanning mesh hole features"
"${PY}" scripts/analyze_holes.py \
  upstream/microduck_rl/src/mjlab_microduck/robot/microduck/assets

cat <<'TXT'

IMPORTANT
  These are simulation-derived meshes and reverse-engineering outputs.
  They are not validated manufacturing drawings and do not guarantee fit,
  thread geometry, tolerances, heat-set insert pockets or cable routing.
TXT
