# Microduck Intelligence Digest

Generated: `2026-10-05T14:47:38Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `6f9a9cfd14ee` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/6f9a9cfd14ee7de6800fefcfd680adac13129df1)

### pollen-robotics/microduck

- Release [daemon 0.15.2](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.15.2)
- Release [daemon 0.15.1-dev.1200.90bffec (msrv-yocto-ceiling)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-msrv-yocto-ceiling) (prerelease)
- Release [daemon 0.15.2-dev.1204.8904b65 (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Commit `8904b65d3628` [Merge pull request #356 from pollen-robotics/prepare-release-0.15.2](https://github.com/pollen-robotics/microduck/commit/8904b65d3628247069f8650d9dada12c67d77fee)
- Commit `a72beaf6d132` [Prepare release 0.15.2](https://github.com/pollen-robotics/microduck/commit/a72beaf6d13295d78d3b2d7c64feaa1bad7685d8)
- Commit `16249c54edfd` [Merge pull request #349 from pollen-robotics/pickup-detector](https://github.com/pollen-robotics/microduck/commit/16249c54edfdc79c66e75cbcc0108561ac1740f2)
- Commit `25298b1cf76d` [pickup: report being picked up as a state, not a policy](https://github.com/pollen-robotics/microduck/commit/25298b1cf76d9a601d22eeb507017649b36d6064)
- Commit `9c8a03a66603` [pickup: on by default](https://github.com/pollen-robotics/microduck/commit/9c8a03a66603bb915f8ed97b8fae8db382bbf6c9)
- Commit `c74038eab8c3` [Merge remote-tracking branch 'origin/main' into pickup-detector](https://github.com/pollen-robotics/microduck/commit/c74038eab8c384aa25611e467ad4d325330264aa)
- Commit `620affc9d1ae` [pickup: v2 model — head grips, any orientation, 180° turns; a third the size](https://github.com/pollen-robotics/microduck/commit/620affc9d1ae775051677919ed29b71885e16752)
- PR #357 [Declare the board in robotd.toml, and retire one with a single constant](https://github.com/pollen-robotics/microduck/pull/357) — open
- PR #356 [Prepare release 0.15.2](https://github.com/pollen-robotics/microduck/pull/356) — closed
- PR #355 [robotctl led: list, switch, blink and trigger the face board's LEDs](https://github.com/pollen-robotics/microduck/pull/355) — open
- PR #354 [robotd: play and record on ALSA's default when the configured card is absent](https://github.com/pollen-robotics/microduck/pull/354) — open
- PR #353 [Bring the Rust floor back to 1.89, and keep it under Yocto's 1.94](https://github.com/pollen-robotics/microduck/pull/353) — open

### pollen-robotics/microduck_rl

- Commit `273afe0b31c4` [Merge branch 'improve_velstand2' into develop](https://github.com/pollen-robotics/microduck_rl/commit/273afe0b31c4ab365b9ff806a927b63ac92b5ddd)
- Commit `454ddb91a954` [velstand: make the branch reproduce Hub v7, document the policy lineage](https://github.com/pollen-robotics/microduck_rl/commit/454ddb91a95443e054dc749706538fd0d3165ebf)
- Commit `4048a3ea14bf` [velstand yaw fix: ADD a fine yaw term instead of replacing the stock one](https://github.com/pollen-robotics/microduck_rl/commit/4048a3ea14bfa040ec24b57aa0baab8a798cb705)
- Commit `e1d518d4d043` [velstand: train out the turn-in-place yaw dead zone](https://github.com/pollen-robotics/microduck_rl/commit/e1d518d4d0438b695a8c39122f9300b45e610c6e)

### mujocolab/mjlab

- PR #1194 [Add Python 3.14 support and move to torch 2.14 with CUDA 13.](https://github.com/mujocolab/mjlab/pull/1194) — closed

## Repository heads

- **superobk/microduck-startup** `main` → [6f9a9cfd14ee](https://github.com/superobk/microduck-startup/commit/6f9a9cfd14ee7de6800fefcfd680adac13129df1); pushed `2026-10-05T05:47:33Z`
- **pollen-robotics/microduck** `main` → [8904b65d3628](https://github.com/pollen-robotics/microduck/commit/8904b65d3628247069f8650d9dada12c67d77fee); pushed `2026-10-05T14:44:03Z`
- **pollen-robotics/microduck_rl** `develop` → [273afe0b31c4](https://github.com/pollen-robotics/microduck_rl/commit/273afe0b31c4ab365b9ff806a927b63ac92b5ddd); pushed `2026-10-05T14:28:23Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [b5381d86b68d](https://github.com/fanhao375/microduck-replica/commit/b5381d86b68d2e4f4606170d54d1f3f46d249ffc); pushed `2026-10-01T03:28:42Z`
- **joeynyc/awesome-microduck** `main` → [88f708186f68](https://github.com/joeynyc/awesome-microduck/commit/88f708186f685554bd634d33e24e0aa230f92a13); pushed `2026-10-04T19:52:49Z`
- **mujocolab/mjlab** `main` → [4f7329183f09](https://github.com/mujocolab/mjlab/commit/4f7329183f097baa93af6e21e7e9241fc45bf978); pushed `2026-10-05T09:53:46Z`
- **leggedrobotics/rsl_rl** `main` → [857de6165c5f](https://github.com/leggedrobotics/rsl_rl/commit/857de6165c5fd479726ec8ac5c9303a497766f30); pushed `2026-09-09T11:38:40Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
