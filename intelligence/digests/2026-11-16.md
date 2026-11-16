# Microduck Intelligence Digest

Generated: `2026-11-16T22:10:32Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `218bdfa914ae` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/218bdfa914aef8c0a6da1733a9ca0774bdc928fd)

### pollen-robotics/microduck

- Release [daemon 0.21.1-dev.1822.323df43 (nfc-photo-tag)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-nfc-photo-tag) (prerelease)
- Release [daemon 0.21.1-dev.1824.d1fcd5f (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Commit `d1fcd5f85681` [Merge pull request #604 from pollen-robotics/dependabot/cargo/rustls-0.23.46](https://github.com/pollen-robotics/microduck/commit/d1fcd5f8568107e98a249ee60e4e1ef901bb6de4)
- Commit `6172e78ab571` [build(deps): bump rustls from 0.23.45 to 0.23.46](https://github.com/pollen-robotics/microduck/commit/6172e78ab57178483295ec676bd9ff528b5c8dfa)
- Commit `7fac0dff6025` [Merge pull request #603 from pollen-robotics/dynamic-pwm-limit](https://github.com/pollen-robotics/microduck/commit/7fac0dff60255094de301284c9ee4a65eac10d8e)
- Commit `2b226332e6f7` [robot.health carries the battery's Goal PWM; robotctl monitor shows it](https://github.com/pollen-robotics/microduck/commit/2b226332e6f7e280bed96fd153f7ed048c344812)
- Commit `e45f417d7165` [robotd: Goal PWM follows the battery so the motors see ~6 V](https://github.com/pollen-robotics/microduck/commit/e45f417d7165ed6484e602238f2ac6823cba86c5)
- PR #605 [Skip backing-into-wall check while seated to prevent Nap/Brace flip](https://github.com/pollen-robotics/microduck/pull/605) — closed
- PR #449 [Phase-encoded policies can run as skills](https://github.com/pollen-robotics/microduck/pull/449) — open
- PR #604 [build(deps): bump rustls from 0.23.45 to 0.23.46](https://github.com/pollen-robotics/microduck/pull/604) — closed
- PR #603 [robotd: Goal PWM follows the battery so the motors see ~6 V](https://github.com/pollen-robotics/microduck/pull/603) — closed

### fanhao375/microduck-replica

- Commit `29a8230a6eb5` [docs: track closed seated-wall proposal](https://github.com/fanhao375/microduck-replica/commit/29a8230a6eb52c921bafb7eba339dff2ac9fde9b)
- Commit `432c32490d6b` [docs: track Yocto shared build cache proposal](https://github.com/fanhao375/microduck-replica/commit/432c32490d6b3b1ce330e678739c4e221b675adb)
- Commit `ed67c789f2dd` [docs: track phase-skills API 63 synchronization](https://github.com/fanhao375/microduck-replica/commit/ed67c789f2dd3a14baaa508164796f77bd681422)
- Commit `4f0d6c3e5590` [docs: track upstream rustls security update](https://github.com/fanhao375/microduck-replica/commit/4f0d6c3e55907cf4fa6d56743d3a9bf4905a6286)
- Commit `c95af477d2fe` [docs: track PWM merge and NFC redraw timeout](https://github.com/fanhao375/microduck-replica/commit/c95af477d2fe7d129daf80af0daa4c5fd68c8e1a)
- Commit `6354665bc7fe` [docs: track PWM telemetry and e-ink reconnect](https://github.com/fanhao375/microduck-replica/commit/6354665bc7fe739e9f3ba436ea563047234231db)
- Commit `199a6b527705` [docs: track NFC photo transfer and PWM proposal](https://github.com/fanhao375/microduck-replica/commit/199a6b527705306fb9ea5b19c66f48ed4996f8bd)
- Commit `0089e5254baa` [docs: track NFC photo antenna mapping](https://github.com/fanhao375/microduck-replica/commit/0089e5254baa3513714d84495e2dbc474061a7d3)

### joeynyc/awesome-microduck

- Commit `d84c77fdc572` [Add AMD-trained soccer skills and a ball-balance experiment (#49)](https://github.com/joeynyc/awesome-microduck/commit/d84c77fdc572612b824f1ec767a28143a82b71fb)
- PR #49 [Add AMD-trained soccer skills and a ball-balance experiment](https://github.com/joeynyc/awesome-microduck/pull/49) — closed

### mujocolab/mjlab

- PR #1230 [Add opt-in substep observation delay](https://github.com/mujocolab/mjlab/pull/1230) — closed

### leggedrobotics/rsl_rl

- Commit `ea39cc2ae4a6` [Capture SAC updates and environment interaction in CUDA graphs (#273)](https://github.com/leggedrobotics/rsl_rl/commit/ea39cc2ae4a615c3d70d4ed9055d8b6e3b4c8acd)
- PR #302 [Add optional dynamic batch size to ONNX policy export](https://github.com/leggedrobotics/rsl_rl/pull/302) — open
- PR #300 [Add optional pooled advantage normalization for distributed PPO](https://github.com/leggedrobotics/rsl_rl/pull/300) — open
- PR #298 [Preserve the direction of adaptive KL learning-rate changes](https://github.com/leggedrobotics/rsl_rl/pull/298) — open
- PR #297 [Stop all distributed ranks on nonfinite environment data](https://github.com/leggedrobotics/rsl_rl/pull/297) — open
- PR #296 [Keep running observation moments finite and preserve float64 precision](https://github.com/leggedrobotics/rsl_rl/pull/296) — open

## Repository heads

- **superobk/microduck-startup** `main` → [218bdfa914ae](https://github.com/superobk/microduck-startup/commit/218bdfa914aef8c0a6da1733a9ca0774bdc928fd); pushed `2026-11-16T06:37:31Z`
- **pollen-robotics/microduck** `main` → [d1fcd5f85681](https://github.com/pollen-robotics/microduck/commit/d1fcd5f8568107e98a249ee60e4e1ef901bb6de4); pushed `2026-11-16T11:10:10Z`
- **pollen-robotics/microduck_rl** `develop` → [0daab160d3fb](https://github.com/pollen-robotics/microduck_rl/commit/0daab160d3fb1c2cbaba16a4a19052f36709dd9e); pushed `2026-11-10T11:31:29Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [29a8230a6eb5](https://github.com/fanhao375/microduck-replica/commit/29a8230a6eb52c921bafb7eba339dff2ac9fde9b); pushed `2026-11-16T16:58:37Z`
- **joeynyc/awesome-microduck** `main` → [d84c77fdc572](https://github.com/joeynyc/awesome-microduck/commit/d84c77fdc572612b824f1ec767a28143a82b71fb); pushed `2026-11-16T11:43:34Z`
- **mujocolab/mjlab** `main` → [6ab9846ea068](https://github.com/mujocolab/mjlab/commit/6ab9846ea068714678fd0e9f791f898c6b697b20); pushed `2026-11-15T01:53:45Z`
- **leggedrobotics/rsl_rl** `main` → [ea39cc2ae4a6](https://github.com/leggedrobotics/rsl_rl/commit/ea39cc2ae4a615c3d70d4ed9055d8b6e3b4c8acd); pushed `2026-11-16T11:12:56Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
