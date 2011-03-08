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
# crespo. It lists all the overlays, files, modules and properties
# that are specific to this hardware: i.e. those are device-specific
# drivers, configuration files, settings, etc...

# Note that crespo is not a fully open device. Some of the drivers
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
	device/samsung/galaxys/vold.fstab:system/etc/vold.fstab \
	device/samsung/galaxys/egl.cfg:system/lib/egl/egl.cfg

# Init files
PRODUCT_COPY_FILES += \
	device/samsung/galaxys/init.smdkc110.rc:root/init.smdkc110.rc \
        device/samsung/galaxys/init.rc:root/init.rc \
        device/samsung/galaxys/init.rc:root/preinit.rc \
        device/samsung/galaxys/lpm.rc:root/lpm.rc \
        device/samsung/galaxys/fota.rc:root/fota.rc \
        device/samsung/galaxys/redbend_ua:root/sbin/redbend_ua

# Recovery Files
PRODUCT_COPY_FILES += \
	device/samsung/galaxys/init.smdkc110.rc:recovery/root/init.smdkc110.rc \
        device/samsung/galaxys/recovery.rc:recovery/root/recovery.rc

# Prebuilt kl keymaps
PRODUCT_COPY_FILES += \
	device/samsung/galaxys/s3c-keypad.kl:system/usr/keylayout/s3c-keypad.kl \
	device/samsung/galaxys/melfas-touchkey.kl:system/usr/keylayout/melfas-touchkey.kl \
	device/samsung/galaxys/sec_jack.kl:system/usr/keylayout/sec_jack.kl

# Generated kcm keymaps
PRODUCT_PACKAGES := \
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
	libSEC_OMX_Core \
	libOMX.SEC.AVC.Decoder \
	libOMX.SEC.M4V.Decoder \
	libOMX.SEC.M4V.Encoder \
	libOMX.SEC.AVC.Encoder

# Misc other modules
PRODUCT_PACKAGES += \
	lights.s5pc110 \
	overlay.s5pc110 \
	sensors.aries

# render script and LiveWallpapers apps
PRODUCT_PACKAGES += \
        librs_jni \
        LiveWallpapers \
        LiveWallpapersPicker

# fm radio app
PRODUCT_PACKAGES += \
        FM

# Libs
PRODUCT_PACKAGES += \
	libcamera \
	libstagefrighthw

# Input device calibration files
PRODUCT_COPY_FILES += \
	device/samsung/galaxys/mxt224_ts_input.idc:system/usr/idc/mxt224_ts_input.idc

# apns config file
PRODUCT_COPY_FILES += \
        device/samsung/galaxys/apns-conf.xml:system/etc/apns-conf.xml

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml


# The OpenGL ES API level that is natively supported by this device.
# This is a 16.16 fixed point number
PRODUCT_PROPERTY_OVERRIDES := \
    ro.opengles.version=131072

# These are the hardware-specific settings that are stored in system properties.
# Note that the only such settings should be the ones that are too low-level to
# be reachable from resources or other mechanisms.
PRODUCT_PROPERTY_OVERRIDES += \
       ro.sf.lcd_density=240 \
       rild.libpath=/system/lib/libsec-ril.so \
       rild.libargs=-d /dev/ttyS0 \
       wifi.interface=eth0 \
       wifi.supplicant_scan_interval=15 \
       ro.wifi.channels=13 \
       ro.url.safetylegal= \
       dalvik.vm.heapsize=32m

# enable Google-specific location features,
# like NetworkLocationProvider and LocationCollector
PRODUCT_PROPERTY_OVERRIDES += \
       ro.com.google.locationfeatures=1 \
       ro.com.google.networklocation=1

# For GPS
PRODUCT_PROPERTY_OVERRIDES += \
    ro.gps.soket = /data/gpspipe

# For FM-Radio
PRODUCT_PROPERTY_OVERRIDES += \
    fmradio.device = fmradio

# For RIL
PRODUCT_PROPERTY_OVERRIDES += \
    phone.ril.classname = com.android.internal.telephony.SamsungRIL

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

#PRODUCT_COPY_FILES += \
#	device/samsung/galaxys/bcm4329.ko:system/modules/bcm4329.ko

#ifeq ($(TARGET_PREBUILT_KERNEL),)
#LOCAL_KERNEL := device/samsung/galaxys/kernel
#else
#LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
#endif

#PRODUCT_COPY_FILES += \
#    $(LOCAL_KERNEL):kernel

# See comment at the top of this file. This is where the other
# half of the device-specific product definition file takes care
# of the aspects that require proprietary drivers that aren't
# commonly available
$(call inherit-product-if-exists, vendor/samsung/galaxys/device-vendor.mk)
