# OnePlus13-SukiSU-SUSFS

Source pins, patches and audit documentation for a **OnePlus 13 CPH2653 / OP5D55L1** kernel candidate: SukiSU builtin, SUSFS 2.3.0, KPM, 4K and ThinLTO.

[Documentation](docs/README.md) · [Source provenance](docs/provenance.md) · [Audit scope](docs/audit.md) · [License](LICENSE)

> [!IMPORTANT]
> **Kernel binary audit: PASS. UAPI5 phone transition: NOT READY.**
> A fresh read-only checkpoint after the reported reset identified the previous trust501 kernel and current UAPI2 userspace. The new UAPI5 candidate has not been booted or tested on the phone. Its manager/daemon transition still needs coordinated preparation.

| Platform | Build | Root integration | Repository scope |
|---|---|---|---|
| SM8750 / sun / OOS16 | Android-15 kernel 6.6.118 · 4K · ThinLTO | SukiSU builtin 40959 · UAPI5 compatibility backport · SUSFS 2.3.0 · KPM | Source/patch/audit handoff; no binary release |

## What is here

- Pinned upstream projects, the OEM repo manifest and captured accepted working-tree diffs.
- The three-file incremental UAPI5 patch, restored arch header and accepted build/cache script snapshots.
- Redacted audit summaries, artifact identities and guarded installer review sources.
- Compatibility limits, reproducibility boundaries and a release checklist.

This is **not a complete kernel checkout**. A clean-clone rebuild and bit-for-bit reproduction have not been validated. Image, APK, stock firmware/modules, certificates, private signing state and personal runtime logs are excluded.

## Evidence at a glance

| Recorded offline check | Result |
|---|---:|
| Stock .501 module files / unique binaries | 1068 / 707 |
| CRC comparisons | 58,315 matches; 0 mismatches |
| Unresolved strong imports in the provided set | 0 |
| GKI restrictions / protected exports / namespaces / GPL issues | 0 failures |
| System-DLKM signatures against actual vmlinux trusted keys | 96 / 96 |
| Kernel exports and CRCs retained | 9001 / 9001 |
| Native generated KMI symbol-list checks | Passed; full .501 STG source ABI diff not performed |
| Audited kernel ZIP | Image + 13 guarded AnyKernel3 files; kernel only |

See [audit boundaries](docs/audit.md), [artifact hashes](docs/artifacts.md) and [machine-readable evidence](provenance/audit-summary.json). These are results for the recorded candidate, not a guarantee for future builds or firmware.

## Compatibility

| Target | Status |
|---|---|
| CPH2653 + OP5D55L1, OOS16 / provided .501 stock-module set | Offline module audit passed; UAPI5 transition not ready |
| Published OnePlus .401 sources / native sun_perf_dist | Accepted source/build basis |
| Current phone checkpoint: OOS16.0.10.501, previous trust501 kernel, normal manager40900/daemon UAPI2 | Read-only observation; root and Fix4.1 NVBK alias/loop backing confirmed |
| UAPI5 manager/ksud corresponding to reference 42d7fda3 | Contract/binary checks passed; runtime transition untested |
| Other devices, firmware, page sizes or recoveries | Not covered |

The kernel remains on builtin to preserve SUSFS. The complete main branch was not ported. Custom main modules.rc/init scripts, CPU/UTS CLI ioctls104/105 and debug mark are unsupported. No Play Integrity or root-invisibility result is promised.

## Start here

1. Read [current status](docs/status.md) and [build/cache handoff](docs/build.md).
2. Review [pins and patch relationships](docs/provenance.md), then [installer guards](docs/installer.md).
3. Use the [release checklist](docs/release-checklist.md) before any binary publication or device test.

No automated flashing, phone install or CI deployment is configured. Original documentation/helpers use a scoped MIT license; third-party snapshots retain upstream terms. See [NOTICE](NOTICE.md).
