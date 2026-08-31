#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"
require_dir "${RL_DIR}/.git"

DEST="${VARIANT_ROOT}/microduck_rl-no-push"
BRANCH="bootcamp/no-push"

if [[ ! -d "${DEST}" ]]; then
  if git -C "${RL_DIR}" show-ref --verify --quiet "refs/heads/${BRANCH}"; then
    git -C "${RL_DIR}" worktree add "${DEST}" "${BRANCH}"
  else
    git -C "${RL_DIR}" worktree add -b "${BRANCH}" "${DEST}" "${MICRODUCK_RL_REF}"
  fi
fi

python3 - "${DEST}/src/mjlab_microduck/tasks/microduck_velocity_env_cfg.py" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text()
old = "ENABLE_VELOCITY_PUSHES = True"
new = "ENABLE_VELOCITY_PUSHES = False"
if new in text:
    print("no-push patch already present")
elif text.count(old) == 1:
    path.write_text(text.replace(old, new, 1))
    print(f"patched {path}")
else:
    raise SystemExit(f"expected exactly one {old!r} in {path}")
PY

printf '\nReview the single-variable diff:\n'
git -C "${DEST}" diff -- src/mjlab_microduck/tasks/microduck_velocity_env_cfg.py
cat <<TXT

No-push worktree: ${DEST}
Next:
  cd "${DEST}"
  uv sync
  CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES} uv run train "${TASK_ID}" \
    --env.scene.num-envs ${SMOKE_ENVS} \
    --agent.max_iterations ${SMOKE_ITERS} \
    --agent.logger ${LOGGER} \
    --agent.run-name nopush_smoke \
    --agent.seed ${SEED}
TXT
