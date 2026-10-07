# Source provenance

The build basis is the published **OnePlus .401 / OOS16** source set. The .501 reference identifies the stock modules used for a separate binary audit. The phone's Android release does not change the android15 kernel branch.

## Pinned inputs

Full URLs and commits are in [source-pins.json](../provenance/source-pins.json); OEM project/toolchain revisions are captured in [source-manifest.xml](../provenance/source-manifest.xml).

| Component | Commit |
|---|---|
| kernel_manifest / oneplus_13_b.xml | f8e50677874c65b6da41057d2f39be7b4ef3c08a |
| common | e1b346b6b4f4096eb342ae3684838a942fd6f6c4 |
| msm-kernel | 6028f47faddaa27700f8dd3a1d83906ea8f27170 |
| modules/devicetree | d50b305f7da9e14715a25120a4ac7b1a4b8b97c3 |
| SukiSU builtin | 70fa0e092a2c81060823f8ae526eac14fdda2930 |
| SUSFS gki-android15-6.6 | a0f9c59e2243f8a5db955f4ad1686d5e0ad26e1a |
| SukiSU_patch / KPM | 547ae94bcaec53d030398f857950c64662043a5d |
| AnyKernel3 base | 47f23f7ece3ef212a392ec9ea5466e5f0b55d3c7 |
| Main contract reference only | 42d7fda3d787b7df90fc440a50bb9c8216a3fdef |

## Captured patch sets

| File | Basis and purpose |
|---|---|
| [common-current.patch](../patches/common-current.patch) | Full tracked diff from pinned common: builtin/SUSFS integration and accepted configuration/public-trust reference |
| [platform-current.patch](../patches/platform-current.patch) | Full modules/devicetree tracked diff: existing build-target/setup and UFS include fixes |
| [sukisu-current.patch](../patches/sukisu-current.patch) | Full tracked diff from builtin pin: existing EVENT_SERVICES/SELinux compile fix and UAPI5 compatibility changes |
| [uapi5-compat.patch](../patches/uapi5-compat.patch) | Three-file incremental change from the accepted baseline: supercall.h, dispatch.c and Makefile |
| [arch.h](../patches/arch.h) | Previously restored header missing from builtin pin; exact accepted bytes/hash |

Full current diffs capture the final state; they are alternatives to applying the same upstream/incremental changes. Do not apply SUSFS integration again on top of common-current.patch or the incremental UAPI5 patch on top of sukisu-current.patch. Incremental use requires the exact before hashes in [source-changes.json](../provenance/source-changes.json).

The driver symlink, three SUSFS source files, hash-only OEM public certificate and arch.h are listed in [extra-source-inputs.json](../provenance/extra-source-inputs.json). The three SUSFS files match the pinned upstream bytes. The restored arch.h original upstream commit was not established by this documentation task; its snapshot/hash is not presented as a guessed source revision.

OEM certificate DER fingerprint: 3d46262092ddcf253f9cf266d16be0bbd44f81bdc888c4d66dd26e388374e01a. The OEM private key is not needed or included. The public certificate is omitted here; its source/hash must be established for a separate reproducible environment. Local private build-signing state is also excluded.

[source-preservation.json](../provenance/source-preservation.json) records preservation of the accepted common/msm dirty diffs during the UAPI5 backport. The complete main branch was not imported because it does not preserve this SUSFS integration.

A historical generic Build-SukiSU.yml was located but is not distributed as working CI. [ci-reference.json](../provenance/ci-reference.json) records its hash and limitation. The earlier integration script that removed protected exports is excluded; the final accepted configuration preserves protection.
