# Artifact identity

Binaries are held separately. This documentation repository has no binary release or download assets. A filename is not a substitute for SHA256 verification.

| Recorded artifact | Size | SHA256 |
|---|---:|---|
| KPM Image | 38,228,032 bytes | 21739067ccfdae2f0c31b65b3a969742f1c9f3642b61ca52fe0347aedbdf15ef |
| Kernel-only guarded ZIP | 18,545,601 bytes | d12a1b6053abba8dec82a736b450f929ac8742f0aab8f328a79bef56fae824dc |
| Preserved previous fallback Image | — | 8eba51cedad03c0fcac00ab5e5252aea770e60a1fc4fa3316c8a412572826a19 |
| Preserved previous guarded fallback ZIP | — | 1ad63a1ddd6ef7cdb81c1433093f024f9fed0776ae2815e158ec227ac8e8af78 |

Candidate ZIP name: AnyKernel3_OnePlus13_CPH2653_OP5D55L1_SukiSU40959_UAPI5_SUSFS230_KPM_4K_501trust_spoofed-manager.zip.

[Package verification](../provenance/package-verification.json) records the size, mode and hash of all 14 entries. The packaged Image equals the audited KPM Image; the other 13 files and permissions match the previous reviewed guarded ZIP.

That kernel ZIP contains no APK, .ko, vendor_boot/vendor_dlkm/system_dlkm, dtbo, vbmeta or init_boot images. do.modules=0 and do.systemless=0. The separate local repository delivery ZIP contains only this handoff, not the flashable kernel ZIP.

Stock and offline-repacked boot images were analysis inputs only; no flashable boot.img is distributed here. The modified boot has no valid OEM RSA signature. Stock AVB verification and offline repack do not establish acceptance on the phone.
