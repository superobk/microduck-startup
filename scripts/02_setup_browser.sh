#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${MODELS_DIR}"
require_cmd node
require_cmd npm

node - <<'NODE'
const [major] = process.versions.node.split('.').map(Number);
if (major < 20) {
  console.error(`Node.js 20+ is required; found ${process.versions.node}`);
  process.exit(1);
}
console.log(`Node.js ${process.versions.node} OK`);
NODE

log "Installing the pinned browser simulator dependencies"
cd "${MODELS_DIR}"
npm ci
npm run build

cat <<TXT

PASS CRITERIA
  - npm ci finishes without dependency errors.
  - npm run build creates ${MODELS_DIR}/dist.
NEXT
  bash scripts/03_run_browser.sh
TXT
