# Microduck Intelligence Digest

Generated: `2026-11-02T16:13:46Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `f622994bcac4` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/f622994bcac48c360e399405e10f5c5e1963a182)

### pollen-robotics/microduck

- Release [daemon 0.18.3-dev.1538.b69b5ff (pad-pairing-cleanup)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-pad-pairing-cleanup) (prerelease)
- Release [daemon 0.18.3-dev.1537.997808c (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Release [daemon 0.18.3-dev.1539.d6f77af (codex/gamepad-connection)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-codex/gamepad-connection) (prerelease)
- Commit `997808c1d710` [Merge pull request #513 from first-it-consulting/duck-sim-walks](https://github.com/pollen-robotics/microduck/commit/997808c1d71056d31bd6f05fc5fde848c849d2bc)
- Commit `f3ccf7ca3a09` [xtask: duck-sim's policy slots must be robotd's walk-mode defaults](https://github.com/pollen-robotics/microduck/commit/f3ccf7ca3a099938e0f0df155967511f12e63c85)
- Commit `0bd7a0feb538` [Revert the AGENTS.md section on the simulator](https://github.com/pollen-robotics/microduck/commit/0bd7a0feb538df3c278f1f7f8786a3cb2da1a2b7)
- Commit `6eb8525135ab` [duck-sim: the twin walks — velstand, on the robot with backlash](https://github.com/pollen-robotics/microduck/commit/6eb8525135abbd7cd9cdc2b468c74ef967e51793)
- Commit `f8632aa6e6a8` [docs(claude): point at the MuJoCo simulator as the no-hardware dev path](https://github.com/pollen-robotics/microduck/commit/f8632aa6e6a85dd5e50170a33176e98ac2acb61b)
- PR #500 [duck-sim: name the shipped gait, not the legacy pair, so the duck walks](https://github.com/pollen-robotics/microduck/pull/500) — closed
- PR #331 [duck-sim: a default that walks, keyboard teleop, and a race to run](https://github.com/pollen-robotics/microduck/pull/331) — closed

### pollen-robotics/microduck_rl

- PR #77 [feat: Windows 10 support  ](https://github.com/pollen-robotics/microduck_rl/pull/77) — open

### fanhao375/microduck-replica

- Commit `d2c60f380a3a` [docs: track pending Python SDK packaging and vision example revisions](https://github.com/fanhao375/microduck-replica/commit/d2c60f380a3a1db417488db647a0fb170cc01017)
- Commit `2b7b78bb9dc4` [docs: record reconnect scheduler review and ownership boundary](https://github.com/fanhao375/microduck-replica/commit/2b7b78bb9dc40127acfaa7843e1e7d33867de9c3)
- Commit `cfaa641614c8` [docs: track merged simulator fix and distinct pairing development contracts](https://github.com/fanhao375/microduck-replica/commit/cfaa641614c83b2afda4ebfa5048e8ad85513cb7)

### mujocolab/mjlab

- PR #1301 [Cap imageio-ffmpeg below 0.8 until mediapy supports FFmpeg 9.](https://github.com/mujocolab/mjlab/pull/1301) — open
- PR #1299 [Accept custom checkpoint sources in train and play.](https://github.com/mujocolab/mjlab/pull/1299) — open
- PR #1298 [command and curriculum state dict](https://github.com/mujocolab/mjlab/pull/1298) — open

### leggedrobotics/rsl_rl

- PR #262 [Remove unused init_weights functions](https://github.com/leggedrobotics/rsl_rl/pull/262) — open

## Repository heads

- **superobk/microduck-startup** `main` → [f622994bcac4](https://github.com/superobk/microduck-startup/commit/f622994bcac48c360e399405e10f5c5e1963a182); pushed `2026-11-02T06:15:11Z`
- **pollen-robotics/microduck** `main` → [997808c1d710](https://github.com/pollen-robotics/microduck/commit/997808c1d71056d31bd6f05fc5fde848c849d2bc); pushed `2026-11-02T11:57:21Z`
- **pollen-robotics/microduck_rl** `develop` → [bae39f5900b3](https://github.com/pollen-robotics/microduck_rl/commit/bae39f5900b318f7e87fc485c30a31213cfa14eb); pushed `2026-10-31T09:21:43Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [d2c60f380a3a](https://github.com/fanhao375/microduck-replica/commit/d2c60f380a3a1db417488db647a0fb170cc01017); pushed `2026-11-02T14:23:33Z`
- **joeynyc/awesome-microduck** `main` → [63d73155cc8b](https://github.com/joeynyc/awesome-microduck/commit/63d73155cc8baf9450a462a30c91474275680f2d); pushed `2026-10-29T20:08:12Z`
- **mujocolab/mjlab** `main` → [dcdf6ce519ab](https://github.com/mujocolab/mjlab/commit/dcdf6ce519abfd2ea45e9503ae6fb650b75bb869); pushed `2026-11-01T04:13:02Z`
- **leggedrobotics/rsl_rl** `main` → [11563319134f](https://github.com/leggedrobotics/rsl_rl/commit/11563319134f987f70fb034410496fe3cc7327a9); pushed `2026-10-28T16:18:03Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
