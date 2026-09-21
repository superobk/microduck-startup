# Microduck Intelligence Digest

Generated: `2026-09-21T12:54:21Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `deb5f4308abe` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/deb5f4308abe24ede44084dc8f779161d2d90ac8)

### pollen-robotics/microduck

- Release [daemon 0.14.2](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.14.2)
- Release [daemon 0.14.2-dev.1097.1f349a2 (oauth-like-telepresence)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-oauth-like-telepresence) (prerelease)
- Release [daemon 0.14.2-dev.1096.94c7e38 (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Commit `94c7e3881e3e` [Merge pull request #309 from pollen-robotics/prepare-release-0.14.2](https://github.com/pollen-robotics/microduck/commit/94c7e3881e3e27775b58f8ca16c0f193fb271fb1)
- Commit `f219f094f1c2` [Prepare release 0.14.2](https://github.com/pollen-robotics/microduck/commit/f219f094f1c2f96e020ec6427251eca4aca57c50)
- Commit `4f3a3f2af80a` [Merge pull request #307 from pollen-robotics/cpu-throttle-in-health](https://github.com/pollen-robotics/microduck/commit/4f3a3f2af80a936c5e636c692639f59c8bb7e875)
- Commit `9b0ad3372adf` [Merge main](https://github.com/pollen-robotics/microduck/commit/9b0ad3372adfcd0922439f3a698f8c15bab0decf)
- Commit `de135bad711b` [Merge pull request #308 from pollen-robotics/status-tells-degraded-apart](https://github.com/pollen-robotics/microduck/commit/de135bad711baba7f6d1c3dc1ebf589881eb9eea)
- Commit `dc9ba1b9f71b` [health: assert the trimmed row, not the whole frame](https://github.com/pollen-robotics/microduck/commit/dc9ba1b9f71b79534faabe4f461590d00487aca8)
- Commit `553660577a76` [Status can say "degraded", so a bench board stops reading as a broken one](https://github.com/pollen-robotics/microduck/commit/553660577a769b232f85514bf87cb31ebff76cfc)
- Commit `bfa5b8ba5a55` [health: what the heat is costing, beside the board temperature](https://github.com/pollen-robotics/microduck/commit/bfa5b8ba5a5516c6270f28f670a497f469f2a58a)
- PR #310 [playground: sign in the way telepresence does](https://github.com/pollen-robotics/microduck/pull/310) — open
- PR #309 [Prepare release 0.14.2](https://github.com/pollen-robotics/microduck/pull/309) — closed
- PR #307 [health: what the heat is costing, beside the board temperature](https://github.com/pollen-robotics/microduck/pull/307) — closed
- PR #308 [Status can say "degraded", so a bench board stops reading as a broken one](https://github.com/pollen-robotics/microduck/pull/308) — closed
- PR #305 [control: the bus reads with fast sync read](https://github.com/pollen-robotics/microduck/pull/305) — closed

### fanhao375/microduck-replica

- PR #31 [tools: 引入 FeeTech_HD1910M_Servo Rust 舵机调试工具](https://github.com/fanhao375/microduck-replica/pull/31) — open
- PR #30 [Feature/testtool set](https://github.com/fanhao375/microduck-replica/pull/30) — open

### mujocolab/mjlab

- PR #1188 [Judge the terrain curriculum against the distance the episode commanded](https://github.com/mujocolab/mjlab/pull/1188) — open

## Repository heads

- **superobk/microduck-startup** `main` → [deb5f4308abe](https://github.com/superobk/microduck-startup/commit/deb5f4308abe24ede44084dc8f779161d2d90ac8); pushed `2026-09-21T05:02:12Z`
- **pollen-robotics/microduck** `main` → [94c7e3881e3e](https://github.com/pollen-robotics/microduck/commit/94c7e3881e3e27775b58f8ca16c0f193fb271fb1); pushed `2026-09-21T12:47:21Z`
- **pollen-robotics/microduck_rl** `develop` → [cb70b792312d](https://github.com/pollen-robotics/microduck_rl/commit/cb70b792312d559a4da09064d92009079671815f); pushed `2026-09-17T15:47:16Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [6e41e2f958cd](https://github.com/fanhao375/microduck-replica/commit/6e41e2f958cd9bb1c7d2e428bacac2f33abc6a65); pushed `2026-09-20T14:09:37Z`
- **joeynyc/awesome-microduck** `main` → [a3815e7b73fb](https://github.com/joeynyc/awesome-microduck/commit/a3815e7b73fb1e95cbb3811d80023ed619c375ab); pushed `2026-09-19T13:07:08Z`
- **mujocolab/mjlab** `main` → [27577db821fe](https://github.com/mujocolab/mjlab/commit/27577db821fe321c819072a851bdda234b89f32d); pushed `2026-09-21T09:53:59Z`
- **leggedrobotics/rsl_rl** `main` → [857de6165c5f](https://github.com/leggedrobotics/rsl_rl/commit/857de6165c5fd479726ec8ac5c9303a497766f30); pushed `2026-09-09T11:38:40Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
