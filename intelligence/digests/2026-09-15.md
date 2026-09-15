# Microduck Intelligence Digest

Generated: `2026-09-15T17:03:08Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `89f2e04ee4c1` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/89f2e04ee4c1c073ae8ec0ac002713793696483d)

### pollen-robotics/microduck

- Release [daemon 0.13.0](https://github.com/pollen-robotics/microduck/releases/tag/daemon-v0.13.0)
- Release [daemon 0.13.0-dev.1025.fead66b (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Release [daemon 0.13.0-dev.1026.c1ef5ac (duck-ble-crate)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-duck-ble-crate) (prerelease)
- Commit `fead66bb2119` [Merge pull request #292 from pollen-robotics/btd-value-cap-512](https://github.com/pollen-robotics/microduck/commit/fead66bb21195971fcbb2858a19b1e290a9f2031)
- Commit `2ad82494958b` [clamp, because clippy is right that the two constants are ordered](https://github.com/pollen-robotics/microduck/commit/2ad82494958b23c64e95a5907f12b516a2d822c1)
- Commit `3bcc79435874` [btd: a notification may carry 512 bytes, not the MTU minus three](https://github.com/pollen-robotics/microduck/commit/3bcc79435874c283e9580a2c5ab232b779da3a28)
- Commit `5573f67fdbfc` [Merge pull request #291 from pollen-robotics/duckctl-btleplug-013](https://github.com/pollen-robotics/microduck/commit/5573f67fdbfc53e6491dfea3354d0b6bba428682)
- Commit `b51442f3146f` [duckctl: btleplug 0.13, which does not abort the process on a discovery callback](https://github.com/pollen-robotics/microduck/commit/b51442f3146f5bae4d1925ad8f8a97d164984d19)
- Commit `84684dbf104b` [Merge pull request #290 from pollen-robotics/prepare-release-0.13.0](https://github.com/pollen-robotics/microduck/commit/84684dbf104b12c581db7bfa38ccb2a0b4af466e)
- Commit `d354fd0f3711` [Prepare release 0.13.0](https://github.com/pollen-robotics/microduck/commit/d354fd0f371113709daf1384f3812c37567d8f46)
- Commit `ed68561a70e2` [Merge pull request #288 from pollen-robotics/monitor-camera-block](https://github.com/pollen-robotics/microduck/commit/ed68561a70e2976dadbc85eb586a1c92ffe36536)
- PR #293 [duck-ble: the wire contract, extracted now that a second client wants it](https://github.com/pollen-robotics/microduck/pull/293) — open
- PR #292 [btd: a notification may carry 512 bytes, not the MTU minus three](https://github.com/pollen-robotics/microduck/pull/292) — closed
- PR #291 [duckctl: btleplug 0.13, which does not abort the process on a discovery callback](https://github.com/pollen-robotics/microduck/pull/291) — closed
- PR #290 [Prepare release 0.13.0](https://github.com/pollen-robotics/microduck/pull/290) — closed

### pollen-robotics/microduck_rl

- PR #52 [Cross-stack reward parity: feet_flat sign fix, PR gate, MJX migration scaffold](https://github.com/pollen-robotics/microduck_rl/pull/52) — open

### fanhao375/microduck-replica

- Commit `62e569fc0675` [README 开头加「两条路线，选一条走」对照表](https://github.com/fanhao375/microduck-replica/commit/62e569fc0675b1e0651837de163d4a56d7277d2d)

## Repository heads

- **superobk/microduck-startup** `main` → [89f2e04ee4c1](https://github.com/superobk/microduck-startup/commit/89f2e04ee4c1c073ae8ec0ac002713793696483d); pushed `2026-09-15T11:49:26Z`
- **pollen-robotics/microduck** `main` → [fead66bb2119](https://github.com/pollen-robotics/microduck/commit/fead66bb21195971fcbb2858a19b1e290a9f2031); pushed `2026-09-15T15:54:35Z`
- **pollen-robotics/microduck_rl** `develop` → [cb70b792312d](https://github.com/pollen-robotics/microduck_rl/commit/cb70b792312d559a4da09064d92009079671815f); pushed `2026-09-15T12:08:50Z`
- **IronSpiderMan/MicroDuckModels** `main` → [f336dc0a984e](https://github.com/IronSpiderMan/MicroDuckModels/commit/f336dc0a984e8c7bf46e350cb541de54fe1bf9f8); pushed `2026-08-30T08:07:55Z`
- **fanhao375/microduck-replica** `master` → [62e569fc0675](https://github.com/fanhao375/microduck-replica/commit/62e569fc0675b1e0651837de163d4a56d7277d2d); pushed `2026-09-15T14:05:29Z`
- **joeynyc/awesome-microduck** `main` → [72640bc38e76](https://github.com/joeynyc/awesome-microduck/commit/72640bc38e76a4c7c618c7635e67ba5502e7ceed); pushed `2026-09-15T07:40:50Z`
- **mujocolab/mjlab** `main` → [8ee51fbcf806](https://github.com/mujocolab/mjlab/commit/8ee51fbcf806a7419189f706d9e394cbeb7790fa); pushed `2026-09-15T10:02:20Z`
- **leggedrobotics/rsl_rl** `main` → [857de6165c5f](https://github.com/leggedrobotics/rsl_rl/commit/857de6165c5fd479726ec8ac5c9303a497766f30); pushed `2026-09-09T11:38:40Z`

## Social feeds

No social feed is active. Configure `MICRODUCK_SOCIAL_FEED_URL` or edit `configs/intelligence-sources.json`.

## Review checklist

- Read upstream diffs before moving a pinned SHA.
- Run tests, the 64×5 smoke test and frozen evaluation in an isolated worktree.
- Do not treat a community commit or social post as verified hardware fact.
