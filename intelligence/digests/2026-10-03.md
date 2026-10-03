# Microduck Intelligence Digest

Generated: `2026-10-03T21:21:35Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `a45a929c1815` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/a45a929c1815e8de3aec9906037f57ec4d9b7405)

### pollen-robotics/microduck

- Release [daemon 0.15.1-dev.1196.620affc (pickup-detector)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-pickup-detector) (prerelease)
- Release [daemon 0.15.1-dev.1193.a574cf5 (midi-instrument)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-midi-instrument) (prerelease)
- Release [daemon 0.15.1-dev.1195.9136aa4 (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Commit `9136aa4ee88e` [Merge pull request #347 from pollen-robotics/shutdown-rest-pose](https://github.com/pollen-robotics/microduck/commit/9136aa4ee88e81edf2bcaf3527e90b65da25f1eb)
- Commit `da4973d69c9a` [robotd: ease into a recorded rest pose before the shutdown cuts torque](https://github.com/pollen-robotics/microduck/commit/da4973d69c9a2002d66faa4f9dc0acae0246b4bb)
- PR #348 [Play a microduck from a MIDI keyboard](https://github.com/pollen-robotics/microduck/pull/348) — open
- PR #347 [robotd: ease into a recorded rest pose before the shutdown cuts torque](https://github.com/pollen-robotics/microduck/pull/347) — closed
- PR #260 [The servos report velocity and load every tick, and the wire dropped both](https://github.com/pollen-robotics/microduck/pull/260) — closed

### pollen-robotics/microduck_rl

- PR #70 [Pickup detector](https://github.com/pollen-robotics/microduck_rl/pull/70) — open
- PR #69 [docs: Intel GPU training via the mjlab-sycl companion package](https://github.com/pollen-robotics/microduck_rl/pull/69) — open

### fanhao375/microduck-replica

- PR #36 [tools: HD1910M 工具新增零位校准/重启指令与角度限制增强（作者：漂移菌）](https://github.com/fanhao375/microduck-replica/pull/36) — open

### mujocolab/mjlab

- PR #1205 [Clear feet_swing_height peak_heights on environment reset](https://github.com/mujocolab/mjlab/pull/1205) — open

## Repository heads

- **superobk/microduck-startup** `main` → [a45a929c1815](https://github.com/superobk/microduck-startup/commit/a45a929c1815e8de3aec9906037f57ec4d9b7405); pushed `2026-10-03T16:25:58Z`
- **pollen-robotics/microduck** `main` → [9136aa4ee88e](https://github.com/pollen-robotics/microduck/commit/9136aa4ee88e81edf2bcaf3527e90b65da25f1eb); pushed `2026-10-03T21:20:15Z`
- **pollen-robotics/microduck_rl** `develop` → [8d0db74916a4](https://github.com/pollen-robotics/microduck_rl/commit/8d0db74916a4f833d1d9b95d6a1d7f4d13b9d5ec); pushed `2026-10-03T21:10:32Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [b5381d86b68d](https://github.com/fanhao375/microduck-replica/commit/b5381d86b68d2e4f4606170d54d1f3f46d249ffc); pushed `2026-10-01T03:28:42Z`
- **joeynyc/awesome-microduck** `main` → [58e2c4fb5181](https://github.com/joeynyc/awesome-microduck/commit/58e2c4fb5181caf8d4ab3070162b011dd4fe27ca); pushed `2026-10-03T08:02:34Z`
- **mujocolab/mjlab** `main` → [f135c1daa0f2](https://github.com/mujocolab/mjlab/commit/f135c1daa0f278bd19e323c2b9f256ca541ae2c5); pushed `2026-10-03T10:13:26Z`
- **leggedrobotics/rsl_rl** `main` → [857de6165c5f](https://github.com/leggedrobotics/rsl_rl/commit/857de6165c5fd479726ec8ac5c9303a497766f30); pushed `2026-09-09T11:38:40Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
