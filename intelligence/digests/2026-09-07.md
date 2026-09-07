# Microduck Intelligence Digest

Generated: `2026-09-07T12:39:59Z`

The pinned reproduction baseline is not changed by this digest. Review upstream changes in a worktree before updating pins.

## New since previous snapshot

### superobk/microduck-startup

- Commit `0a06823fa233` [chore(intel): refresh Microduck sources \[skip ci\]](https://github.com/superobk/microduck-startup/commit/0a06823fa233949bc852d89434e26d09329e2de1)

### pollen-robotics/microduck

- Release [daemon 0.10.0-dev.852.4ef3aee (relay-session)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-relay-session) (prerelease)
- Release [daemon 0.10.0-dev.842.18eb409 (main)](https://github.com/pollen-robotics/microduck/releases/tag/daemon-dev-main) (prerelease)
- Commit `18eb409d8214` [Merge pull request #209 from pollen-robotics/relay-producer](https://github.com/pollen-robotics/microduck/commit/18eb409d82141397362d03afd77303ad6701e6fb)
- Commit `8088ac44bc40` [Signing a robot out has to reach the relay, or it does not mean anything](https://github.com/pollen-robotics/microduck/commit/8088ac44bc40c937591f36c6a1085e2a87ee0d74)
- Commit `3ea772936951` [A duck registers with the rendezvous service, which is half of reaching one](https://github.com/pollen-robotics/microduck/commit/3ea77293695116a3b26120e806f731434f615462)
- PR #219 [The console page learns a second way in, and §5 stops being open](https://github.com/pollen-robotics/microduck/pull/219) — open
- PR #181 [apply clippy float optimization recommendations](https://github.com/pollen-robotics/microduck/pull/181) — open

### pollen-robotics/microduck_rl

- Commit `2b25a48b08f1` [apartment: 1.6 m walls so the camera never sees the skybox](https://github.com/pollen-robotics/microduck_rl/commit/2b25a48b08f1f17bc38c90bb03144c81fbd9ed07)
- Commit `333120343134` [apartment: walls with texture, floors with contrast, so a camera has something to track](https://github.com/pollen-robotics/microduck_rl/commit/3331203431341f207f3f7ea8ebf1b0f1d966a889)
- Commit `43bf151d57ac` [The head camera faces backwards; turn it about the right axis](https://github.com/pollen-robotics/microduck_rl/commit/43bf151d57ac963c6cd3e945af416dc4d39c81ec)
- Commit `580f0d8596a5` [The head camera faces backwards; turn it around](https://github.com/pollen-robotics/microduck_rl/commit/580f0d8596a573bd2efe1fb56dec3528416d1a81)
- Commit `a52752e4a629` [Run a forward pass before anything can ask, and never hand mj_ray a zero](https://github.com/pollen-robotics/microduck_rl/commit/a52752e4a629f8404ea18a443ad5a685169a89ff)
- Commit `b5e6e6485727` [What a duck sees](https://github.com/pollen-robotics/microduck_rl/commit/b5e6e6485727455c61e7e0db3fb2eb854fa72eab)
- PR #18 [Add new scenes: simple, intermediate, complex, parkour, maze](https://github.com/pollen-robotics/microduck_rl/pull/18) — open

### fanhao375/microduck-replica

- PR #18 [imu_to_dxl 改版：25×25 mm，四角金属化 M2，双面地，附生产文件](https://github.com/fanhao375/microduck-replica/pull/18) — open

## Repository heads

- **superobk/microduck-startup** `main` → [0a06823fa233](https://github.com/superobk/microduck-startup/commit/0a06823fa233949bc852d89434e26d09329e2de1); pushed `2026-09-07T04:47:51Z`
- **pollen-robotics/microduck** `main` → [18eb409d8214](https://github.com/pollen-robotics/microduck/commit/18eb409d82141397362d03afd77303ad6701e6fb); pushed `2026-09-07T12:36:57Z`
- **pollen-robotics/microduck_rl** `develop` → [2b25a48b08f1](https://github.com/pollen-robotics/microduck_rl/commit/2b25a48b08f1f17bc38c90bb03144c81fbd9ed07); pushed `2026-09-07T08:46:36Z`
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
