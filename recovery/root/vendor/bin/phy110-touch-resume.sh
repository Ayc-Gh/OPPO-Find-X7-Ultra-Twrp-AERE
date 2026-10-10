#!/system/bin/sh
[ "$(getprop ro.recovery.phy110.supported)" = "1" ] || exit 1
# SPI bus numbering varies with probe order. Select only this controller on
# the PHY110 touchscreen bus, never an unrelated device's power_state.
attempt=0
while [ "$attempt" -lt 20 ]; do
    node=
    count=0
    for candidate in /sys/devices/platform/soc/ac0000.qcom,qupv3_1_geni_se/a90000.spi/spi_master/spi*/spi*.0/synaptics_tcm_hbp.0/sysfs/power_state; do
        [ -w "$candidate" ] || continue
        node="$candidate"
        count=$((count + 1))
    done
    [ "$count" -gt 1 ] && exit 1
    if [ "$count" -eq 1 ]; then
        printf 'resume\n' > "$node" || exit 1
        exit 0
    fi
    attempt=$((attempt + 1))
    sleep 1
done
exit 1
