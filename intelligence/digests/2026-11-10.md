# Microduck Intelligence Digest

Generated: `2026-11-10T19:46:49Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `0ceeb1df54f7` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/0ceeb1df54f7631c42ee4ce0141d4af1de55088f)

### pollen-robotics/microduck

- Release [daemon 0.19.0](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.19.0)
- Release [daemon 0.19.0-dev.1685.6cb56c2 (nfcd-poll-less)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-nfcd-poll-less) (prerelease)
- Release [daemon 0.19.0-dev.1688.ef666aa (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Commit `ef666aada8a7` [Merge pull request #567 from pollen-robotics/ci-cache-apt](https://github.com/pollen-robotics/microduck/commit/ef666aada8a7e945cbbeefbf1577a091b8a8294b)
- Commit `6c994a2178a3` [ci: cache apt's downloads instead of the installed files](https://github.com/pollen-robotics/microduck/commit/6c994a2178a3e28129dfefbeb0ff21e5d937d90a)
- Commit `a89c4b2ee971` [ci: restore the apt packages from the Actions cache](https://github.com/pollen-robotics/microduck/commit/a89c4b2ee9711024fa64e7bc3a43ea1cc5c1cf9e)
- Commit `590e07a6fada` [Merge pull request #566 from pollen-robotics/lockfile-0.19.0](https://github.com/pollen-robotics/microduck/commit/590e07a6fada481315231671119a1aba10826a09)
- Commit `e27e97ab9cc8` [Cargo.lock: duck-auth and duck-gateway at 0.19.0](https://github.com/pollen-robotics/microduck/commit/e27e97ab9cc8053173d7065d425829cf40864a20)
- Commit `171a8e1a0c7e` [Merge pull request #564 from pollen-robotics/release-0.19.0](https://github.com/pollen-robotics/microduck/commit/171a8e1a0c7e2220daa4d8d2a9059e6e4db710d5)
- Commit `6bb6c67613a3` [Merge pull request #556 from pollen-robotics/codex/secure-media-and-ble-defaults](https://github.com/pollen-robotics/microduck/commit/6bb6c67613a35744e3be07a424fa0fd6df00e1be)
- Commit `4e068b2a3fb4` [Prepare release 0.19.0](https://github.com/pollen-robotics/microduck/commit/4e068b2a3fb45c526d4622ce6c38106a58448720)
- PR #567 [ci: restore the apt packages from the Actions cache](https://github.com/pollen-robotics/microduck/pull/567) — closed
- PR #545 [nfcd: read the ST25R100's IRQ status every 1 ms, not every 200 µs](https://github.com/pollen-robotics/microduck/pull/545) — open
- PR #566 [Cargo.lock: duck-auth and duck-gateway at 0.19.0](https://github.com/pollen-robotics/microduck/pull/566) — closed
- PR #564 [Prepare release 0.19.0](https://github.com/pollen-robotics/microduck/pull/564) — closed
- PR #565 [updater: a stuck release reverted by hand is not put back](https://github.com/pollen-robotics/microduck/pull/565) — open

### pollen-robotics/microduck_rl

- Commit `0daab160d3fb` [Merge branch 'velstand_v9_is_v7' into develop](https://github.com/pollen-robotics/microduck_rl/commit/0daab160d3fb1c2cbaba16a4a19052f36709dd9e)
- Commit `c4cf4dad9402` [velstand: document v7 + yaw remap (n3fg9pgq@2000), add the sim bench](https://github.com/pollen-robotics/microduck_rl/commit/c4cf4dad94021b539f68d27dd0c521874a0a880e)
- Commit `06fb48c4f17a` [velstand: v7 + anchor yaw remap only (turn-in-place fix experiment)](https://github.com/pollen-robotics/microduck_rl/commit/06fb48c4f17adf2a88d62ac580eae126637152aa)
- Commit `1a5391ab2bb0` [velstand: back to the v7 recipe (Hub v9 = v7 j4i6yoq2@1250)](https://github.com/pollen-robotics/microduck_rl/commit/1a5391ab2bb0f2a2bc79d494e6bac00c91b1a4e9)

### fanhao375/microduck-replica

- Commit `601b7da6fb63` [docs: track EEPROM setup code prototype](https://github.com/fanhao375/microduck-replica/commit/601b7da6fb631905bec3b1c13d45839969c8d425)
- Commit `00e165011bca` [docs: track velstand yaw recipe and flashlight merge](https://github.com/fanhao375/microduck-replica/commit/00e165011bcaaaae5a9d16ca6905185fa1b78822)

### mujocolab/mjlab

- PR #1310 [Stop partial resets from adding tracking error to other envs' metrics](https://github.com/mujocolab/mjlab/pull/1310) — open
- PR #1309 [Invalidate cached sensor data after the step() forward call](https://github.com/mujocolab/mjlab/pull/1309) — open

### leggedrobotics/rsl_rl

- Commit `8945bdcbc364` [Remove unused init_weights functions (#262)](https://github.com/leggedrobotics/rsl_rl/commit/8945bdcbc364f388e14caebf547dbf302d89e491)
- Commit `a2176aef999d` [Clean up algorithm statistics for the logger (#265)](https://github.com/leggedrobotics/rsl_rl/commit/a2176aef999dfe61ea43463c5dcbe6f27ac32949)
- Commit `feb2267bc4e5` [Add PPO configuration checks (#260)](https://github.com/leggedrobotics/rsl_rl/commit/feb2267bc4e5d357bb2d101eeded0e6b7b6871a1)
- Commit `b61a24b064e6` [Add SAC with optional FlashSAC components (#254)](https://github.com/leggedrobotics/rsl_rl/commit/b61a24b064e63379ed6dba1ecba0485ecbb68da9)
- PR #262 [Remove unused init_weights functions](https://github.com/leggedrobotics/rsl_rl/pull/262) — closed
- PR #265 [Clean up algorithm statistics for the logger](https://github.com/leggedrobotics/rsl_rl/pull/265) — closed
- PR #260 [Add PPO configuration checks](https://github.com/leggedrobotics/rsl_rl/pull/260) — closed
- PR #227 [Feature/flashsac integration](https://github.com/leggedrobotics/rsl_rl/pull/227) — closed

## Repository heads

- **superobk/microduck-startup** `main` → [0ceeb1df54f7](https://github.com/superobk/microduck-startup/commit/0ceeb1df54f7631c42ee4ce0141d4af1de55088f); pushed `2026-11-10T07:25:04Z`
- **pollen-robotics/microduck** `main` → [ef666aada8a7](https://github.com/pollen-robotics/microduck/commit/ef666aada8a7e945cbbeefbf1577a091b8a8294b); pushed `2026-11-10T14:45:47Z`
- **pollen-robotics/microduck_rl** `develop` → [0daab160d3fb](https://github.com/pollen-robotics/microduck_rl/commit/0daab160d3fb1c2cbaba16a4a19052f36709dd9e); pushed `2026-11-10T11:31:29Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [601b7da6fb63](https://github.com/fanhao375/microduck-replica/commit/601b7da6fb631905bec3b1c13d45839969c8d425); pushed `2026-11-10T11:52:18Z`
- **joeynyc/awesome-microduck** `main` → [b99984a56182](https://github.com/joeynyc/awesome-microduck/commit/b99984a56182525598c4187cc0138c89bc1c7c79); pushed `2026-11-05T19:49:44Z`
- **mujocolab/mjlab** `main` → [936f7a125375](https://github.com/mujocolab/mjlab/commit/936f7a12537556416addff31babbb1512dd24d70); pushed `2026-11-08T03:11:58Z`
- **leggedrobotics/rsl_rl** `main` → [8945bdcbc364](https://github.com/leggedrobotics/rsl_rl/commit/8945bdcbc364f388e14caebf547dbf302d89e491); pushed `2026-11-10T18:32:06Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
