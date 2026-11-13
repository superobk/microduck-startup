# Microduck Intelligence Digest

Generated: `2026-11-13T06:51:28Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `c102dfbf5f41` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/c102dfbf5f41ab98ee64bac703f4a4f00d6e9f34)

### pollen-robotics/microduck

- Release [daemon 0.20.1-dev.1773.c0efd78 (roller-pad-lost-crouch)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-roller-pad-lost-crouch) (prerelease)
- Release [daemon 0.20.1-dev.1787.843a234 (nfc-read)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-nfc-read) (prerelease)
- Release [daemon 0.20.1-dev.1784.cf7bcfe (nfc-mode-tags-poll-less)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-nfc-mode-tags-poll-less) (prerelease)
- Commit `a5239df21fdf` [Merge pull request #587 from pollen-robotics/auto-retry-standup](https://github.com/pollen-robotics/microduck/commit/a5239df21fdf212fbad6b3b8b5582c4e42506925)
- Commit `837f1d67310d` [robotd: out of stand-up retries, park at home until stood on its feet](https://github.com/pollen-robotics/microduck/commit/837f1d67310d27e02a7e05f361459a355a2a3108)
- Commit `ee4ccce812a0` [robotd: retry a stand-up that stalls, as Start twice does by hand](https://github.com/pollen-robotics/microduck/commit/ee4ccce812a0b81c34c9ce2d8849541aba24e7fd)
- Commit `886b62dd792a` [Merge pull request #585 from pollen-robotics/pad-head-expo-speed](https://github.com/pollen-robotics/microduck/commit/886b62dd792a3e9e958507cd5d9dd5a984f1aa20)
- Commit `85d34540eac5` [pad-map: one D-pad table, and the head-glide test finds its arrow there](https://github.com/pollen-robotics/microduck/commit/85d34540eac55c98b91b10529dafa2d96220cfcf)
- Commit `1bfbc761663d` [Merge remote-tracking branch 'origin/main' into pad-head-expo-speed](https://github.com/pollen-robotics/microduck/commit/1bfbc761663d06872d5993c6e83b183ee32aa422)
- Commit `ffe74d04e04f` [Head defaults tuned on the robot: max_speed 10, head_alpha 0.1](https://github.com/pollen-robotics/microduck/commit/ffe74d04e04f59886c77cedb2790a55c90de4730)
- Commit `5aedd7f79cbb` [pad: expo curve and speed cap on the head sticks](https://github.com/pollen-robotics/microduck/commit/5aedd7f79cbb453c1347188ce7e0ca0689065b4b)
- PR #545 [nfcd: read the ST25R100's IRQ status every 1 ms, not every 200 µs](https://github.com/pollen-robotics/microduck/pull/545) — open
- PR #587 [robotd: retry a stand-up that stalls](https://github.com/pollen-robotics/microduck/pull/587) — closed
- PR #585 [pad: expo curve and speed cap on the head sticks](https://github.com/pollen-robotics/microduck/pull/585) — closed
- PR #586 [Network LED: green on wifi, blue for a connected gamepad without wifi](https://github.com/pollen-robotics/microduck/pull/586) — closed
- PR #584 [Revert the D-pad remap (#583)](https://github.com/pollen-robotics/microduck/pull/584) — closed

### fanhao375/microduck-replica

- Commit `c6f923497957` [docs: track Microduck NFC and soccer audio previews](https://github.com/fanhao375/microduck-replica/commit/c6f9234979576b4ce8e308c5c8c07a6f9a06c4b3)
- Commit `83ab4fee82b9` [docs: track Microduck stand-up retries](https://github.com/fanhao375/microduck-replica/commit/83ab4fee82b962e4a48317a10f3556568dd27322)
- Commit `2dfb8920672b` [docs: update community QR code to Duck Replica Group 16](https://github.com/fanhao375/microduck-replica/commit/2dfb8920672b454b939fc8f6a8894aa0370732db)
- Commit `84fc40021442` [docs: track Microduck head tuning and network LED](https://github.com/fanhao375/microduck-replica/commit/84fc40021442b0cb54cd344d72a33d8899979a03)
- Commit `f97b183b0420` [docs: track Microduck LED merge and control previews](https://github.com/fanhao375/microduck-replica/commit/f97b183b042070ae693627c0febe8506997e5335)
- Commit `fd5cdb6325d0` [docs: track Microduck face LED brightness preview](https://github.com/fanhao375/microduck-replica/commit/fd5cdb6325d07c457561dea8f0ed023e3755d7b9)
- Commit `d5d7852cf12e` [docs: track Microduck ToF and phase skill proposals](https://github.com/fanhao375/microduck-replica/commit/d5d7852cf12e1b5f35b039c1793e43033815b98e)

### mujocolab/mjlab

- Commit `1b5c91c923ee` [Give RGB and depth YAM tasks distinct experiment names (#1326)](https://github.com/mujocolab/mjlab/commit/1b5c91c923ee4bc4159f3dce9cc85b52f88b6bd5)
- Commit `91d898cdc2e4` [Use configured gravity for entity orientation (#1325)](https://github.com/mujocolab/mjlab/commit/91d898cdc2e474044eaca569ece975746c887e8e)
- Commit `84f8df53dbef` [Add a docs page for the tactile sensor. (#1327)](https://github.com/mujocolab/mjlab/commit/84f8df53dbeff58d1f4dbf2f84af7212c1213525)
- PR #1327 [Add a docs page for the tactile sensor.](https://github.com/mujocolab/mjlab/pull/1327) — closed

### leggedrobotics/rsl_rl

- PR #275 [Add a TensorRT backend to the ExecuTorch export](https://github.com/leggedrobotics/rsl_rl/pull/275) — open

## Repository heads

- **superobk/microduck-startup** `main` → [c102dfbf5f41](https://github.com/superobk/microduck-startup/commit/c102dfbf5f41ab98ee64bac703f4a4f00d6e9f34); pushed `2026-11-12T19:59:04Z`
- **pollen-robotics/microduck** `main` → [a5239df21fdf](https://github.com/pollen-robotics/microduck/commit/a5239df21fdf212fbad6b3b8b5582c4e42506925); pushed `2026-11-13T06:51:17Z`
- **pollen-robotics/microduck_rl** `develop` → [0daab160d3fb](https://github.com/pollen-robotics/microduck_rl/commit/0daab160d3fb1c2cbaba16a4a19052f36709dd9e); pushed `2026-11-10T11:31:29Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [c6f923497957](https://github.com/fanhao375/microduck-replica/commit/c6f9234979576b4ce8e308c5c8c07a6f9a06c4b3); pushed `2026-11-13T06:49:45Z`
- **joeynyc/awesome-microduck** `main` → [9cfa5abca6f1](https://github.com/joeynyc/awesome-microduck/commit/9cfa5abca6f143b8af0048aeb6004dc5e67f81e8); pushed `2026-11-10T20:21:24Z`
- **mujocolab/mjlab** `main` → [1b5c91c923ee](https://github.com/mujocolab/mjlab/commit/1b5c91c923ee4bc4159f3dce9cc85b52f88b6bd5); pushed `2026-11-13T04:18:28Z`
- **leggedrobotics/rsl_rl** `main` → [8945bdcbc364](https://github.com/leggedrobotics/rsl_rl/commit/8945bdcbc364f388e14caebf547dbf302d89e491); pushed `2026-11-10T18:32:06Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
