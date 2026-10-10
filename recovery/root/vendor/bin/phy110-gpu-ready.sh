#!/system/bin/sh
[ "$(getprop ro.recovery.phy110.supported)" = 1 ] || exit 0
if [ ! -c /dev/kgsl-3d0 ]; then
    /system/bin/insmod /lib/modules/msm_kgsl.ko || exit 1
fi
for attempt in 1 2 3 4 5; do
    if [ -c /dev/kgsl-3d0 ]; then
        setprop sys.aera.gpu.ready true
        exit 0
    fi
    sleep 1
done
setprop sys.aera.gpu.ready false
log -p e -t AERA-GPU "PHY110 KGSL device did not become ready"
exit 1
