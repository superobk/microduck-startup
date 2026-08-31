#!/usr/bin/env python3
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import sys

import onnxruntime as ort


def main() -> int:
    parser = argparse.ArgumentParser(description="Verify the MicroDuck ONNX deployment contract.")
    parser.add_argument("model", type=Path)
    args = parser.parse_args()

    path = args.model.expanduser().resolve()
    if not path.is_file():
        print(f"missing model: {path}", file=sys.stderr)
        return 2

    session = ort.InferenceSession(str(path), providers=["CPUExecutionProvider"])
    inputs = session.get_inputs()
    outputs = session.get_outputs()
    if len(inputs) != 1 or len(outputs) != 1:
        raise RuntimeError(f"expected one input and one output; got {len(inputs)} / {len(outputs)}")

    inp, out = inputs[0], outputs[0]
    print("model:", path)
    print("input:", inp.name, inp.shape, inp.type)
    print("output:", out.name, out.shape, out.type)
    print("metadata:", session.get_modelmeta().custom_metadata_map)
    print("sha256:", hashlib.sha256(path.read_bytes()).hexdigest())

    if inp.shape[-1] != 61:
        raise RuntimeError(f"expected 61D observation, got {inp.shape}")
    if out.shape[-1] != 14:
        raise RuntimeError(f"expected 14D action, got {out.shape}")
    print("PASS: ONNX contract is 61 -> 14")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
