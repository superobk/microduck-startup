# Security

This repository is intentionally credential-free.

Do not commit:

- GitHub personal access tokens;
- Hugging Face tokens;
- Weights & Biases API keys;
- SSH private keys;
- cloud credentials;
- passwords or private registry tokens.

Use official CLI login flows, OS credential helpers, SSH agents or process environment variables. `configs/experiment.env` is gitignored, but it must still contain experiment settings only—not secrets—because the manifest tool may copy it for reproducibility.

When sharing manifests, preserve non-secret version, hardware and run identifiers needed for traceability, but review the generated directory before upload.
