RFM12B_LINUX_VERSION = master
RFM12B_LINUX_SITE = https://github.com/gkaindl/rfm12b-linux.git
RFM12B_LINUX_SITE_METHOD = git
RFM12B_LINUX_INSTALL_TARGET = YES
RFM12B_LINUX_NAME = RFM12B_LINUX

RFM12B_LINUX_DEPENDENCIES = linux

define RFM12B_LINUX_BUILD_CMDS
    #make sure that obj-y += RFM12B_LINUX/ is only in the build makefile once
    sed -i '/obj-y += RFM12B_LINUX/d' $(BUILD_DIR)/linux-$(LINUX_VERSION)/drivers/Makefile
    echo "obj-y += RFM12B_LINUX/" >> $(BUILD_DIR)/linux-$(LINUX_VERSION)/drivers/Makefile
    rm -rf $(BUILD_DIR)/linux-$(LINUX_VERSION)/drivers/RFM12B_LINUX
    cp -r $(@D)/ $(BUILD_DIR)/linux-$(LINUX_VERSION)/drivers/RFM12B_LINUX
    echo "obj-y += rfm12b.o" > $(BUILD_DIR)/linux-$(LINUX_VERSION)/drivers/RFM12B_LINUX/Makefile
endef

define RFM12B_LINUX_INSTALL_STAGING_CMDS
endef


define RFM12B_LINUX_INSTALL_TARGET_CMDS
endef

define RFM12B_LINUX_DEVICES
endef

define RFM12B_LINUX_PERMISSIONS
endef

define RFM12B_LINUX_USERS
endef

$(eval $(kernel-module))
$(eval $(generic-package))
