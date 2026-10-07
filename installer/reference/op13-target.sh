# OP13 kernel-only target policy. No mounts or partition IO here.
# getprop adds one terminating LF; preserve any additional malformed whitespace.
OP13_LF='
'
op13_readprop() {
  OP13_PROP=$(/system/bin/getprop "$1" 2>/dev/null && printf '.') || return 1
  OP13_PROP=${OP13_PROP%.}
  OP13_PROP=${OP13_PROP%"$OP13_LF"}
}
op13_fail() { printf 'OP13: %s\n' "$*" >&2; return 1; }
op13_identity() {
  local model device
  op13_readprop ro.product.model || return 1
  model=$OP13_PROP
  if [ -z "$model" ]; then op13_readprop ro.product.vendor.model || return 1; model=$OP13_PROP; fi
  op13_readprop ro.product.device || return 1
  device=$OP13_PROP
  if [ -z "$device" ]; then op13_readprop ro.product.vendor.device || return 1; device=$OP13_PROP; fi
  [ "$model" = CPH2653 ] && [ "$device" = OP5D55L1 ] || op13_fail "Unsupported model/device: $model / $device"
}
op13_preflight() {
  local other
  op13_identity || return 1
  op13_readprop ro.boot.slot_suffix || return 1
  case "$OP13_PROP" in _a) other=_b;; _b) other=_a;; *) op13_fail 'Noncanonical active slot'; return 1;; esac
  OP13_ACTIVE_SLOT=$OP13_PROP
  OP13_BOOT_PATH=/dev/block/by-name/boot$OP13_ACTIVE_SLOT
  OP13_OTHER_PATH=/dev/block/by-name/boot$other
  [ -b "$OP13_BOOT_PATH" ] && [ -b "$OP13_OTHER_PATH" ] || { op13_fail 'Exact A/B boot block devices required'; return 1; }
  OP13_BOOT_REAL=$(/system/bin/readlink -f "$OP13_BOOT_PATH") || return 1
  OP13_OTHER_REAL=$(/system/bin/readlink -f "$OP13_OTHER_PATH") || return 1
  OP13_BOOT_DEVNO=$(/system/bin/stat -c '%t:%T' "$OP13_BOOT_REAL") || return 1
  OP13_OTHER_DEVNO=$(/system/bin/stat -c '%t:%T' "$OP13_OTHER_REAL") || return 1
  [ -n "$OP13_BOOT_DEVNO" ] && [ "$OP13_BOOT_REAL" != "$OP13_OTHER_REAL" ] && [ "$OP13_BOOT_DEVNO" != "$OP13_OTHER_DEVNO" ] || { op13_fail 'Active/inactive boot alias'; return 1; }
  # The parent bootstrap must independently validate the same target.
  if [ -n "$OP13_PARENT_SLOT" ]; then
    [ "$OP13_PARENT_SLOT" = "$OP13_ACTIVE_SLOT" ] && [ "$OP13_PARENT_REAL" = "$OP13_BOOT_REAL" ] || { op13_fail 'Target changed since bootstrap'; return 1; }
  fi
  readonly OP13_ACTIVE_SLOT OP13_BOOT_PATH OP13_BOOT_REAL OP13_BOOT_DEVNO OP13_OTHER_PATH OP13_OTHER_REAL OP13_OTHER_DEVNO OP13_LF
}
op13_assert_target() {
  local real devno other otherdev
  op13_identity || return 1
  op13_readprop ro.boot.slot_suffix || return 1
  [ "$OP13_PROP" = "$OP13_ACTIVE_SLOT" ] && [ "$SLOT" = "$OP13_ACTIVE_SLOT" ] || { op13_fail 'Active slot invariant broken'; return 1; }
  case "$BLOCK" in "$OP13_BOOT_PATH"|"$OP13_BOOT_REAL") ;; *) op13_fail 'Unexpected BLOCK'; return 1;; esac
  [ "$CUSTOMDD" = 'bs=1048576' ] || { op13_fail 'Unexpected dd arguments'; return 1; }
  [ -b "$OP13_BOOT_PATH" ] && [ -b "$BLOCK" ] && [ -b "$OP13_OTHER_PATH" ] || return 1
  real=$(/system/bin/readlink -f "$OP13_BOOT_PATH") || return 1
  [ "$real" = "$OP13_BOOT_REAL" ] && [ "$(/system/bin/readlink -f "$BLOCK")" = "$real" ] || { op13_fail 'Boot target symlink changed'; return 1; }
  devno=$(/system/bin/stat -c '%t:%T' "$real") || return 1
  other=$(/system/bin/readlink -f "$OP13_OTHER_PATH") || return 1
  otherdev=$(/system/bin/stat -c '%t:%T' "$other") || return 1
  [ "$devno" = "$OP13_BOOT_DEVNO" ] && [ "$other" = "$OP13_OTHER_REAL" ] && [ "$otherdev" = "$OP13_OTHER_DEVNO" ] && [ "$devno" != "$otherdev" ] || { op13_fail 'Boot device identity changed'; return 1; }
}
