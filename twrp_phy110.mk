#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oppo/phy110

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

## Device identifier
PRODUCT_DEVICE  := phy110
PRODUCT_NAME    := twrp_phy110
PRODUCT_BRAND   := OPPO

# Theme
AERA_STATUS_ICONS_ALIGN   := center

PRODUCT_MODEL := PHY110
PRODUCT_MANUFACTURER := OPPO
