# AnyKernel3: OnePlus 13 CPH2653 / OP5D55L1, kernel-only.
properties() { '
kernel.string=OnePlus 13 SukiSU Ultra SUSFS 2.3.0 KPM 4K
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=OP5D55L1
device.name2=CPH2653
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; }

# Remove inherited compatibility aliases before importing upstream setup_ak.
unset block is_slot_device ramdisk_compression patch_vbmeta_flag customdd slot_select no_block_display no_magisk_check
unset CUSTOMDD magisk_patched KEEPVERITY KEEPFORCEENCRYPT PATCHVBMETAFLAG CDPATH ENV BASH_ENV LD_LIBRARY_PATH LD_PRELOAD LD_CONFIG_FILE
IFS=' 	
'
AKHOME=$(pwd -P) || exit 1
export PATH="$AKHOME/tools:$AKHOME/bin:/system/bin:/system/xbin:/sbin:/vendor/bin"
. tools/op13-target.sh || exit 1
op13_preflight || exit 1
BLOCK=$OP13_BOOT_PATH
IS_SLOT_DEVICE=1
SLOT_SELECT=active
RAMDISK_COMPRESSION=auto
PATCH_VBMETA_FLAG=0
NO_MAGISK_CHECK=1
NO_BLOCK_DISPLAY=0
CUSTOMDD='bs=1048576'
. tools/ak3-core.sh
op13_assert_target || exit 1
# Pin the real node, never dereference a mutable by-name alias for IO.
BLOCK=$OP13_BOOT_REAL
readonly BLOCK SLOT CUSTOMDD IS_SLOT_DEVICE SLOT_SELECT PATCH_VBMETA_FLAG NO_MAGISK_CHECK
op13_assert_target || exit 1
split_boot
op13_assert_target || exit 1
flash_boot
