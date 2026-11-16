# Microduck Intelligence Digest

Generated: `2026-11-16T06:37:17Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `7ca23a297c5c` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/7ca23a297c5c5d09fb3cf2cbbfe23b224d4be6a8)

### pollen-robotics/microduck

- Release [daemon 0.21.1-dev.1805.dc8ac5b (stress-test)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-stress-test) (prerelease)
- Release [daemon 0.21.1-dev.1808.16bfedd (nfc-photo-tag)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-nfc-photo-tag) (prerelease)
- Commit `2d99c3aafeeb` [Merge pull request #602 from pollen-robotics/duckctl-scan-setup-code-qr](https://github.com/pollen-robotics/microduck/commit/2d99c3aafeeb282046d58e3f9501fd26a3347620)
- Commit `b256b3355e6a` [duckctl: setup-code add asks scan or paste, and scans by default](https://github.com/pollen-robotics/microduck/commit/b256b3355e6a6a0ea2ebf306bc08a3069b01a3e2)
- Commit `13ea4b8f30da` [duckctl: --scan says why a setup-code QR does not read](https://github.com/pollen-robotics/microduck/commit/13ea4b8f30da8f6137c02dbd54a07331412fa7ac)
- Commit `06ba9bd3f9ba` [duckctl: setup-code add --scan reads the label QR with the camera](https://github.com/pollen-robotics/microduck/commit/06ba9bd3f9baee3ac42e5b8a4e303bd857be8173)
- PR #602 [duckctl: setup-code add reads the label QR with the camera](https://github.com/pollen-robotics/microduck/pull/602) — closed

### fanhao375/microduck-replica

- Commit `a47459525464` [docs: track NFC e-ink development and ToF review](https://github.com/fanhao375/microduck-replica/commit/a47459525464d89178e3a7c78968be7af9ff2b54)
- Commit `67a809c929d0` [docs: track setup QR preview and stress alarm](https://github.com/fanhao375/microduck-replica/commit/67a809c929d0b4f21f16284b886dc9d93a928f06)

### leggedrobotics/rsl_rl

- PR #282 [Allow implicit zero hidden states in initial recurrent updates](https://github.com/leggedrobotics/rsl_rl/pull/282) — open
- PR #281 [Detach running normalization statistics from input autograd graphs](https://github.com/leggedrobotics/rsl_rl/pull/281) — open
- PR #280 [Accumulate low precision observation moments in float32](https://github.com/leggedrobotics/rsl_rl/pull/280) — closed
- PR #279 [Preserve frozen SAC critic parameters during actor updates](https://github.com/leggedrobotics/rsl_rl/pull/279) — closed
- PR #278 [Log environment images to the logging writers](https://github.com/leggedrobotics/rsl_rl/pull/278) — open

## Repository heads

- **superobk/microduck-startup** `main` → [7ca23a297c5c](https://github.com/superobk/microduck-startup/commit/7ca23a297c5c5d09fb3cf2cbbfe23b224d4be6a8); pushed `2026-11-15T18:54:39Z`
- **pollen-robotics/microduck** `main` → [2d99c3aafeeb](https://github.com/pollen-robotics/microduck/commit/2d99c3aafeeb282046d58e3f9501fd26a3347620); pushed `2026-11-16T06:36:06Z`
- **pollen-robotics/microduck_rl** `develop` → [0daab160d3fb](https://github.com/pollen-robotics/microduck_rl/commit/0daab160d3fb1c2cbaba16a4a19052f36709dd9e); pushed `2026-11-10T11:31:29Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [a47459525464](https://github.com/fanhao375/microduck-replica/commit/a47459525464d89178e3a7c78968be7af9ff2b54); pushed `2026-11-16T05:48:05Z`
- **joeynyc/awesome-microduck** `main` → [09bebf9ed359](https://github.com/joeynyc/awesome-microduck/commit/09bebf9ed359f68797a15b4ed1b7166faa73d37a); pushed `2026-11-13T21:19:30Z`
- **mujocolab/mjlab** `main` → [6ab9846ea068](https://github.com/mujocolab/mjlab/commit/6ab9846ea068714678fd0e9f791f898c6b697b20); pushed `2026-11-15T01:53:45Z`
- **leggedrobotics/rsl_rl** `main` → [8945bdcbc364](https://github.com/leggedrobotics/rsl_rl/commit/8945bdcbc364f388e14caebf547dbf302d89e491); pushed `2026-11-10T18:32:06Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
