#############################################################
#
# freepbx
#
##############################################################
FREEPBX_VERSION = 13.0
FREEPBX_SOURCE = freepbx-$(FREEPBX_VERSION)-latest.tgz
FREEPBX_SITE = http://mirror.freepbx.org/modules/packages/freepbx
FREEPBX_DIR = $(BUILD_DIR)/freepbx-$(ASTERISK_VERSION)
FREEPBX_DEPENDENCIES = asterisk php sqlite host-sqlite

# define FREEPBX_EXTRACT_CMDS
# # lists the actions to be performed to extract the package.
# # This is generally not needed as tarballs are automatically handled by Buildroot.
# # However, if the package uses a non-standard archive format, such as a ZIP or RAR file,
# # or has a tarball with a non-standard organization, this variable allows to override
# # the package infrastructure default behavior.
# # $(WGET) -P $(DL_DIR) $(FREEPBX_SITE)/$(FREEPBX_SOURCE); \
# # zcat $(DL_DIR)/$(FREEPBX_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
#
# endef

define FREEPBX_CONFIGURE_CMDS
# lists the actions to be performed to configure the package before its compilation.
# asterisk-clean
endef

define FREEPBX_BUILD_CMDS
# lists the actions to be performed to compile the package.
endef

define HOST_FREEPBX_INSTALL_CMDS
# lists the actions to be performed to install the package,
# when the package is a host package. The package must install
# its files to the directory given by $(HOST_DIR).
# All files, including development files such as headers should be installed,
# since other packages might be compiled on top of this package.
endef

define FREEPBX_INSTALL_TARGET_CMDS
# lists the actions to be performed to install the package
# to the target directory, when the package is a target package.
# The package must install its files to the directory given by $(TARGET_DIR).
# Only the files required for execution of the package have to be installed.
# Header files, static libraries and documentation will be removed again when
# the target filesystem is finalized.
mkdir -p $(TARGET_DIR)/var/www/html
mkdir -p $(TARGET_DIR)/etc/asterisk
mkdir -p $(TARGET_DIR)/usr/lib/asterisk/modules
mkdir -p $(TARGET_DIR)/var/lib/asterisk/agi-bin
mkdir -p $(TARGET_DIR)/var/lib/asterisk/bin
mkdir -p $(TARGET_DIR)/var/lib/asterisk/playback
mkdir -p $(TARGET_DIR)/var/www/cgi-bin
mkdir -p $(TARGET_DIR)/var/spool/asterisk
mkdir -p $(TARGET_DIR)/var/run/asterisk
mkdir -p $(TARGET_DIR)/var/log/asterisk
mkdir -p $(TARGET_DIR)/usr/sbin
mkdir -p $(TARGET_DIR)/usr/src
cp -R $(FREEPBX_DIR)/* $(TARGET_DIR)/usr/src
# 
# mkdir -p $(TARGET_DIR)/var/lib/asterisk; \
# cat $(FREEPBX_DIR)/installlib/SQL/cdr.sql | $(HOST_DIR)/usr/bin/sqlite3 $(TARGET_DIR)/var/lib/asterisk/freepbx.db; \
# cat $(FREEPBX_DIR)/installlib/SQL/asterisk.sql | $(HOST_DIR)/usr/bin/sqlite3 $(TARGET_DIR)/var/lib/asterisk/freepbx.db

cd $(TARGET_DIR)/usr/src && ./install -n \
	--dbengine=sqlite3 \
	--dbuser=root \
	--user=root \
	--group=root \
	--webroot=$(TARGET_DIR)/var/www/html \
	--astetcdir=$(TARGET_DIR)/etc/asterisk \
	--astmoddir=$(TARGET_DIR)/usr/lib/asterisk/modules \
	--astvarlibdir=$(TARGET_DIR)/var/lib/asterisk \
	--astagidir=$(TARGET_DIR)/var/lib/asterisk/agi-bin \
	--astspooldir=$(TARGET_DIR)/var/spool/asterisk \
	--astrundir=$(TARGET_DIR)/var/run/asterisk \
	--astlogdir=$(TARGET_DIR)/var/log/asterisk \
	--ampbin=$(TARGET_DIR)/var/lib/asterisk/bin \
	--ampsbin=$(TARGET_DIR)/usr/sbin \
	--ampcgibin=$(TARGET_DIR)/var/www/cgi-bin \
	--ampplayback=$(TARGET_DIR)/var/lib/asterisk/playback
endef

define FREEPBX_INSTALL_STAGING_CMDS
# lists the actions to be performed to install the package to the staging directory,
# when the package is a target package. The package must install its files to the directory
# given by $(STAGING_DIR). All development files should be installed, since they might
# be needed to compile other packages.
endef

define FREEPBX_INSTALL_IMAGES_CMDS
# lists the actions to be performed to install the package to the images directory,
# when the package is a target package. The package must install its files to the
# directory given by $(BINARIES_DIR). Only files that are binary images (aka images)
# that do not belong in the TARGET_DIR but are necessary for booting the board should be placed here.
# For example, a package should utilize this step if it has binaries which would be similar
# to the kernel image, bootloader or root filesystem images.
endef

define FREEPBX_INSTALL_INIT_SYSV
endef

define FREEPBX_INSTALL_INIT_SYSTEMD
# list the actions to install init scripts either for the systemV-like init systems (busybox, sysvinit, etc.)
# or for the systemd units. These commands will be run only when the relevant init system is installed
# (i.e. if systemd is selected as the init system in the configuration, only FREEPBX_INSTALL_INIT_SYSTEMD will be run).
endef

define FREEPBX_HELP_CMDS
endef


#############################################################
#
# Toplevel Makefile options
#
#############################################################
$(eval $(generic-package))
