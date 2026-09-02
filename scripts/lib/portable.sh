#!/usr/bin/env bash
# Portable helpers shared by Linux and macOS scripts.
#
# Keep this file dependency-light: both machines must be able to source it
# before uv, Node, GNU coreutils or the RL environment are installed.

md_require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf '[ERROR] missing command: %s\n' "$1" >&2
    return 1
  }
}

md_abs_path() {
  # Python's Path.resolve(strict=False) gives us the useful part of
  # `realpath -m` on both Linux and macOS without requiring GNU coreutils.
  md_require_cmd python3
  python3 - "$1" <<'PY'
from pathlib import Path
import os
import sys

value = os.path.expandvars(os.path.expanduser(sys.argv[1]))
print(Path(value).resolve(strict=False))
PY
}

md_sha256() {
  local path="$1"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "${path}" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "${path}" | awk '{print $1}'
  else
    python3 - "${path}" <<'PY'
from pathlib import Path
import hashlib
import sys

h = hashlib.sha256()
with Path(sys.argv[1]).open("rb") as f:
    for chunk in iter(lambda: f.read(1024 * 1024), b""):
        h.update(chunk)
print(h.hexdigest())
PY
  fi
}

md_file_size() {
  python3 - "$1" <<'PY'
from pathlib import Path
import sys
print(Path(sys.argv[1]).stat().st_size)
PY
}

md_is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

md_is_linux() {
  [[ "$(uname -s)" == "Linux" ]]
}

md_shell_quote() {
  python3 - "$1" <<'PY'
import shlex
import sys
print(shlex.quote(sys.argv[1]))
PY
}

md_read_env_file() {
  local env_file="$1"
  if [[ -f "${env_file}" ]]; then
    # shellcheck disable=SC1090
    source "${env_file}"
  fi
}
