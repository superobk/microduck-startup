#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}"
require_cmd curl

if ! command -v uv >/dev/null 2>&1; then
  log "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${HOME}/.cargo/bin:${PATH}"
fi
require_cmd uv

if [[ "$(uname -m)" == "aarch64" ]]; then
  export UV_HTTP_TIMEOUT="${UV_HTTP_TIMEOUT:-600}"
  log "ARM64 detected; UV_HTTP_TIMEOUT=${UV_HTTP_TIMEOUT}"
fi

log "Resolving the pinned MicroDuck RL environment"
cd "${RL_DIR}"
uv sync

log "Verifying Python, Torch and CUDA"
uv run python - <<'PY'
import platform
import sys
import torch

print("python:", sys.version.replace("\n", " "))
print("platform:", platform.platform())
print("torch:", torch.__version__)
print("torch CUDA build:", torch.version.cuda)
print("CUDA available:", torch.cuda.is_available())
print("GPU count:", torch.cuda.device_count())
for i in range(torch.cuda.device_count()):
    p = torch.cuda.get_device_properties(i)
    print(f"GPU {i}: {p.name}, {p.total_memory / 1024**3:.1f} GiB")
if not torch.cuda.is_available():
    raise SystemExit("CUDA is not available to Torch. Fix this before local training.")
PY

cat <<'TXT'

PASS CRITERIA
  - uv sync succeeds from a clean checkout.
  - Python resolves to >=3.12,<3.13 as required by the pinned project.
  - torch.cuda.is_available() prints True.
  - At least one GPU is listed.
TXT
