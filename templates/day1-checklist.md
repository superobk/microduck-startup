# Day 1 Checklist

Date:
Operator:
GPU host:
Mac/browser:

## Version lock

- [ ] `work/state/upstream-versions.tsv` exists
- [ ] `microduck_rl` SHA matches
- [ ] `microduck` SHA matches
- [ ] `MicroDuckModels` SHA matches
- [ ] `microduck-replica` SHA matches
- [ ] `awesome-microduck` SHA matches

## Browser simulator

- [ ] `npm ci` succeeds
- [ ] `npm run build` succeeds
- [ ] Simulator boots
- [ ] Walk forward/back
- [ ] Turn left/right
- [ ] Sit/stand
- [ ] Kick left/right
- [ ] Ground pick
- [ ] Roller mode
- [ ] Fall recovery
- [ ] Reset

Notes:

## Control contract

- [ ] Can explain 61D observation
- [ ] Can explain 13D command
- [ ] Can list 14 joint order
- [ ] Can explain default pose + action scale
- [ ] Can explain 0.005 × 4 = 50 Hz
- [ ] Can distinguish learned policies from hand-written state machine

## RL environment

- [ ] `uv sync` succeeds
- [ ] Torch CUDA is True
- [ ] GPU count is correct
- [ ] `list-envs` shows MicroDuck tasks
- [ ] Tests pass
- [ ] Official ONNX baseline runs, or deferred due to headless viewer
- [ ] 64×5 smoke reaches iteration 5
- [ ] No NaN/Inf

Day 1 blockers:

Day 2 start decision:
