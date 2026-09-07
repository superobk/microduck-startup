# Microduck Intelligence Digest

Generated: `2026-09-07T21:33:19Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `c2b997037f4a` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/c2b997037f4a0894207a705bee513c9b2982366f)

### pollen-robotics/microduck

- Release [daemon 0.11.0](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.11.0)
- Release [daemon 0.11.0-dev.883.00f61f8 (vslam)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-vslam) (prerelease)
- Release [daemon 0.10.0-dev.879.2235e6c (vision-demo)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-vision-demo) (prerelease)
- Commit `5984efb77085` [Merge pull request #222 from pollen-robotics/prepare-release-0.11.0](https://github.com/pollen-robotics/microduck/commit/5984efb770855432b03dafd3d879e9929981e45b)
- Commit `a7870ddd5bf3` [Prepare release 0.11.0](https://github.com/pollen-robotics/microduck/commit/a7870ddd5bf379e5c4433e375181db07868d3562)
- Commit `562d330ec5db` [Merge pull request #207 from Nixxx19/a-restarted-daemon-gets-the-next-request](https://github.com/pollen-robotics/microduck/commit/562d330ec5dba0d7072b9b6b05cc84c7699e7c04)
- Commit `b6b9f163250b` [Merge pull request #210 from pollen-robotics/start-twice](https://github.com/pollen-robotics/microduck/commit/b6b9f163250b5043ae24667f6689226a26dd7fa0)
- Commit `9697804354f2` [Merge pull request #218 from tianrking/fix/robotd-single-instance](https://github.com/pollen-robotics/microduck/commit/9697804354f2c2dba11fb8fb478b94c91a7417f2)
- Commit `7c3fe039e029` [Merge main: Select's torque off and Start's two presses in one pad](https://github.com/pollen-robotics/microduck/commit/7c3fe039e029eb7d37a0141c4436c7996c73d855)
- Commit `4eb5ec5a4e34` [Merge pull request #212 from pollen-robotics/select-relax](https://github.com/pollen-robotics/microduck/commit/4eb5ec5a4e34d7147699ee5d18c9b2f5cd6829d2)
- Commit `034c1a5435c9` [robotd: hold the endpoint lock throughout standalone init](https://github.com/pollen-robotics/microduck/commit/034c1a5435c974c8deed1cba91d0d3f9f92e6e89)
- PR #234 [configd: reading the pairing pin takes the authority that sets it](https://github.com/pollen-robotics/microduck/pull/234) — open
- PR #232 [VSLAM telemetry on top of the MuJoCo twin: shared clock, head IMU, sensor poses, skeleton (API v24–v25)](https://github.com/pollen-robotics/microduck/pull/232) — open
- PR #231 [Support LSTM ONNX policies with recurrent state handling](https://github.com/pollen-robotics/microduck/pull/231) — open
- PR #230 [the account token gets a group of its own, with mediad as its only member](https://github.com/pollen-robotics/microduck/pull/230) — open
- PR #228 [robotd: a mode switch waits for a policy load, and a policy change waits for a shutdown](https://github.com/pollen-robotics/microduck/pull/228) — open

### pollen-robotics/microduck_rl

- PR #44 [reuse NUM_STEPS_PER_ENV in the RslRlOnPolicyRunnerCfg](https://github.com/pollen-robotics/microduck_rl/pull/44) — open
- PR #43 [docs: note that the viewer needs mjpython on macOS](https://github.com/pollen-robotics/microduck_rl/pull/43) — open

## Repository heads

- **superobk/microduck-startup** `main` → [c2b997037f4a](https://github.com/superobk/microduck-startup/commit/c2b997037f4a0894207a705bee513c9b2982366f); pushed `2026-09-07T12:40:14Z`
- **pollen-robotics/microduck** `main` → [5984efb77085](https://github.com/pollen-robotics/microduck/commit/5984efb770855432b03dafd3d879e9929981e45b); pushed `2026-09-07T20:22:09Z`
- **pollen-robotics/microduck_rl** `develop` → [2b25a48b08f1](https://github.com/pollen-robotics/microduck_rl/commit/2b25a48b08f1f17bc38c90bb03144c81fbd9ed07); pushed `2026-09-07T17:13:27Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [73e2118dc0b5](https://github.com/fanhao375/microduck-replica/commit/73e2118dc0b5bf463ab7d422e5274c29adfd9ea7); pushed `2026-09-07T04:31:24Z`
- **joeynyc/awesome-microduck** `main` → [8f0239473ce6](https://github.com/joeynyc/awesome-microduck/commit/8f0239473ce626629341c0bbc97ed2471543e9cb); pushed `2026-09-06T18:08:28Z`
- **mujocolab/mjlab** `main` → [8ee51fbcf806](https://github.com/mujocolab/mjlab/commit/8ee51fbcf806a7419189f706d9e394cbeb7790fa); pushed `2026-09-07T10:44:22Z`
- **leggedrobotics/rsl_rl** `main` → [00e13d1aa49b](https://github.com/leggedrobotics/rsl_rl/commit/00e13d1aa49b398ae512f1765297f7ab8c50ca07); pushed `2026-08-31T10:29:25Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
