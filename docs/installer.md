# Guarded AnyKernel3

The kernel-only installer is restricted to **CPH2653 + OP5D55L1** and the active boot slot. Device/slot guards do not certify every OOS16 firmware build.

Exact [anykernel.sh](../installer/reference/anykernel.sh), [op13-target.sh](../installer/reference/op13-target.sh) and [ak3-core.sh](../installer/reference/ak3-core.sh) are preserved for review. They are not a standalone installer package: Image, update-binary and tool binaries are absent. Do not execute these review snapshots on a phone.

Recorded settings include do.devicecheck=1, do.modules=0, do.systemless=0 and PATCH_VBMETA_FLAG=0. The real boot block node is pinned after preflight; the target is checked before split/flash. Strict model names, active-slot guards and installer bytes were preserved from the previous reviewed guarded ZIP.

During the candidate audit, the previous 54 hostile, 10 write/bootstrap and 4 full-bootstrap checks were not rerun; evidence was carried over because script bytes were identical. The new final-ZIP split/flash/repack flow was separately exercised against host file-I/O stubs without opening a real block node. ZIP integrity and Image byte identity passed.

Offline repack changed only the kernel in the analyzed boot. External DTB, vendor_boot and other stock images remained unchanged. The source installer calling flash_boot does not mean phone flashing occurred. Repository preparation did not install anything.
