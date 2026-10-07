#!/usr/bin/env python3
"""Reuse the OEM builder, accepting only the exact native 4K dist label."""
import runpy
import sys

source = sys.argv.pop(1)
namespace = runpy.run_path(source)
builder = namespace['BazelBuilder']
original = builder.get_build_targets

def exact_targets(self):
    targets = [t for t in original(self)
               if t.bazel_label == '//msm-kernel:sun_perf_dist']
    if len(targets) != 1:
        raise RuntimeError('Expected exactly one native sun_perf_dist target')
    print('Selected ONLY native 4K target:', targets[0].bazel_label, flush=True)
    return targets

builder.get_build_targets = exact_targets
namespace['main']()
