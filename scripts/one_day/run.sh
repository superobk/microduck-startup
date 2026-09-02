#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "${SCRIPT_DIR}/../lib/portable.sh"

STARTUP="$(md_abs_path "${SCRIPT_DIR}/../..")"
# shellcheck disable=SC1091
source "${STARTUP}/configs/one-day.env.example"
if [[ -f "${STARTUP}/configs/one-day.env" ]]; then
  # shellcheck disable=SC1091
  source "${STARTUP}/configs/one-day.env"
fi
if [[ -f "${STARTUP}/configs/machine.env" ]]; then
  # shellcheck disable=SC1091
  source "${STARTUP}/configs/machine.env"
fi

ROOT="$(md_abs_path "${MICRODUCK_HOME:-${HOME}/Microduck}")"
RL_DIR="${ROOT}/official/microduck_rl"
PROFILE_FILE="${STARTUP}/configs/one-day-profiles.json"

PHASE="${1:-all}"
shift || true
if [[ "${PHASE}" == "-h" || "${PHASE}" == "--help" ]]; then
  cat <<'EOF'
Usage:
  bash scripts/one_day/run.sh all
  bash scripts/one_day/run.sh <phase> [--run-id ID]

Phases:
  setup smoke train export replay package publish-model publish-space all

`all` performs setup -> smoke -> train -> export -> replay -> package and
publishes only when ONE_DAY_HF_MODEL_REPO / ONE_DAY_HF_SPACE_REPO are set.
EOF
  exit 0
fi
RUN_ID=""
while (( $# > 0 )); do
  case "$1" in
    --run-id)
      RUN_ID="${2:-}"
      shift 2
      ;;
    -h|--help)
      printf 'Place --help before the phase name.\n'
      exit 0
      ;;
    *)
      printf '[ERROR] unknown argument: %s\n' "$1" >&2
      exit 2
      ;;
  esac
done

eval "$(
  ONE_DAY_PROFILE="${ONE_DAY_PROFILE}" \
  ONE_DAY_TASK_ID="${ONE_DAY_TASK_ID}" \
  ONE_DAY_SPACE_SLOT="${ONE_DAY_SPACE_SLOT}" \
  ONE_DAY_TRAIN_ENVS="${ONE_DAY_TRAIN_ENVS}" \
  ONE_DAY_TRAIN_ITERS="${ONE_DAY_TRAIN_ITERS}" \
  ONE_DAY_REPLAY_STEPS="${ONE_DAY_REPLAY_STEPS}" \
  python3 - "${PROFILE_FILE}" <<'PY'
import json
import os
import shlex
import sys

with open(sys.argv[1], encoding="utf-8") as handle:
    data = json.load(handle)
name = os.environ["ONE_DAY_PROFILE"]
try:
    p = data["profiles"][name]
except KeyError as exc:
    raise SystemExit(f"unknown ONE_DAY_PROFILE={name!r}") from exc

values = {
    "RESOLVED_PROFILE": name,
    "RESOLVED_TASK_ID": os.environ.get("ONE_DAY_TASK_ID") or p["task_id"],
    "RESOLVED_SPACE_SLOT": os.environ.get("ONE_DAY_SPACE_SLOT") or (p.get("space_slot") or ""),
    "RESOLVED_TRAIN_ENVS": os.environ.get("ONE_DAY_TRAIN_ENVS") or str(p["train_envs"]),
    "RESOLVED_TRAIN_ITERS": os.environ.get("ONE_DAY_TRAIN_ITERS") or str(p["train_iterations"]),
    "RESOLVED_REPLAY_STEPS": os.environ.get("ONE_DAY_REPLAY_STEPS") or str(p["replay_steps"]),
}
for key, value in values.items():
    print(f"{key}={shlex.quote(str(value))}")
PY
)"

RUN_BASE="${ROOT}/experiments/runs/one-day"
mkdir -p "${RUN_BASE}"
LATEST_FILE="${RUN_BASE}/LATEST_RUN_ID"

if [[ -z "${RUN_ID}" ]]; then
  if [[ "${PHASE}" == "all" || ! -f "${LATEST_FILE}" ]]; then
    RUN_ID="${RESOLVED_PROFILE}-$(date -u +'%Y%m%dT%H%M%SZ')"
  else
    RUN_ID="$(cat "${LATEST_FILE}")"
  fi
