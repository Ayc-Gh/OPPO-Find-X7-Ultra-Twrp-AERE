#!/usr/bin/env bash
set -euo pipefail
export GIT_TERMINAL_PROMPT=0
cd /aera
tree=${PHY110_DEVICE_TREE:-/aera/device/oppo/phy110}
mkdir -p device/oppo/phy110 build-record
test "$(realpath -- device/oppo/phy110)" = /aera/device/oppo/phy110
if [ "$(realpath -- "$tree")" != /aera/device/oppo/phy110 ]; then
  rsync -a --delete --exclude=.git "$tree/" device/oppo/phy110/
fi
# Remove only these retired files from the incremental ramdisk staging directory.
for library in libjc_keymint3.nxp.so libcxx.dylib.so; do
  staged="/aera/out/target/product/phy110/recovery/root/vendor/lib64/$library"
  test "$(realpath -m -- "$staged")" = "$staged"
  rm -f -- "$staged"
done
# Generic root contains an ODM firmware symlink, while PHY110 adds a real
# firmware directory. Remove the generated directory before the generic rsync;
# the device-root copy below restores it when the ramdisk is assembled.
python3 - <<'PY'
from pathlib import Path
import shutil
staged=Path('/aera/out/target/product/phy110/recovery/root/odm/firmware')
if staged.is_dir() and not staged.is_symlink():
    assert staged.resolve()==staged
    staged.resolve().relative_to(Path('/aera/out').resolve())
    assert Path('/aera/device/oppo/phy110/recovery/root/odm/firmware/tp/22825/FW_S3910_BOE_HBP.img').is_file()
    shutil.rmtree(staged)
PY
find device/oppo/phy110 -type f \( -name '*.sh' -o -name 'override-spl.sh' \) -exec chmod 755 {} +
git -C bootable/recovery checkout --detach 3a58f55c0c978f13346c02d3b3276123ca8436a9
for patch_name in phy110-r18-adaptation.patch; do
  core_patch="/aera/device/oppo/phy110/patches/$patch_name"
  if [ -f "$core_patch" ] && ! git -C bootable/recovery apply --reverse --check "$core_patch" 2>/dev/null; then
    git -C bootable/recovery apply --check "$core_patch"
    git -C bootable/recovery apply "$core_patch"
  fi
done
repo manifest -r -o build-record/resolved-manifest.xml
cp device/oppo/phy110/source-lock.json build-record/
git -C build/soong diff -- ui/build/soong.go > build-record/soong-memory-limit.patch
git -C build/blueprint diff -- context.go bootstrap/command.go > build-record/blueprint-concurrency-limit.patch
python3 device/oppo/phy110/tests/test_spl.py 2>&1 | tee build-record/spl-tests.log
g++ -std=c++17 -Wall -Wextra -Werror -Idevice/oppo/phy110/tests/stubs device/oppo/phy110/tests/libinit_harness.cpp -o build-record/phy110-libinit-test
build-record/phy110-libinit-test 2>&1 | tee build-record/libinit-tests.log
bash -n device/oppo/phy110/recovery/root/vendor/bin/override-spl.sh
bash -n device/oppo/phy110/recovery/root/system/bin/variant-script.sh
set +u
source build/envsetup.sh
lunch twrp_phy110-bp2a-eng
set -u
export ALLOW_MISSING_DEPENDENCIES=true
export SOONG_GOMEMLIMIT=16GiB
export SOONG_GOMAXPROCS=4
export SOONG_GOGC=100
export SOONG_GODEBUG=gctrace=1
export SOONG_UI_NINJA_ARGS='-j8'
rm -f build-record/build-complete.txt
m -j8 adbd recoveryimage 2>&1 | tee build-record/build.log
sha256sum out/target/product/phy110/recovery.img > build-record/recovery.sha256
date -u > build-record/build-complete.txt
