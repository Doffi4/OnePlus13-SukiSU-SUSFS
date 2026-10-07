# Build and cache handoff

**This documents the recorded existing workflow. A clean-clone build from this repository has not been validated.** The full source checkout, signing/cache state and binary artifacts are held separately.

| Parameter | Recorded value |
|---|---|
| Environment | WSL Ubuntu-24.04-Recovered, Linux/ARM64 cross-build |
| Native OEM target | //msm-kernel:sun_perf_dist |
| Board / CPU / manifest | sun / sm8750 / oneplus_13_b.xml |
| Kernel branch / version | android15 / 6.6.118 |
| Page size / LTO | 4K / ThinLTO |
| Toolchain | clang-r510928; project pins captured in the manifest |

## Existing scripts

- [build-4k-wsl.sh](../scripts/reference/build-4k-wsl.sh): recorded orchestration, lock/config gates, cache preflight, native builder and postflight.
- [build-exact-4k.py](../scripts/reference/build-exact-4k.py): reuses the OEM BazelBuilder and requires exactly one native sun_perf_dist target.
- [check-modversion-cache.py](../scripts/reference/check-modversion-cache.py): checks native #SYMVER metadata; backs up incomplete objects and invalidates only metadata/a declared output so the native producer rebuilds it.

These are byte-for-byte script snapshots, including the original local Linux BASE. Do not automatically run them in another environment: the wrapper restores selected msm headers with checkout, writes build/status/cache state and retains the original pipeline parameters. Before a deliberate repeat, verify accepted pins/diffs and signing state. These scripts were not executed as part of repository preparation.

The existing environment uses tools/scripts/build-4k-wsl.sh relative to its build workspace. After OEM setup it invokes this recorded CLI:

~~~bash
python3 "$BASE/tools/scripts/build-exact-4k.py" kernel_platform/build_with_bazel.py -t sun perf -g --lto=thin \
 --cache_dir "$BASE/bazel-cache" --out_dir "$BASE/kernel_workspace/kernel_platform/out/msm-kernel-sun-perf" \
 --jobs=1 --make_jobs=4 --local_resources=memory=6500 --config=local
~~~

Native generated KMI symbol-list violation checks passed. The unchanged device pipeline uses skip_abi=true; this is not a full .501 STG source diff. Do not alter KMI/CRC/signature checks to manufacture a passing result.

## Cache checkpoint

The accepted UAPI5 rebuild reused the existing workspace/cache: 2849 objects, 1443 export objects, zero missing modversion metadata and zero invalidated .cmd files. The recorded main Bazel pass took 426.127 seconds with 22 actions and exit0; dist completed. These are observations for that pass, not a future build-time estimate.

Preserve sources, cache, the local signing certificate and reports. Stop on a failed build, inspect actual logs/preflight/postflight and fix the cause. Recloning, clearing the entire cache and replacing CRCs are not part of this workflow.

## After a new build

1. Capture its manifest, full dirty diff, actual config and build log.
2. Verify IKCONFIG, ARM64/4K Image, native target and KPM patch provenance.
3. Repeat relevant module/signature/UAPI checks against the new vmlinux/Image; an old audit does not transfer by filename.
4. Package only the audited Image with the identical reviewed guarded installer, then verify the final ZIP and offline repack.

Historical postbuild/packaging scripts depend on local OTA extraction, signing state and artifact directories. Portable automated packaging is not claimed. A binary publication needs a complete build recipe and corresponding source inventory; see the [release checklist](release-checklist.md).

For repository-only checks, run node scripts/validate-repository.cjs. This checks local links, JSON, file inventory and provenance hashes; it does not build a kernel or access a phone.