fi
printf '%s\n' "${RUN_ID}" > "${LATEST_FILE}"

RUN_ROOT="${RUN_BASE}/${RUN_ID}"
STATE_DIR="${RUN_ROOT}/state"
LOG_DIR="${RUN_ROOT}/logs"
EXPORT_DIR="${RUN_ROOT}/export"
REPLAY_DIR="${RUN_ROOT}/replay"
BUNDLE_DIR="${ROOT}/artifacts/published/${RUN_ID}"
mkdir -p "${STATE_DIR}" "${LOG_DIR}" "${EXPORT_DIR}" "${REPLAY_DIR}"

RUN_NAME="oneday_${RUN_ID//[^A-Za-z0-9_-]/_}"

write_resolved_config() {
  cat > "${RUN_ROOT}/resolved.env" <<EOF
RUN_ID="${RUN_ID}"
PROFILE="${RESOLVED_PROFILE}"
TASK_ID="${RESOLVED_TASK_ID}"
SPACE_SLOT="${RESOLVED_SPACE_SLOT}"
TRAIN_ENVS="${RESOLVED_TRAIN_ENVS}"
TRAIN_ITERS="${RESOLVED_TRAIN_ITERS}"
SMOKE_ENVS="${ONE_DAY_SMOKE_ENVS}"
SMOKE_ITERS="${ONE_DAY_SMOKE_ITERS}"
REPLAY_STEPS="${RESOLVED_REPLAY_STEPS}"
SEED="${ONE_DAY_SEED}"
CUDA_VISIBLE_DEVICES="${ONE_DAY_GPU}"
LOGGER="${ONE_DAY_LOGGER}"
EOF
}
write_resolved_config

need_workspace() {
  if [[ ! -d "${RL_DIR}/.git" ]]; then
    printf '[one-day] workspace missing; bootstrapping %s\n' "${ROOT}"
    bash "${STARTUP}/scripts/workspace/bootstrap.sh" "${ROOT}"
  fi
}

need_uv_env() {
  need_workspace
  [[ -d "${RL_DIR}/.venv" ]] || bash "${STARTUP}/scripts/04_setup_rl.sh"
}

find_run_and_checkpoint() {
  python3 - "${RL_DIR}/logs/rsl_rl" "${RUN_NAME}" "${STATE_DIR}" <<'PY'
from pathlib import Path
import re
import sys

log_root = Path(sys.argv[1])
run_name = sys.argv[2]
state = Path(sys.argv[3])
state.mkdir(parents=True, exist_ok=True)

runs = [p for p in log_root.glob(f"*/*_{run_name}") if p.is_dir()]
if not runs:
    raise SystemExit(f"no run directory ending in _{run_name!s} under {log_root}")
run = max(runs, key=lambda p: p.stat().st_mtime_ns)

checkpoints = list(run.glob("model_*.pt"))
if not checkpoints:
    raise SystemExit(f"no model_*.pt in {run}")

def key(path: Path):
    match = re.search(r"model_(\d+)", path.name)
    return (int(match.group(1)) if match else -1, path.stat().st_mtime_ns)

checkpoint = max(checkpoints, key=key)
(state / "run_dir.txt").write_text(str(run.resolve()) + "\n")
(state / "checkpoint.txt").write_text(str(checkpoint.resolve()) + "\n")
print(f"run_dir={run.resolve()}")
print(f"checkpoint={checkpoint.resolve()}")
PY
}

require_checkpoint() {
  if [[ ! -f "${STATE_DIR}/checkpoint.txt" ]]; then
    find_run_and_checkpoint
  fi
  CHECKPOINT="$(cat "${STATE_DIR}/checkpoint.txt")"
  [[ -f "${CHECKPOINT}" ]] || {
    printf '[ERROR] checkpoint missing: %s\n' "${CHECKPOINT}" >&2
    exit 1
  }
  RUN_DIR="$(cat "${STATE_DIR}/run_dir.txt")"
}

phase_setup() {
  need_workspace
  bash "${STARTUP}/scripts/04_setup_rl.sh" 2>&1 | tee "${LOG_DIR}/setup.log"
  bash "${STARTUP}/scripts/05_rl_tests.sh" 2>&1 | tee "${LOG_DIR}/tests.log"
}

