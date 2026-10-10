#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Building with minimal manifest
ALLOW_MISSING_DEPENDENCIES                      := true
BUILD_BROKEN_DUP_RULES                          := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES    := true

BUILD_BROKEN_NINJA_USES_ENV_VARS    += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION      := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults soong-aera_host_defaults

# Architecture
TARGET_ARCH                 := arm64
TARGET_ARCH_VARIANT         := armv8-a
TARGET_CPU_ABI              := arm64-v8a
TARGET_CPU_VARIANT          := kryo

# A/B
AB_OTA_PARTITIONS := \
    boot \
    init_boot \
    vendor_boot \
    dtbo \
    odm \
    product \
    system \
    system_ext \
    system_dlkm \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor \
    vendor_dlkm

# AB partitions for oplus
AB_OTA_PARTITIONS += \
    my_bigball \
    my_carrier \
    my_company \
    my_engineering \
    my_heytap \
    my_manifest \
    my_preload \
    my_product \
    my_region \
    my_stock

# Bootloader
PRODUCT_PLATFORM                := pineapple
TARGET_BOOTLOADER_BOARD_NAME    := pineapple

# Crypto
BOARD_USES_METADATA_PARTITION   := true
AERA_INCLUDE_CRYPTO               := true

# Debug
TARGET_USES_LOGD                := true
AERA_INCLUDE_LOGCAT             := true
TARGET_RECOVERY_DEVICE_MODULES  += debuggerd
TARGET_RECOVERY_DEVICE_MODULES  += strace
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/debuggerd
RECOVERY_BINARY_SOURCE_FILES    += $(TARGET_OUT_EXECUTABLES)/strace

# File systems
TARGET_USERIMAGES_USE_F2FS := true
AERA_USE_DMCTL               := true

# Init
TARGET_INIT_VENDOR_LIB          := //$(DEVICE_PATH):libinit_oppo_phy110
TARGET_RECOVERY_DEVICE_MODULES  += libinit_oppo_phy110

# Kernel
BOARD_KERNEL_IMAGE_NAME     := Image
BOARD_BOOT_HEADER_VERSION   := 4
BOARD_KERNEL_PAGESIZE       := 4096
BOARD_MKBOOTIMG_ARGS        += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS        += --pagesize $(BOARD_KERNEL_PAGESIZE)

BOARD_RAMDISK_USE_LZ4       := true

# Partitions
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED  := true
BOARD_RECOVERYIMAGE_PARTITION_SIZE      := 0x6400000

BOARD_SUPER_PARTITION_SIZE                  := 17716740096
BOARD_SUPER_PARTITION_GROUPS                := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE           := 17712545792
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_dlkm system_ext product vendor vendor_dlkm odm
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST += my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_stock

BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_ODM             := odm
TARGET_COPY_OUT_VENDOR          := vendor

# Platform
TARGET_BOARD_PLATFORM   := sm86xx
QCOM_BOARD_PLATFORMS    += sm86xx

# Recovery
BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE    := true
TARGET_RECOVERY_PIXEL_FORMAT                := RGBX_8888
AERA_INCLUDE_FASTBOOTD                        := true

# Tool
AERA_ENABLE_ALL_PARTITION_TOOLS := true
AERA_INCLUDE_7ZA                := true
AERA_INCLUDE_REPACKTOOLS        := true
AERA_INCLUDE_RESETPROP          := true
AERA_USE_TOOLBOX                := true
AERA_INCLUDE_ZSTD               := true

# TWRP display
AERA_BRIGHTNESS_PATH      := /sys/class/backlight/panel0-backlight/brightness
AERA_DEFAULT_BRIGHTNESS   := 2048
AERA_FRAMERATE            := 120
AERA_MAX_BRIGHTNESS       := 4094
AERA_SCREEN_BLANK_ON_BOOT := true
AERA_THEME                := portrait_hdpi

# TWRP file system
RECOVERY_SDCARD_ON_DATA     := true
TARGET_USES_MKE2FS          := true
AERA_ENABLE_FS_COMPRESSION    := true
AERA_INCLUDE_FUSE_EXFAT       := true
AERA_INCLUDE_FUSE_NTFS        := true
AERA_INCLUDE_NTFS_3G          := true
AERA_NO_EXFAT_FUSE            := true

# Version
PLATFORM_VERSION                := 16
PLATFORM_VERSION_LAST_STABLE    := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH         := 2026-08-01
VENDOR_SECURITY_PATCH           := $(PLATFORM_SECURITY_PATCH)
AERA_DEVICE_VERSION               := PHY110-AERA-20261010

# Verified Boot
BOARD_AVB_ENABLE := true

# Vibrator
AERA_SUPPORT_INPUT_AIDL_HAPTICS := true

# Other TWRP Configurations
TARGET_RECOVERY_QCOM_RTC_FIX            := true
AERA_CUSTOM_CPU_TEMP_PATH                 := "/sys/class/thermal/thermal_zone48/temp"
AERA_EXCLUDE_APEX                         := true
AERA_EXCLUDE_DEFAULT_USB_INIT             := true
AERA_EXTRA_LANGUAGES                      := true
AERA_LOAD_VENDOR_MODULES                  := "adsp_loader_dlkm.ko oplus_hbp_core.ko oplus_bsp_tp_hbp_syna_s3910.ko oplus_chg_v2.ko stm_st54se_gpio.ko nxp-nci.ko"
AERA_LOAD_VENDOR_BOOT_MODULES             := true
AERA_LOAD_VENDOR_MODULES_EXCLUDE_GKI      := true
AERA_NO_SCREEN_BLANK                      := true
AERA_USE_SERIALNO_PROPERTY_FOR_DEVICE_ID  := true

# AERA integration for the observed PHY110 firmware.
BOARD_USES_QCOM_FBE_DECRYPTION := true
AERA_INCLUDE_CRYPTO_FBE := true
AERA_INCLUDE_FBE_METADATA_DECRYPT := true
AERA_USE_FSCRYPT_POLICY := 2
AERA_SKIP_ADDITIONAL_FSTAB := true
AERA_UI_ADAPTIVE_RESOLUTION := true
AERA_AB_DEVICE_WITH_RECOVERY_PARTITION := 1
AERA_VIRTUAL_AB_DEVICE := 1
AERA_DEFAULT_LANGUAGE := zh_CN
AERA_SCREEN_H := 2376
AERA_STATUS_H := 120
AERA_HIDE_NOTCH := 1
AERA_INCLUDE_LIBRESETPROP := true
AERA_INCLUDE_LPDUMP := true
AERA_INCLUDE_LPTOOLS := true
AERA_MAINTAINER := Local_PHY110_Build
AERA_ENABLE_WLAN := 1
AERA_POST_DECRYPT_MODULES := "cnss_prealloc.ko cnss_nl.ko wlan_firmware_service.ko cnss_plat_ipc_qmi_svc.ko cnss_utils.ko cnss2.ko rfkill.ko cfg80211.ko gsim.ko rmnet_mem.ko ipam.ko qca_cld3_kiwi_v2.ko"

# Explicit dependencies missing from the upstream recovery relink list.
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libdebuggerd_client.so
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libfs_mgr_binder.so
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libprocinfo.so
RECOVERY_LIBRARY_SOURCE_FILES += $(TARGET_OUT_SHARED_LIBRARIES)/libsnapshot.so
