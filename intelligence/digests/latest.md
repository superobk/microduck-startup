# Microduck Intelligence Digest

Generated: `2026-11-21T19:20:55Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `ea095b580cff` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/ea095b580cff070bc8063931d1456080898d60ec)

### pollen-robotics/microduck

- Release [daemon 0.23.0-dev.1869.d585dd8 (seated-skills)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-seated-skills) (prerelease)
- Release [daemon 0.18.0-dev.1868.36ae166 (ep5-scoot)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-ep5-scoot) (prerelease)
- PR #537 [spaces: preserve control replies across HTTP chunks](https://github.com/pollen-robotics/microduck/pull/537) — open
- PR #538 [duck-sim: preserve scene paths when launching the body](https://github.com/pollen-robotics/microduck/pull/538) — open
- PR #536 [duck-sim: match shutdown paths literally](https://github.com/pollen-robotics/microduck/pull/536) — open

### pollen-robotics/microduck_rl

- PR #92 [Fit a VelStand gait-onset candidate for duck-sim](https://github.com/pollen-robotics/microduck_rl/pull/92) — open

### fanhao375/microduck-replica

- Release [2026.11.23 正式软件 · 保留舵机中位，支持导入 IMU 方向](https://github.com/fanhao375/microduck-replica/releases/tag/microduck-software-v2026.11.23)
- Release [2026.11.22 正式软件 · 修复升级后 Studio 显示旧页面](https://github.com/fanhao375/microduck-replica/releases/tag/microduck-software-v2026.11.22)
- Commit `db596f9f1eea` [docs: track formal software 2026.11.23 and verified 1104 refresh](https://github.com/fanhao375/microduck-replica/commit/db596f9f1eead10229728696548465c47a28461c)
- Commit `1f0ff4550f76` [Point existing 1104 cards to the signed 2026.11.23 update](https://github.com/fanhao375/microduck-replica/commit/1f0ff4550f762bb326d9dd3ed757997b2e042cce)
- Commit `24379951746c` [Preserve saved servo centers through onboarding and IMU import](https://github.com/fanhao375/microduck-replica/commit/24379951746c351c0e2d0f133c51d94d56459375)
- Commit `ae22b8832304` [Studio: import an existing IMU mounting on the IMU page](https://github.com/fanhao375/microduck-replica/commit/ae22b8832304a62467d7795b061eb4951904d24a)
- Commit `d68c55fbf7ec` [docs: track VelStand onset draft and refreshed tool PR sources](https://github.com/fanhao375/microduck-replica/commit/d68c55fbf7ecc56ca9b1bfdb2e8d160c874a7698)
- Commit `cbfe1bfd7462` [docs: link the November 19 Feetech roller skate print project](https://github.com/fanhao375/microduck-replica/commit/cbfe1bfd746257b47c860f725d0fac2e18a53d09)
- Commit `aba608b1884e` [docs: track seated skills API69 and refreshed 1104 release](https://github.com/fanhao375/microduck-replica/commit/aba608b1884e0e465adc3e4e36270f59deb2e6f9)
- Commit `7a0bddf0d73c` [Bake signed stable software into the ZERO 3W 1104 factory image](https://github.com/fanhao375/microduck-replica/commit/7a0bddf0d73c8201e0b4186c2100c0cd0fafaa4c)

### leggedrobotics/rsl_rl

- PR #255 [\[main\] Add SuperMimic model-based training](https://github.com/leggedrobotics/rsl_rl/pull/255) — open

## Repository heads

- **superobk/microduck-startup** `main` → [ea095b580cff](https://github.com/superobk/microduck-startup/commit/ea095b580cff070bc8063931d1456080898d60ec); pushed `2026-11-21T07:16:01Z`
- **pollen-robotics/microduck** `main` → [56424efe58b7](https://github.com/pollen-robotics/microduck/commit/56424efe58b7de40efcf3b2d3a5cd169ee83a182); pushed `2026-11-21T16:22:58Z`
- **pollen-robotics/microduck_rl** `develop` → [0daab160d3fb](https://github.com/pollen-robotics/microduck_rl/commit/0daab160d3fb1c2cbaba16a4a19052f36709dd9e); pushed `2026-11-17T06:28:41Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [db596f9f1eea](https://github.com/fanhao375/microduck-replica/commit/db596f9f1eead10229728696548465c47a28461c); pushed `2026-11-21T19:20:32Z`
- **joeynyc/awesome-microduck** `main` → [944ad8fad819](https://github.com/joeynyc/awesome-microduck/commit/944ad8fad819756d3d7f98b8458b812dafb466ec); pushed `2026-11-18T20:51:41Z`
- **mujocolab/mjlab** `main` → [55182f0903b8](https://github.com/mujocolab/mjlab/commit/55182f0903b8359033fca90560aab871c417465d); pushed `2026-11-21T11:13:46Z`
- **leggedrobotics/rsl_rl** `main` → [4c9900fe2428](https://github.com/leggedrobotics/rsl_rl/commit/4c9900fe242805266b30a91cd75302a6ad376833); pushed `2026-11-20T17:06:26Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