phase_smoke() {
  need_uv_env
  printf '[one-day] smoke: task=%s envs=%s iterations=%s\n' \
    "${RESOLVED_TASK_ID}" "${ONE_DAY_SMOKE_ENVS}" "${ONE_DAY_SMOKE_ITERS}"
  (
    cd "${RL_DIR}"
    CUDA_VISIBLE_DEVICES="${ONE_DAY_GPU}" \
    uv run train "${RESOLVED_TASK_ID}" \
      --env.scene.num-envs "${ONE_DAY_SMOKE_ENVS}" \
      --agent.max_iterations "${ONE_DAY_SMOKE_ITERS}" \
      --agent.logger "${ONE_DAY_LOGGER}" \
      --agent.run-name "${RUN_NAME}_smoke" \
      --agent.seed "${ONE_DAY_SEED}"
  ) 2>&1 | tee "${LOG_DIR}/smoke.log"
}

phase_train() {
  need_uv_env
  printf '[one-day] PPO on-policy collection + update\n'
  printf '  task=%s envs=%s iterations=%s seed=%s GPU=%s\n' \
    "${RESOLVED_TASK_ID}" "${RESOLVED_TRAIN_ENVS}" \
    "${RESOLVED_TRAIN_ITERS}" "${ONE_DAY_SEED}" "${ONE_DAY_GPU}"

  nan_args=()
  if [[ "${ONE_DAY_ENABLE_NAN_GUARD}" == "true" ]]; then
    nan_args+=(--enable-nan-guard)
  fi

  (
    cd "${RL_DIR}"
    CUDA_VISIBLE_DEVICES="${ONE_DAY_GPU}" \
    uv run train "${RESOLVED_TASK_ID}" \
      --env.scene.num-envs "${RESOLVED_TRAIN_ENVS}" \
      --agent.max_iterations "${RESOLVED_TRAIN_ITERS}" \
      --agent.logger "${ONE_DAY_LOGGER}" \
      --agent.run-name "${RUN_NAME}" \
      --agent.seed "${ONE_DAY_SEED}" \
      "${nan_args[@]}"
  ) 2>&1 | tee "${LOG_DIR}/train.log"

  find_run_and_checkpoint
}

phase_export() {
  need_uv_env
  require_checkpoint
  ONNX="${EXPORT_DIR}/${ONE_DAY_ONNX_NAME}"
  (
    cd "${RL_DIR}"
    uv run scripts/export.py "${RESOLVED_TASK_ID}" \
      --checkpoint-file "${CHECKPOINT}" \
      --onnx-file "${ONNX}" \
      --num-envs 1
    uv run python "${STARTUP}/scripts/10_verify_onnx.py" "${ONNX}"
  ) 2>&1 | tee "${LOG_DIR}/export.log"
  printf '%s\n' "${ONNX}" > "${STATE_DIR}/onnx.txt"
}

phase_replay() {
  need_uv_env
  require_checkpoint
  (
    cd "${RL_DIR}"
    CUDA_VISIBLE_DEVICES="${ONE_DAY_GPU}" \
    MUJOCO_GL=egl \
    uv run python "${STARTUP}/scripts/one_day/replay_checkpoint.py" \
      "${RESOLVED_TASK_ID}" \
      --checkpoint "${CHECKPOINT}" \
      --output-dir "${REPLAY_DIR}" \
      --steps "${RESOLVED_REPLAY_STEPS}" \
      --seed "${ONE_DAY_SEED}" \
      --video-width "${ONE_DAY_VIDEO_WIDTH}" \
      --video-height "${ONE_DAY_VIDEO_HEIGHT}"
  ) 2>&1 | tee "${LOG_DIR}/replay.log"
}

phase_package() {
  require_checkpoint
  [[ -f "${STATE_DIR}/onnx.txt" ]] || phase_export
  ONNX="$(cat "${STATE_DIR}/onnx.txt")"
  [[ -f "${REPLAY_DIR}/rollout.npz" ]] || phase_replay

  python3 "${STARTUP}/scripts/one_day/package_run.py" \
    --run-id "${RUN_ID}" \
    --profile "${RESOLVED_PROFILE}" \
    --task-id "${RESOLVED_TASK_ID}" \
    --space-slot "${RESOLVED_SPACE_SLOT}" \
    --run-dir "${RUN_DIR}" \
    --checkpoint "${CHECKPOINT}" \
    --onnx "${ONNX}" \
    --replay-dir "${REPLAY_DIR}" \
    --bundle-dir "${BUNDLE_DIR}" \
    --startup "${STARTUP}" \
    --rl-dir "${RL_DIR}" \
    | tee "${LOG_DIR}/package.log"
  printf '%s\n' "${BUNDLE_DIR}" > "${STATE_DIR}/bundle.txt"
}

