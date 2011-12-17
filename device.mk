# Copyright (C) 2010 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# This file is the device-specific product definition file for
# galaxys. It lists all the overlays, files, modules and properties
# that are specific to this hardware: i.e. those are device-specific
# drivers, configuration files, settings, etc...

# Note that galaxies is not a fully open device. Some of the drivers
# aren't publicly available in all circumstances, which means that some
# of the hardware capabilities aren't present in builds where those
# drivers aren't available. Such cases are handled by having this file
# separated into two halves: this half here contains the parts that
# are available to everyone, while another half in the vendor/ hierarchy
# augments that set with the parts that are only relevant when all the
# associated drivers are available. Aspects that are irrelevant but
# harmless in no-driver builds should be kept here for simplicity and
# transparency. There are two variants of the half that deals with
# the unavailable drivers: one is directly checked into the unreleased
# vendor tree and is used by engineers who have access to it. The other
# is generated by setup-makefile.sh in the same directory as this files,
# and is used by people who have access to binary versions of the drivers
# but not to the original vendor tree. Be sure to update both.


# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS := device/samsung/galaxys/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES := \
    device/samsung/galaxys/asound.conf:system/etc/asound.conf \
    device/samsung/galaxys/vold.fstab:system/etc/vold.fstab \
    device/samsung/galaxys/egl.cfg:system/lib/egl/egl.cfg

# Init files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys/init.aries.usb.rc:root/init.aries.usb.rc \
    device/samsung/galaxys/ueventd.aries.rc:root/ueventd.aries.rc \
    device/samsung/galaxys/recovery.rc:root/recovery.rc \
    device/samsung/galaxys/lpm.rc:root/lpm.rc \
    device/samsung/galaxys/fota.rc:root/fota.rc \
    device/samsung/galaxys/redbend_ua:root/sbin/redbend_ua

ifeq ($(DEVICE_BOOTS_FROM_SDCARD),true)
PRODUCT_COPY_FILES += \
    device/samsung/galaxys/sdboot.init.aries.rc:root/init.aries.rc
else
PRODUCT_COPY_FILES += \
    device/samsung/galaxys/init.aries.rc:root/init.aries.rc
endif

# Recovery images and keys
PRODUCT_COPY_FILES += \
    device/samsung/galaxys/recovery.fstab:root/system/etc/recovery.fstab \
    device/samsung/galaxys/keys:root/res/keys \
    bootable/recovery/res/images/icon_error.png:root/res/images/icon_error.png \
    bootable/recovery/res/images/icon_installing.png:root/res/images/icon_installing.png \
    bootable/recovery/res/images/indeterminate01.png:root/res/images/indeterminate01.png \
    bootable/recovery/res/images/indeterminate02.png:root/res/images/indeterminate02.png \
    bootable/recovery/res/images/indeterminate03.png:root/res/images/indeterminate03.png \
    bootable/recovery/res/images/indeterminate04.png:root/res/images/indeterminate04.png \
    bootable/recovery/res/images/indeterminate05.png:root/res/images/indeterminate05.png \
    bootable/recovery/res/images/indeterminate06.png:root/res/images/indeterminate06.png \
    bootable/recovery/res/images/progress_empty.png:root/res/images/progress_empty.png \
    bootable/recovery/res/images/progress_fill.png:root/res/images/progress_fill.png

# Prebuilt kl keymaps
PRODUCT_COPY_FILES += \
    device/samsung/galaxys/cypress-touchkey.kl:system/usr/keylayout/cypress-touchkey.kl \
    device/samsung/galaxys/sec_jack.kl:system/usr/keylayout/sec_jack.kl \
    device/samsung/galaxys/aries-keypad.kl:system/usr/keylayout/aries-keypad.kl \
    device/samsung/galaxys/s3c-keypad.kl:system/usr/keylayout/s3c-keypad.kl

# Generated kcm keymaps
PRODUCT_PACKAGES := \
    cypress-touchkey.kcm \
    s3c-keypad.kcm

# Filesystem management tools
PRODUCT_PACKAGES += \
    make_ext4fs \
    setup_fs

# These are the OpenMAX IL configuration files
PRODUCT_COPY_FILES += \
    device/samsung/galaxys/sec_mm/sec_omx/sec_omx_core/secomxregistry:system/etc/secomxregistry \
    device/samsung/galaxys/media_profiles.xml:system/etc/media_profiles.xml

# These are the OpenMAX IL modules
PRODUCT_PACKAGES += \
    libSEC_OMX_Core.aries \
    libOMX.SEC.AVC.Decoder.aries \
    libOMX.SEC.M4V.Decoder.aries \
    libOMX.SEC.M4V.Encoder.aries \
    libOMX.SEC.AVC.Encoder.aries

# Misc other modules
PRODUCT_PACKAGES += \
    lights.aries \
    overlay.aries \
    hwcomposer.aries \
    sensors.aries \
    audio.primary.aries \
    audio_policy.aries \
    camera.aries.so

# fmradio app
#PRODUCT_PACKAGES += \
#   FM

# Libs
PRODUCT_PACKAGES += \
    libstagefrighthw

# apns config file
PRODUCT_COPY_FILES += \
    development/data/etc/apns-conf.xml:system/etc/apns-conf.xml

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES := \
    ro.opengles.version=131072

# These are the hardware-specific settings that are stored in system properties.
# Note that the only such settings should be the ones that are too low-level to
# be reachable from resources or other mechanisms.
PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=20 \
    ro.telephony.ril_class=samsung \
    mobiledata.interfaces=pdp0,eth0,gprs,ppp0 \
    dalvik.vm.heapsize=32m

# enable Google-specific location features,
# like NetworkLocationProvider and LocationCollector
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.locationfeatures=1 \
    ro.com.google.networklocation=1

# Extended JNI checks
# The extended JNI checks will cause the system to run more slowly, but they can spot a variety of nasty bugs 
# before they have a chance to cause problems.
# Default=true for development builds, set by android buildsystem.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.kernel.android.checkjni=0 \
    dalvik.vm.checkjni=false

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# Screen density is actually considered a locale (since it is taken into account
# the the build-time selection of resources). The product definitions including
# this file must pay attention to the fact that the first entry in the final
# PRODUCT_LOCALES expansion must not be a density.
PRODUCT_LOCALES := hdpi

# kernel modules
PRODUCT_COPY_FILES += $(foreach module,\
    $(wildcard device/samsung/galaxys/*.ko),\
    $(module):system/lib/modules/$(notdir $(module)))

ifeq ($(TARGET_PREBUILT_KERNEL),)
    LOCAL_KERNEL := device/samsung/galaxys/kernel
else
    LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# include wifi firmware
$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4329/device-bcm.mk)

# See comment at the top of this file. This is where the other
# half of the device-specific product definition file takes care
# of the aspects that require proprietary drivers that aren't
# commonly available
$(call inherit-product-if-exists, vendor/samsung/galaxys/galaxys-vendor.mk)
