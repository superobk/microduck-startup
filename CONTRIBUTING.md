# Contributing

Keep the startup path reproducible:

1. Preserve pinned upstream SHAs unless a dedicated update commit documents the new snapshot date.
2. Test every shell script with `bash -n` and Python helper with `py_compile`.
3. Prefer one-variable experiment changes.
4. Do not rehost upstream models or 3D assets without confirming their licenses.
5. Never add credentials.
6. Document the exact command, expected observation and pass/fail condition.
