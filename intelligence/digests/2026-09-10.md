# Microduck Intelligence Digest

Generated: `2026-09-10T11:25:01Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `3bf697998324` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/3bf69799832454ffe1dc7975764e838b431ad253)

### pollen-robotics/microduck

- Release [daemon 0.12.0](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.12.0)
- Release [daemon 0.12.0-dev.959.78fe1fc (rkaiq-supervision)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-rkaiq-supervision) (prerelease)
- Release [daemon 0.12.0-dev.957.afc8e9b (rename-imu-head-config)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-rename-imu-head-config) (prerelease)
- Commit `1fa3ff7403ec` [Merge pull request #231 from Vottivott/feat/recurrent-onnx-policies](https://github.com/pollen-robotics/microduck/commit/1fa3ff7403ecbadc9e2dfaecb194fa52e5b38d08)
- Commit `213a5ce90ec5` [Merge pull request #257 from pollen-robotics/prepare-release-0.12.0](https://github.com/pollen-robotics/microduck/commit/213a5ce90ec5f2605b6e6977b75672d9d2eea8c5)
- Commit `ee282ae6e0a2` [Prepare release 0.12.0](https://github.com/pollen-robotics/microduck/commit/ee282ae6e0a22cb4ed1548a7879d5b4dca0c85fb)
- Commit `06304bac8e83` [Merge pull request #256 from pollen-robotics/head-imu-restarts-tofd](https://github.com/pollen-robotics/microduck/commit/06304bac8e833df81bd4540735901726cf9ceafb)
- Commit `94bdb4503c0b` [configure: restart, reload, or nothing — per key](https://github.com/pollen-robotics/microduck/commit/94bdb4503c0b722ff45a0f7f0c0ed5f70fb7b525)
- Commit `54bb524dfb43` [Merge pull request #251 from pollen-robotics/head-imu-two-reads](https://github.com/pollen-robotics/microduck/commit/54bb524dfb434fc0bcac40bb10ba9c3543403605)
- Commit `b0ed653dbfbe` [Pin bmi088 to the released v0.1.2, not the PR branch rev](https://github.com/pollen-robotics/microduck/commit/b0ed653dbfbed61821b36c7acbf01dc08b42477f)
- Commit `8a4d2244e8dd` [configure: `\[head_imu\]` restarts tofd, not robotd](https://github.com/pollen-robotics/microduck/commit/8a4d2244e8ddae9310f3094c1bad81184fba5689)
- PR #234 [configd: reading the pairing pin takes the authority that sets it](https://github.com/pollen-robotics/microduck/pull/234) — open
- PR #230 [the account token gets a group of its own, with mediad as its only member](https://github.com/pollen-robotics/microduck/pull/230) — open
- PR #228 [robotd: a mode switch waits for a policy load, and a policy change waits for a shutdown](https://github.com/pollen-robotics/microduck/pull/228) — open
- PR #226 [robotd: refuse a non-socket path before bind, on every platform](https://github.com/pollen-robotics/microduck/pull/226) — open
- PR #197 [updater: boot recovery waits for a robot that is still starting, the way the gate does](https://github.com/pollen-robotics/microduck/pull/197) — open

### fanhao375/microduck-replica

- Commit `7e4a121d7216` [换微信群二维码：四群已满，改挂五群的码（有效期到 2026-09-17）](https://github.com/fanhao375/microduck-replica/commit/7e4a121d7216d627b885035031e6665f2e52c643)

## Repository heads

- **superobk/microduck-startup** `main` → [3bf697998324](https://github.com/superobk/microduck-startup/commit/3bf69799832454ffe1dc7975764e838b431ad253); pushed `2026-09-10T04:48:33Z`
- **pollen-robotics/microduck** `main` → [1fa3ff7403ec](https://github.com/pollen-robotics/microduck/commit/1fa3ff7403ecbadc9e2dfaecb194fa52e5b38d08); pushed `2026-09-10T11:05:03Z`
- **pollen-robotics/microduck_rl** `develop` → [53b8971b61ba](https://github.com/pollen-robotics/microduck_rl/commit/53b8971b61baf5b7f3c16d135dd7cac37623de4b); pushed `2026-09-10T09:40:07Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [7e4a121d7216](https://github.com/fanhao375/microduck-replica/commit/7e4a121d7216d627b885035031e6665f2e52c643); pushed `2026-09-10T08:46:09Z`
- **joeynyc/awesome-microduck** `main` → [b724bae08cab](https://github.com/joeynyc/awesome-microduck/commit/b724bae08caba353375dff1fa4ac842b4e9ebceb); pushed `2026-09-10T03:05:03Z`
- **mujocolab/mjlab** `main` → [8ee51fbcf806](https://github.com/mujocolab/mjlab/commit/8ee51fbcf806a7419189f706d9e394cbeb7790fa); pushed `2026-09-10T10:18:26Z`
- **leggedrobotics/rsl_rl** `main` → [857de6165c5f](https://github.com/leggedrobotics/rsl_rl/commit/857de6165c5fd479726ec8ac5c9303a497766f30); pushed `2026-09-09T11:38:40Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
