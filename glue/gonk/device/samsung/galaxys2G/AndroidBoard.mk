LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

ALL_PREBUILT += $(INSTALLED_KERNEL_TARGET)

# files that live under /...
file := $(TARGET_ROOT_OUT)/init.rc
$(file) : $(LOCAL_PATH)/rootdir/init.rc | $(ACP)
	$(transform-prebuilt-to-target)

ALL_PREBUILT += $(file)
$(INSTALLED_RAMDISK_TARGET): $(file)

file := $(TARGET_ROOT_OUT)/init.t1.rc
$(file) : $(LOCAL_PATH)/rootdir/init.t1.rc | $(ACP)
	$(transform-prebuilt-to-target)
ALL_PREBUILT += $(file)
$(INSTALLED_RAMDISK_TARGET): $(file)

file := $(TARGET_ROOT_OUT)/ueventd.rc
$(file) : $(LOCAL_PATH)/rootdir/ueventd.rc | $(ACP)
	$(transform-prebuilt-to-target)
ALL_PREBUILT += $(file)
$(INSTALLED_RAMDISK_TARGET): $(file)

file := $(TARGET_ROOT_OUT)/ueventd.t1.rc
$(file) : $(LOCAL_PATH)/rootdir/ueventd.t1.rc | $(ACP)
	$(transform-prebuilt-to-target)
ALL_PREBUILT += $(file)
$(INSTALLED_RAMDISK_TARGET): $(file)

# kernel stuff...

ifeq ($(KERNEL_DEFCONFIG),)
    # TODO:  Use ../../config/msm7627a_sku1-perf_defconfig
    KERNEL_DEFCONFIG := $(LOCAL_PATH)/kernel-galaxy-s2-i9100g_defconfig
endif

# Kernel tree doesn't live in the standard Android kernel/ location, so some
# path gymnastics are needed:
KERNELTREE_DIR=../../boot/kernel-android-galaxy-s2-i9100g
KERNELTREE_DIR_REV=../../glue/gonk
include $(LOCAL_PATH)/AndroidKernel.mk

file := $(LOCAL_PATH)/kernel
ALL_PREBUILT += $(file)
$(file) : $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

# include the non-open-source counterpart to this file
-include vendor/samsung/galaxys2i9100g/AndroidBoardVendor.mk
