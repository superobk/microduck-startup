# Microduck Intelligence Digest

Generated: `2026-09-02T16:37:54Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `c07c5bc9ff60` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/c07c5bc9ff60e6a28d34bd9d7c5720b9c041bb3e)

### pollen-robotics/microduck

- Release [daemon 0.10.0-dev.813.72dde90 (remote-access-design)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-remote-access-design) (prerelease)
- Release [daemon 0.10.0-dev.802.a565325 (reboot-motors)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-reboot-motors) (prerelease)
- Release [daemon 0.10.0-dev.811.068e8e2 (policy-hub-design)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-policy-hub-design) (prerelease)
- PR #205 [Remote access: a robot can belong to a Hugging Face account](https://github.com/pollen-robotics/microduck/pull/205) — open
- PR #203 [robot.rebootMotors: reboot servos in place (`robotctl robot reboot-motors`, D-pad-right)](https://github.com/pollen-robotics/microduck/pull/203) — open
- PR #204 [Four daemons were doing work nobody had asked for](https://github.com/pollen-robotics/microduck/pull/204) — open
- PR #202 [maploc on the MuJoCo twin: a mirrored sensor, a fall at enable, and a route steered on stale odometry](https://github.com/pollen-robotics/microduck/pull/202) — open

### pollen-robotics/microduck_rl

- Commit `5bbe9637294d` [Merge pull request #31 from pollen-robotics/publish_policies](https://github.com/pollen-robotics/microduck_rl/commit/5bbe9637294d0c794edb185e284cfb1a77c6a0b4)
- Commit `53043f2fdd06` [publish: a perpetual gait needs no unwind](https://github.com/pollen-robotics/microduck_rl/commit/53043f2fdd06a65c27b7a27544b3e4dc9e864f44)
- Commit `8dc749c4d4a1` [docs: README section on publishing a policy to the Hub](https://github.com/pollen-robotics/microduck_rl/commit/8dc749c4d4a13fa9ff060343e94d96d8e917aa78)
- Commit `e2b81dbd1803` [feat: `uv run publish` — share a policy on the Hub in the shape the daemon loads](https://github.com/pollen-robotics/microduck_rl/commit/e2b81dbd1803c2314983cfff30d87213ee5bb50e)
- PR #31 [feat: `uv run publish` — share a policy on the Hub in the shape the daemon loads](https://github.com/pollen-robotics/microduck_rl/pull/31) — closed
- PR #30 [sim: the ToF numbered its columns backwards](https://github.com/pollen-robotics/microduck_rl/pull/30) — open

## Repository heads

- **superobk/microduck-startup** `main` → [c07c5bc9ff60](https://github.com/superobk/microduck-startup/commit/c07c5bc9ff60e6a28d34bd9d7c5720b9c041bb3e); pushed `2026-09-02T14:14:11Z`
- **pollen-robotics/microduck** `main` → [2c61dcc1f034](https://github.com/pollen-robotics/microduck/commit/2c61dcc1f03440541cdc0729f7a375b2a9ea3005); pushed `2026-09-02T16:18:47Z`
- **pollen-robotics/microduck_rl** `develop` → [5bbe9637294d](https://github.com/pollen-robotics/microduck_rl/commit/5bbe9637294d0c794edb185e284cfb1a77c6a0b4); pushed `2026-09-02T15:44:51Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [d60cd2e89b0e](https://github.com/fanhao375/microduck-replica/commit/d60cd2e89b0ebda6f60e92d44a5fa7e61d6d76f6); pushed `2026-09-01T16:14:34Z`
- **joeynyc/awesome-microduck** `main` → [6298c095fe68](https://github.com/joeynyc/awesome-microduck/commit/6298c095fe68c4ca45a5aa4ae7d33b4be925692d); pushed `2026-09-02T06:26:16Z`
- **mujocolab/mjlab** `main` → [8ee51fbcf806](https://github.com/mujocolab/mjlab/commit/8ee51fbcf806a7419189f706d9e394cbeb7790fa); pushed `2026-09-02T10:33:01Z`
- **leggedrobotics/rsl_rl** `main` → [00e13d1aa49b](https://github.com/leggedrobotics/rsl_rl/commit/00e13d1aa49b398ae512f1765297f7ab8c50ca07); pushed `2026-08-31T10:29:25Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
