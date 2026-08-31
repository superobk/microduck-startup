#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

STAMP="$(date -u +'%Y%m%dT%H%M%SZ')"
OUT="${MANIFEST_ROOT}/${STAMP}"
mkdir -p "${OUT}"

{
  printf 'timestamp_utc=%s\n' "$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
  printf 'hostname=%s\n' "$(hostname)"
  printf 'kernel=%s\n' "$(uname -srmo)"
  printf 'architecture=%s\n' "$(uname -m)"
  printf 'task_id=%s\n' "${TASK_ID}"
  printf 'seed=%s\n' "${SEED}"
  printf 'train_envs=%s\n' "${TRAIN_ENVS}"
  printf 'train_iterations=%s\n' "${TRAIN_ITERS}"
  printf 'cuda_visible_devices=%s\n' "${CUDA_VISIBLE_DEVICES}"
} > "${OUT}/run.env"

cp "${STARTUP_ROOT}/configs/upstreams.env" "${OUT}/upstreams.env"
cp "${STARTUP_ROOT}/configs/experiment.env.example" "${OUT}/experiment.env.example"
[[ -f "${STARTUP_ROOT}/configs/experiment.env" ]] && \
  cp "${STARTUP_ROOT}/configs/experiment.env" "${OUT}/experiment.env"

for pair in \
  "microduck_rl:${RL_DIR}" \
  "microduck:${RUNTIME_DIR}" \
  "MicroDuckModels:${MODELS_DIR}" \
  "microduck-replica:${REPLICA_DIR}" \
  "awesome-microduck:${AWESOME_DIR}"; do
  name="${pair%%:*}"
  path="${pair#*:}"
  if [[ -d "${path}/.git" ]]; then
    {
      printf 'name=%s\n' "${name}"
      git -C "${path}" rev-parse HEAD
      git -C "${path}" status --short
    } > "${OUT}/${name}.git.txt"
  fi
done

command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -q > "${OUT}/nvidia-smi.txt" || true
if [[ -d "${RL_DIR}/.venv" ]]; then
  (cd "${RL_DIR}" && uv pip freeze) > "${OUT}/python-freeze.txt" 2>&1 || true
fi

find "${ARTIFACT_ROOT}" -maxdepth 1 -type f -print0 2>/dev/null | \
  sort -z | xargs -0 -r sha256sum > "${OUT}/artifact-sha256.txt"

cat <<TXT
Manifest written to: ${OUT}
Review it before sharing. Credentials and tokens must never be placed in configs/experiment.env.
TXT
