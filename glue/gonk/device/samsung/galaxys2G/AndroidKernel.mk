#Android makefile to build kernel as a part of Android Build

ifeq ($(TARGET_PREBUILT_KERNEL),)

TARGET_PREBUILT_INT_KERNEL := $(KERNELTREE_DIR)/arch/arm/boot/zImage
KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
KERNEL_MODULES_INSTALL := system
KERNEL_MODULES_OUT := $(TARGET_ROOT_OUT)/lib/modules

TARGET_PREBUILT_KERNEL := $(TARGET_PREBUILT_INT_KERNEL)


define mv-modules
ko=`find $(KERNELTREE_DIR) -type f -name *.ko`;\
for i in $$ko; do cp -f $$i $(KERNEL_MODULES_OUT)/; done;
endef


$(KERNEL_CONFIG):
	$(MAKE) -C $(KERNELTREE_DIR) ARCH=arm CROSS_COMPILE=arm-eabi- mrproper
	$(MAKE) -C $(KERNELTREE_DIR) ARCH=arm CROSS_COMPILE=arm-eabi- ../../../../../glue/gonk/$(KERNEL_DEFCONFIG)

$(TARGET_PREBUILT_INT_KERNEL): $(KERNEL_CONFIG) $(KERNEL_HEADERS_INSTALL)
	$(MAKE) -C $(KERNELTREE_DIR) ARCH=arm CROSS_COMPILE=arm-eabi-
	$(MAKE) -C $(KERNELTREE_DIR) ARCH=arm CROSS_COMPILE=arm-eabi- modules
	@mkdir -p $(KERNEL_MODULES_OUT)
	$(mv-modules)

$(KERNEL_HEADERS_INSTALL): $(KERNEL_CONFIG)
	$(MAKE) -C $(KERNELTREE_DIR) ARCH=arm CROSS_COMPILE=arm-eabi- headers_install
endif
