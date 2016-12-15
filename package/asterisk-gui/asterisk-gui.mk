#############################################################
#
# asterisk-gui
#
##############################################################
ASTERISK_GUI_SVN_VER := 5217
ASTERISK_GUI_VERSION := $(ASTERISK_GUI_SVN_VER)
ASTERISK_GUI_SOURCE := asterisk-gui-$(ASTERISK_GUI_VERSION).tar.gz
ASTERISK_GUI_SITE := http://svn.digium.com/svn/asterisk-gui/branches/2.0
ASTERISK_GUI_SITE_METHOD = svn
ASTERISK_GUI_DIR := $(BUILD_DIR)/asterisk-gui-$(ASTERISK_GUI_VERSION)
ASTERISK_GUI_BINARY := tools/ztscan
ASTERISK_GUI_TARGET_BINARY := stat/var/lib/asterisk/static-http/config/index.html
ASTERISK_GUI_COMPILE := makeopts
ASTERISK_GUI_PREREQS :=
ASTERISK_GUI_CONFIG :=

ifeq ($(strip $(BR2_PACKAGE_DAHDI_LINUX)),y)
ASTERISK_GUI_PREREQS += dahdi-tools
ASTERISK_GUI_CONFIG += --with-dahdi=$(STAGING_DIR)/usr
endif

define ASTERISK_GUI_CONFIGURE_CMDS
# lists the actions to be performed to configure the package before its compilation.
cd $(ASTERISK_GUI_DIR); rm -rf config.cache; \
$(TARGET_CONFIGURE_OPTS) CC_FOR_BUILD=$(HOSTCC) \
CFLAGS='$(TARGET_CFLAGS)' \
./configure \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--prefix=/ \
	--exec-prefix=/usr \
	--libdir=/usr/lib \
	--includedir=/usr/include \
	--datadir=/usr/share \
	--sysconfdir=/etc \
	$(ASTERISK_GUI_CONFIG)
endef

define ASTERISK_GUI_BUILD_CMDS
# lists the actions to be performed to compile the package.
$(MAKE) -C $(ASTERISK_GUI_DIR) \
	HOSTCC=gcc $(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS)" \
	ASTETCDIR=$(TARGET_DIR)/stat/etc/asterisk \
	ASTVARLIBDIR=$(TARGET_DIR)/stat/var/lib/asterisk
endef

define HOST_ASTERISK_GUI_INSTALL_CMDS
# lists the actions to be performed to install the package,
# when the package is a host package. The package must install
# its files to the directory given by $(HOST_DIR).
# All files, including development files such as headers should be installed,
# since other packages might be compiled on top of this package.
endef

define ASTERISK_GUI_INSTALL_TARGET_CMDS
# lists the actions to be performed to install the package
# to the target directory, when the package is a target package.
# The package must install its files to the directory given by $(TARGET_DIR).
# Only the files required for execution of the package have to be installed.
# Header files, static libraries and documentation will be removed again when
# the target filesystem is finalized.
$(MAKE1) -C $(ASTERISK_GUI_DIR) \
	HOSTCC=gcc $(TARGET_CONFIGURE_OPTS) \
	CFLAGS="$(TARGET_CFLAGS)" \
	ASTETCDIR=$(TARGET_DIR)/stat/etc/asterisk \
	ASTVARLIBDIR=$(TARGET_DIR)/stat/var/lib/asterisk install
NL=$$'\\\n'; \
$(SED) "/^; Third party application call management/i $${NL}; Modified for use with asterisk-gui on AstLinux$${NL};$${NL}; THIS IS INSECURE! CHANGE THE PASSWORD!!!$${NL};" \
		-e 's/^enabled = no$$/enabled = yes/' \
		-e 's/^;webenabled = yes$$/webenabled = yes/' \
	$(TARGET_DIR)/stat/etc/asterisk/manager.conf; \
$(SED) 's/^;enabled=yes$$/enabled=yes/' \
		-e 's/^;enablestatic=yes$$/enablestatic=yes/' \
		-e 's/^bindaddr=127.0.0.1$$/bindaddr=0.0.0.0/' \
	$(TARGET_DIR)/stat/etc/asterisk/http.conf
ln -snf /var/tmp/asterisk-gui $(TARGET_DIR)/stat/var/lib/asterisk/static-http/config/tmp;
endef

define ASTERISK_GUI_INSTALL_STAGING_CMDS
# lists the actions to be performed to install the package to the staging directory,
# when the package is a target package. The package must install its files to the directory
# given by $(STAGING_DIR). All development files should be installed, since they might
# be needed to compile other packages.

endef

define ASTERISK_GUI_INSTALL_IMAGES_CMDS
# lists the actions to be performed to install the package to the images directory,
# when the package is a target package. The package must install its files to the
# directory given by $(BINARIES_DIR). Only files that are binary images (aka images)
# that do not belong in the TARGET_DIR but are necessary for booting the board should be placed here.
# For example, a package should utilize this step if it has binaries which would be similar
# to the kernel image, bootloader or root filesystem images.
endef

define ASTERISK_GUI_INSTALL_INIT_SYSV
endef

define ASTERISK_GUI_INSTALL_INIT_SYSTEMD
# list the actions to install init scripts either for the systemV-like init systems (busybox, sysvinit, etc.)
# or for the systemd units. These commands will be run only when the relevant init system is installed
# (i.e. if systemd is selected as the init system in the configuration, only ASTERISK_INSTALL_INIT_SYSTEMD will be run).
endef

define ASTERISK_GUI_HELP_CMDS
endef

#############################################################
#
# Toplevel Makefile options
#
#############################################################
$(eval $(generic-package))
