#############################################################
#
# unifi-controller
#
##############################################################

UNIFI_CONTROLLER_VERSION = 5.6.30
UNIFI_CONTROLLER_SOURCE = unifi_sysvinit_all.deb
UNIFI_CONTROLLER_SITE = http://dl.ubnt.com/unifi/$(UNIFI_CONTROLLER_VERSION)
# UNIFI_CONTROLLER_DEPENDECIES = oracle-java
UNIFI_CONTROLLER_LICENSE = GPL
# LIBFOO_LICENSE_FILES = 

define UNIFI_CONTROLLER_EXTRACT_CMDS
	cp $(DL_DIR)/$(UNIFI_CONTROLLER_SOURCE) $(@D)
	cd $(@D); ar -xf $(UNIFI_CONTROLLER_SOURCE)
	tar -xf $(@D)/data.tar.xz -C $(@D)
	rm $(@D)/$(UNIFI_CONTROLLER_SOURCE)
	rm $(@D)/data.tar.xz
	rm $(@D)/control.tar.gz
	rm $(@D)/debian-binary
endef

define UNIFI_CONTROLLER_INSTALL_TARGET_CMDS
	rsync -a $(@D)/etc/ $(TARGET_DIR)/etc/
	rsync -a \
		--exclude share/ \
		--exclude lib/unifi/lib/native/Linux/x86_64/ \
		--exclude lib/unifi/lib/native/Mac/ \
		--exclude lib/unifi/lib/native/Windows/ \
		$(@D)/usr/ $(TARGET_DIR)/usr/
endef

$(eval $(generic-package))
