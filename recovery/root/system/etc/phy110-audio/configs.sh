#!/system/bin/sh
set -e
mkdir -p /vendor/etc/audio /vendor/etc/acdbdata /vendor/odm/etc/acdbdata /vendor/odm/firmware
grep -q '^oplus_audio_tfa98xx_v6 ' /proc/modules && { echo 'Refusing configuration changes after speaker driver load'; exit 1; }
for target in /vendor/firmware/tfa98xx.cnt /vendor/odm/firmware/tfa98xx.cnt /odm/firmware/tfa98xx.cnt; do
 [ -f "$target" ] || touch "$target"
 grep -q " $target " /proc/mounts || mount -o bind /tmp/phy110-audio-odm/firmware/tfa98xx.cnt "$target"
 mount -o remount,bind,ro "$target"
done
for pair in 'audio audio' 'acdbdata acdbdata'; do
  set -- $pair
  grep -q " /vendor/etc/$2 " /proc/mounts || mount -o bind "/tmp/phy110-audio-vendor/etc/$1" "/vendor/etc/$2"
  mount -o remount,bind,ro "/vendor/etc/$2"
done
grep -q ' /vendor/odm/etc/acdbdata ' /proc/mounts || mount -o bind /tmp/phy110-audio-odm/etc/acdbdata /vendor/odm/etc/acdbdata
mount -o remount,bind,ro /vendor/odm/etc/acdbdata
for pair in 'mixer_paths.xml mixer_paths_pineapple_mtp.xml' 'resourcemanager.xml resourcemanager_pineapple_mtp.xml' 'usecaseKvManager.xml usecaseKvManager.xml' 'plugin_config.xml plugin_manager.xml'; do
 set -- $pair
 [ -f "/tmp/phy110-audio-odm/etc/$1" ] || continue
 [ -f "/vendor/etc/$2" ] || touch "/vendor/etc/$2"
 mount -o bind "/tmp/phy110-audio-odm/etc/$1" "/vendor/etc/$2"
 mount -o remount,bind,ro "/vendor/etc/$2"
done
for config in card-defs.xml mem_logger_config.xml; do
 [ -f "/tmp/phy110-audio-vendor/etc/$config" ] || continue
 [ -f "/vendor/etc/$config" ] || touch "/vendor/etc/$config"
 mount -o bind "/tmp/phy110-audio-vendor/etc/$config" "/vendor/etc/$config"
 mount -o remount,bind,ro "/vendor/etc/$config"
done
# Configuration must be exposed before the initial codec module load.
# Never unbind a live TFA codec: hot removal hung this PHY110 kernel.
