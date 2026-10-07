# Credits and licensing

This repository documents upstream work without replacing its authorship.

## Original-file MIT scope

The root [MIT license](LICENSE) applies to original documentation, original handoff data summaries and scripts/validate-repository.cjs written for this project. It does not relicense third-party material or extend to a kernel binary.

Excluded from the root MIT grant: patches/ (including arch.h), installer/reference/, licenses/, scripts/reference/, provenance/source-manifest.xml and third-party source content represented in captured evidence. Those items retain their upstream/file-specific terms. The captured build/cache scripts are reference snapshots; the root license does not override any existing notices or unresolved source provenance.

## Upstream attribution

| Project | Source | Licensing basis |
|---|---|---|
| Linux / Android common kernel and contributors | [OnePlus common](https://github.com/OnePlusOSS/android_kernel_common_oneplus_sm8750) | [COPYING](licenses/Linux-COPYING.txt), [GPL-2.0](licenses/Linux-GPL-2.0.txt) and [Linux syscall exception](licenses/Linux-syscall-note.txt); file-specific SPDX applies |
| OnePlus kernel, device tree, modules and build integration | [OnePlusOSS](https://github.com/OnePlusOSS) | Published pinned sources; preserve per-file notices/SPDX rather than inventing a blanket license |
| SukiSU Ultra and contributors | [SukiSU-Ultra](https://github.com/SukiSU-Ultra/SukiSU-Ultra) | [Captured GPLv2 LICENSE](licenses/SukiSU-GPL-2.0.txt) |
| SUSFS / simonpunk and contributors | [susfs4ksu](https://gitlab.com/simonpunk/susfs4ksu) | [Captured repository GPLv3 LICENSE](licenses/SUSFS-GPL-3.0.txt); check file-specific terms for a source/binary release |
| KPM / SukiSU_patch contributors | [SukiSU_patch](https://github.com/ShirkNeko/SukiSU_patch) | Pinned reference only; no KPM binary is redistributed; a blanket license was not established by this task |
| AnyKernel3 / osm0sis and downstream Numbersf contributors | [AnyKernel3 base](https://github.com/Numbersf/AnyKernel3) | [Exact installer ZIP LICENSE](licenses/AnyKernel3-LICENSE.txt), retained with review sources |

The restored arch.h retains exact accepted bytes/hash. Its original upstream commit was not established by this documentation task. Snapshots and source diffs remain subject to their original terms.

This documentation handoff does not assert that complete corresponding-source requirements for distributing a kernel binary have been satisfied. Any binary publication needs a complete source/build inventory.

OEM firmware, stock modules, APKs, local private signing state and OEM certificates are not redistributed. Public certificate fingerprints identify recorded audit inputs; they are not signing credentials. Public runtime summaries omit serials, personal app/module inventories, app/user UIDs and raw logs.
