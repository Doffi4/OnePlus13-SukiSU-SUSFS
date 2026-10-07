# Audit scope

Results apply to the specific recorded Image/ZIP in [artifact hashes](artifacts.md), not to arbitrary future builds. [audit-summary.json](../provenance/audit-summary.json) summarizes the full recorded audit with local paths removed.

## Module and trust audit

The supplied set contains 1068 files: 514 vendor_boot, 458 vendor_dlkm and 96 system_dlkm; 707 unique binaries. Duplicate copies are not distinct drivers.

| Check | Recorded result |
|---|---:|
| CRC mismatches / matching comparisons | 0 / 58,315 |
| Strong imports with no provider in the supplied set | 0 |
| GKI restricted / protected-export denials | 0 / 0 |
| Namespace / GPL / duplicate-kernel-export issues | 0 / 0 / 0 |
| Vermagic flag mismatches / modules with __versions | 0 / 1068 |
| Module versions independently read by modprobe | 1068 / 1068 |
| System-DLKM PKCS7 signatures against actual vmlinux keys | 96 / 96 |
| Exports and CRC words preserved in raw/KPM Image | 9001 / 9001 |

Different vermagic release suffixes were not concealed. The native same_magic loader path compares the remaining flags when MODVERSIONS and __versions are present; CRCs were checked separately. Force-loading was not used.

Actual config SHA256: 8be279098266156bae32ae998b8ffd13ecfbfdf943a140037f4f8139801e6ea0. MODULE_SIG_PROTECT, MODVERSIONS, MODULE_SIG/ALL and the trusted keyring were preserved. Local certificate DER hash: 545788f3ea9dc2907900a53e05daab6095a526380e65f9ab6abdf97d21a332d1. The OEM .501 certificate DER hash is recorded in [provenance](provenance.md). Stock modules were neither modified nor re-signed.

PKCS7 verification used -nointern and extracted actual vmlinux trusted keys only. A local-only negative control rejected stock signatures. No OEM private key was used.

## UAPI5 contract and binary proof

[after-contracts.json](../provenance/after-contracts.json) records 56 shared constants, 26 additional feature/sepolicy constants, 28 structure sizes and matching fields/app_profile/sulog. Extracted real functions passed host checks for services start/skip/reset, once-only boot with the SUSFS monitor, EFAULT and GET_INFO flags; scoped FD semantics and permission gates were preserved.

[binary-UAPI-proof.json](../provenance/binary-UAPI-proof.json) identifies version40959/UAPI5 directly in ARM64 GET_INFO and matching GET_INFO, REPORT_EVENT, install_fd/install_su_fd function bytes in vmlinux/raw/KPM Image. The supplied manager signer SHA256 947ae944f3de4ed4c21a7e4f7953ecf351bfa2b36239da37a34111ad29993eef and DER size860 match the builtin trust record; no fixed manager-package compile flag was present.

This is not bit-for-bit reproduction of the supplied APK or runtime proof of exec/SELinux/FD/manager selection.

## Evidence boundary

Native [KMI checks](../provenance/KMI-checks.json) are generated symbol-list checks, not a full STG diff against unpublished .501 sources. The module audit covers the supplied files only. Offline binary compatibility does not establish closed-driver internal behavior, load order, recovery acceptance or panic-free boot.

Raw logs, modules, certificates, images and individual full module reports are excluded. [evidence-index.json](../provenance/evidence-index.json) links portable summaries to their original hashes. Repository preparation did not rerun the kernel audit. A later read-only checkpoint identified the previous phone baseline; it does not validate the new candidate runtime.
