# Microduck Intelligence Digest

Generated: `2026-10-06T18:25:23Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `ffc427fc7062` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/ffc427fc7062167989c23e054c571665843764d2)

### pollen-robotics/microduck

- Release [daemon 0.16.0](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.16.0)
- Release [daemon 0.15.3](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.15.3)
- Release [daemon 0.16.0-dev.1268.e7f8002 (webrtc-drive)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-webrtc-drive) (prerelease)
- Commit `7ee6f1e3b065` [Merge pull request #372 from pollen-robotics/pad-disconnect](https://github.com/pollen-robotics/microduck/commit/7ee6f1e3b065e52639a5554388a24e285fb6f786)
- Commit `2e6f2c39a1ee` [Merge pull request #374 from pollen-robotics/beta-camera-rotation](https://github.com/pollen-robotics/microduck/commit/2e6f2c39a1ee6a64881031fd66e3cda7ba411d4f)
- Commit `d83c6eb70781` [mediad: take the camera mount from the board — upright on the beta](https://github.com/pollen-robotics/microduck/commit/d83c6eb707810425cc88477698ac6a16e0c529a6)
- Commit `3b27fb075d29` [Merge pull request #373 from pollen-robotics/monitor-battery-mesh](https://github.com/pollen-robotics/microduck/commit/3b27fb075d2993016e0e4ca2d604d37c863e60b6)
- Commit `a71387476a60` [robotctl: draw the battery black, as it is](https://github.com/pollen-robotics/microduck/commit/a71387476a605f3c46073eebc6f1a6c413b09ebe)
- Commit `6201412cb78d` [robotctl: draw the battery in the monitor's 3D view](https://github.com/pollen-robotics/microduck/commit/6201412cb78dfff96a7c6f0a58088118a60ebe4d)
- Commit `b450ea8600d2` [Merge origin/main into pad-disconnect](https://github.com/pollen-robotics/microduck/commit/b450ea8600d271c10276f7cb3de5b3f2379d53ac)
- Commit `2fcd1528b65a` [robotd: idle look-around starts after 2 s and reaches a little further](https://github.com/pollen-robotics/microduck/commit/2fcd1528b65a1a19d0aacc0a9f481cf26a65c04c)
- PR #372 [Sit the robot down when the pad drops out, and let it look around when idle](https://github.com/pollen-robotics/microduck/pull/372) — closed
- PR #374 [mediad: take the camera mount from the board — upright on the beta](https://github.com/pollen-robotics/microduck/pull/374) — closed
- PR #373 [robotctl: draw the battery in the monitor's 3D view](https://github.com/pollen-robotics/microduck/pull/373) — closed
- PR #371 [Name a silent IMU board instead of reporting no robot](https://github.com/pollen-robotics/microduck/pull/371) — open
- PR #370 [fix(robotd): complete twist stops with a zero command](https://github.com/pollen-robotics/microduck/pull/370) — open

### mujocolab/mjlab

- PR #1218 [Preserve actuator delay state across partial resets](https://github.com/mujocolab/mjlab/pull/1218) — open

## Repository heads

- **superobk/microduck-startup** `main` → [ffc427fc7062](https://github.com/superobk/microduck-startup/commit/ffc427fc7062167989c23e054c571665843764d2); pushed `2026-10-06T06:26:42Z`
- **pollen-robotics/microduck** `main` → [7ee6f1e3b065](https://github.com/pollen-robotics/microduck/commit/7ee6f1e3b065e52639a5554388a24e285fb6f786); pushed `2026-10-06T18:24:36Z`
- **pollen-robotics/microduck_rl** `develop` → [273afe0b31c4](https://github.com/pollen-robotics/microduck_rl/commit/273afe0b31c4ab365b9ff806a927b63ac92b5ddd); pushed `2026-10-06T16:11:21Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [b5381d86b68d](https://github.com/fanhao375/microduck-replica/commit/b5381d86b68d2e4f4606170d54d1f3f46d249ffc); pushed `2026-10-01T03:28:42Z`
- **joeynyc/awesome-microduck** `main` → [88f708186f68](https://github.com/joeynyc/awesome-microduck/commit/88f708186f685554bd634d33e24e0aa230f92a13); pushed `2026-10-04T19:52:49Z`
- **mujocolab/mjlab** `main` → [bd37751b15af](https://github.com/mujocolab/mjlab/commit/bd37751b15af90863c5a84cbbc24653a4edd985c); pushed `2026-10-06T09:52:07Z`
- **leggedrobotics/rsl_rl** `main` → [857de6165c5f](https://github.com/leggedrobotics/rsl_rl/commit/857de6165c5fd479726ec8ac5c9303a497766f30); pushed `2026-09-09T11:38:40Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