phase_publish_model() {
  [[ -n "${ONE_DAY_HF_MODEL_REPO}" ]] || {
    printf '[ERROR] set ONE_DAY_HF_MODEL_REPO in configs/one-day.env\n' >&2
    exit 1
  }
  [[ -d "${BUNDLE_DIR}" ]] || phase_package
  (
    cd "${RL_DIR}"
    HF_XET_HIGH_PERFORMANCE="${HF_XET_HIGH_PERFORMANCE:-1}" \
    uv run --with "huggingface_hub>=1.0" \
      python "${STARTUP}/scripts/hf/publish_model.py" \
      --bundle "${BUNDLE_DIR}" \
      --repo-id "${ONE_DAY_HF_MODEL_REPO}"
  ) 2>&1 | tee "${LOG_DIR}/publish-model.log"
}

phase_publish_space() {
  [[ -n "${ONE_DAY_HF_SPACE_REPO}" ]] || {
    printf '[ERROR] set ONE_DAY_HF_SPACE_REPO in configs/one-day.env\n' >&2
    exit 1
  }
  [[ -n "${RESOLVED_SPACE_SLOT}" ]] || {
    printf '[ERROR] profile %s has no existing official Space slot; add a driver/UI integration first.\n' "${RESOLVED_PROFILE}" >&2
    exit 1
  }
  [[ -d "${BUNDLE_DIR}" ]] || phase_package

  private_args=()
  if [[ "${ONE_DAY_HF_SPACE_PRIVATE}" == "true" ]]; then
    private_args+=(--private)
  fi
  (
    cd "${RL_DIR}"
    HF_XET_HIGH_PERFORMANCE="${HF_XET_HIGH_PERFORMANCE:-1}" \
    uv run --with "huggingface_hub>=1.0" \
      python "${STARTUP}/scripts/hf/stage_space.py" \
      --source-space "${ONE_DAY_HF_SOURCE_SPACE}" \
      --target-space "${ONE_DAY_HF_SPACE_REPO}" \
      --policy "${BUNDLE_DIR}/policy.onnx" \
      --bundle "${BUNDLE_DIR}" \
      --slot "${RESOLVED_SPACE_SLOT}" \
      --slug "${RUN_ID}" \
      --model-repo "${ONE_DAY_HF_MODEL_REPO}" \
      --workdir "${ROOT}/registry/huggingface/space-staging/${RUN_ID}" \
      --duplicate \
      --build \
      --upload \
      "${private_args[@]}"
  ) 2>&1 | tee "${LOG_DIR}/publish-space.log"
}

case "${PHASE}" in
  setup) phase_setup ;;
  smoke) phase_smoke ;;
  train) phase_train ;;
  export) phase_export ;;
  replay) phase_replay ;;
  package) phase_package ;;
  publish-model) phase_publish_model ;;
  publish-space) phase_publish_space ;;
  all)
    phase_setup
    phase_smoke
    phase_train
    phase_export
    phase_replay
    phase_package
    [[ -z "${ONE_DAY_HF_MODEL_REPO}" ]] || phase_publish_model
    [[ -z "${ONE_DAY_HF_SPACE_REPO}" ]] || phase_publish_space
    ;;
  *)
    printf '[ERROR] unknown phase: %s\n' "${PHASE}" >&2
    exit 2
    ;;
esac

cat <<EOF

ONE-DAY PHASE COMPLETE
  run id:       ${RUN_ID}
  task:         ${RESOLVED_TASK_ID}
  run root:     ${RUN_ROOT}
  bundle:       ${BUNDLE_DIR}
  latest id:    ${LATEST_FILE}

PPO data note:
  Training rollouts are on-policy and are consumed by PPO inside RSL-RL.
  ${REPLAY_DIR}/rollout.npz is a frozen post-training evaluation replay,
  not a replay buffer reused by PPO.
EOF
