#!/bin/bash
set -euo pipefail
BASE=/home/doffi4/builds/oneplus13-sukisu
export GIT_CONFIG_GLOBAL="$BASE/state/gitconfig"
export PATH="$BASE/tools:$PATH"
exec 9>"$BASE/state/build.lock"
flock -n 9 || { echo 'Build already running'; exit 1; }
printf '%s\n' running > "$BASE/state/crc-build-status"
trap 'rc=$?; if [ "$rc" -ne 0 ]; then printf "%s\n" failed > "$BASE/state/crc-build-status"; fi' EXIT
test -f "$BASE/state/configured"
cd "$BASE/kernel_workspace"
stamp=$(date +%Y%m%d-%H%M%S)
nm="$PWD/kernel_platform/prebuilts/clang/host/linux-x86/clang-r510928/bin/llvm-nm"
# An aborted local action may leave a completed object/.cmd before genksyms
# appends #SYMVER. Recover only incomplete native 4K integrated metadata.
for cache in "$PWD"/kernel_platform/out/cache/*/common; do
 test -f "$cache/.vmlinux.objs" || continue
 grep -qx 'CONFIG_ARM64_4K_PAGES=y' "$cache/.config" || continue
 grep -qx 'CONFIG_KSU=y' "$cache/.config" || continue
 tag=$(basename "$(dirname "$cache")")
 report="$BASE/state/crc-investigation/preflight-$stamp-$tag.json"
 python3 "$BASE/tools/scripts/check-modversion-cache.py" --cache "$cache" --nm "$nm" \
  --report "$report" --invalidate-missing --backup "$BASE/state/crc-investigation/quarantine-$stamp-$tag" \
  --bazel-output-image "$PWD/kernel_platform/bazel-bin/common/kernel_aarch64/Image" \
  --bazel-output-root "$PWD/kernel_platform/bazel-out"
done
# Recover only the headers temporarily replaced by the upstream -g integration.
git -C kernel_platform/msm-kernel checkout --pathspec-from-file=files_gki_aarch64.txt
source kernel_platform/oplus/build/oplus_setup.sh sun gki
init_build_environment
export LTO=thin SYSTEM_DLKM_RE_SIGN=0 BUILD_SYSTEM_DLKM=0 KMI_SYMBOL_LIST_STRICT_MODE=0
log="$BASE/logs/build-4k-$stamp.log"
printf '%s\n' "$log" > "$BASE/state/latest-build-log"
ln -sfn "$log" "$BASE/logs/current-build.log"
set +e
python3 "$BASE/tools/scripts/build-exact-4k.py" kernel_platform/build_with_bazel.py -t sun perf -g --lto=thin \
 --cache_dir "$BASE/bazel-cache" --out_dir "$BASE/kernel_workspace/kernel_platform/out/msm-kernel-sun-perf" \
 --jobs=1 --make_jobs=4 --local_resources=memory=6500 --config=local 2>&1 | tee "$log"
rc=${PIPESTATUS[0]}
set -e
printf '%s\n' "$rc" > "$BASE/state/bazel-exit-code"
if [ "$rc" != 0 ]; then
 echo 'Kernel build failed; source tree and intermediate cache retained.'
 exit "$rc"
fi
for cache in "$PWD"/kernel_platform/out/cache/*/common; do
 test -f "$cache/.vmlinux.objs" || continue
 grep -qx 'CONFIG_ARM64_4K_PAGES=y' "$cache/.config" || continue
 grep -qx 'CONFIG_KSU=y' "$cache/.config" || continue
 tag=$(basename "$(dirname "$cache")")
 python3 "$BASE/tools/scripts/check-modversion-cache.py" --cache "$cache" --nm "$nm" \
  --report "$BASE/state/crc-investigation/postflight-$stamp-$tag.json"
done
image="$BASE/kernel_workspace/kernel_platform/out/msm-kernel-sun-perf/dist/Image"
test -s "$image" || { echo 'Missing final 4K Image'; exit 1; }
printf '%s\n' "$image" > "$BASE/state/final-image-path"
sha256sum "$image"
echo '4K Image produced; config and packaging verification follows.'
printf '%s\n' success > "$BASE/state/crc-build-status"
