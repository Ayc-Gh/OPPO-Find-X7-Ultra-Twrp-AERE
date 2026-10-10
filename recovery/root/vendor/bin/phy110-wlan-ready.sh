#!/system/bin/sh
[ "$(getprop ro.recovery.phy110.supported)" = "1" ] || exit 1
attempt=0
while [ "$attempt" -lt 90 ]; do
    if [ -e /sys/class/net/wlan0 ]; then
        setprop wifi.driver.ready true
        exit 0
    fi
    attempt=$((attempt + 1))
    sleep 1
done
setprop wifi.driver.ready false
printf 'E:PHY110 Wi-Fi interface did not appear within 90 seconds\n' >> /tmp/recovery.log
exit 1
