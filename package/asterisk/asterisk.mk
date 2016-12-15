#############################################################
#
# asterisk
#
##############################################################
ifeq ($(BR2_PACKAGE_ASTERISK_v1_8),y)
ASTERISK_VERSION := 1.8.32.3
else
ifeq ($(BR2_PACKAGE_ASTERISK_v11),y)
ASTERISK_VERSION := 11.23.0
else
ASTERISK_VERSION := 13.10.0
endif
endif
ASTERISK_SOURCE := asterisk-$(ASTERISK_VERSION).tar.gz
ASTERISK_SITE := http://downloads.asterisk.org/pub/telephony/asterisk/releases
ASTERISK_DIR := $(BUILD_DIR)/asterisk-$(ASTERISK_VERSION)
ASTERISK_BINARY := main/asterisk
ASTERISK_TARGET_BINARY := usr/sbin/asterisk
ASTERISK_EXTRAS :=
ASTERISK_CONFIGURE_ENV :=
ASTERISK_CONFIGURE_ARGS :=
ASTERISK_MODULE_DIR := usr/lib/asterisk/modules
ASTERISK_DEPENDENCIES += host-doxygen

# $(call ndots start,end,dotted-string)
dot:=.
empty:=
space:=$(empty) $(empty)
ndots = $(subst $(space),$(dot),$(wordlist $(1),$(2),$(subst $(dot),$(space),$3)))
##
ASTERISK_VERSION_SINGLE := $(call ndots,1,1,$(ASTERISK_VERSION))
ASTERISK_VERSION_TUPLE := $(call ndots,1,2,$(ASTERISK_VERSION))
ASTERISK_VERSION_TRIPLE := $(call ndots,1,3,$(ASTERISK_VERSION))

ASTERISK_GLOBAL_MAKEOPTS := $(BASE_DIR)/../project/astlinux/asterisk.makeopts-$(ASTERISK_VERSION_SINGLE)

ASTERISK_CONFIGURE_ENV += USE_GETIFADDRS=yes

ASTERISK_LIBS:= -lpthread -lresolv

ifeq ($(strip $(BR2_PACKAGE_OPENSSL)),y)
ASTERISK_LIBS += -lssl
endif

ifeq ($(strip $(BR2_PACKAGE_ZLIB)),y)
ASTERISK_LIBS += -lz
endif

ASTERISK_CONFIGURE_ARGS+= --without-sdl

ifeq ($(strip $(BR2_PACKAGE_LIBXML2)),y)
ASTERISK_EXTRAS+= libxml2
ASTERISK_CONFIGURE_ARGS+= --with-libxml2
ASTERISK_CONFIGURE_ENV+= CONFIG_LIBXML2="$(STAGING_DIR)/usr/bin/xml2-config"
else
ASTERISK_CONFIGURE_ARGS+= --disable-xmldoc
endif

ASTERISK_CONFIGURE_ARGS+= --without-ldap --without-lua

ifeq ($(strip $(BR2_PACKAGE_IKSEMEL)),y)
ASTERISK_EXTRAS+= iksemel
ASTERISK_CONFIGURE_ARGS+= --with-iksemel="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_LIBPRI)),y)
ASTERISK_EXTRAS+= libpri
ASTERISK_CONFIGURE_ARGS+= --with-pri="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_LIBSRTP)),y)
ASTERISK_EXTRAS+= libsrtp
ASTERISK_CONFIGURE_ARGS+= --with-srtp="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_UW_IMAP)),y)
ASTERISK_EXTRAS+= uw-imap
ASTERISK_CONFIGURE_ARGS+= --with-imap="$(BUILD_DIR)/uw-imap-2007f"
endif

ifeq ($(strip $(BR2_PACKAGE_NETSNMP)),y)
ASTERISK_EXTRAS+= netsnmp
ASTERISK_CONFIGURE_ARGS+= --with-netsnmp
ASTERISK_CONFIGURE_ENV+= CONFIG_NETSNMP="$(STAGING_DIR)/usr/bin/net-snmp-config"
else
ASTERISK_CONFIGURE_ARGS+= --without-netsnmp
endif

ifeq ($(strip $(BR2_PACKAGE_MYSQL_CLIENT)),y)
ASTERISK_EXTRAS+=mysql_client
ASTERISK_CONFIGURE_ARGS+= \
			--with-mysqlclient
ASTERISK_CONFIGURE_ENV+= \
			CONFIG_MYSQLCLIENT="$(STAGING_DIR)/usr/bin/mysql_config"
endif

ifeq ($(strip $(BR2_PACKAGE_UNIXODBC)),y)
ASTERISK_EXTRAS+= unixodbc
ASTERISK_CONFIGURE_ARGS+= --with-unixodbc="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_ALSA_LIB)),y)
ASTERISK_EXTRAS+= alsa-lib
ASTERISK_CONFIGURE_ARGS+= --with-asound="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_SPANDSP)),y)
ASTERISK_EXTRAS+= spandsp
endif

ifeq ($(strip $(BR2_PACKAGE_DAHDI_LINUX)),y)
ASTERISK_EXTRAS+= dahdi-tools
ASTERISK_CONFIGURE_ARGS+= --with-dahdi="$(STAGING_DIR)/usr" --with-tonezone="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_SQLITE)),y)
ASTERISK_EXTRAS+= sqlite
ASTERISK_CONFIGURE_ARGS+= --with-sqlite3="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_CURL)),y)
ASTERISK_EXTRAS+= libcurl
ASTERISK_CONFIGURE_ARGS+= --with-libcurl="$(STAGING_DIR)"
ASTERISK_CONFIGURE_ENV+= LIBCURL="-lcurl -lz -lssl" _libcurl_config="$(STAGING_DIR)/usr/bin/curl-config"
endif

ifeq ($(strip $(BR2_PACKAGE_NEON)),y)
ifeq ($(strip $(BR2_PACKAGE_LIBICAL)),y)
ASTERISK_EXTRAS+=neon libical
ASTERISK_CONFIGURE_ARGS+= --with-neon --with-neon29 --with-ical
ASTERISK_CONFIGURE_ENV+= CONFIG_NEON="$(STAGING_DIR)/usr/bin/neon-config" CONFIG_NEON29="$(STAGING_DIR)/usr/bin/neon-config"
endif
endif

ifneq ($(ASTERISK_VERSION_SINGLE),1)
ifneq ($(ASTERISK_VERSION_SINGLE),11)

ifeq ($(strip $(BR2_PACKAGE_PJSIP)),y)
ASTERISK_EXTRAS+=pjsip
ASTERISK_CONFIGURE_ARGS+= --with-pjproject="$(STAGING_DIR)/usr"
else
ASTERISK_CONFIGURE_ARGS+= --without-pjproject
endif

ifeq ($(strip $(BR2_PACKAGE_JANSSON)),y)
ASTERISK_EXTRAS+=jansson
ASTERISK_CONFIGURE_ARGS+= --with-jansson="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_LIBURIPARSER)),y)
ASTERISK_EXTRAS+=liburiparser
ASTERISK_CONFIGURE_ARGS+= --with-uriparser="$(STAGING_DIR)/usr"
endif

ifeq ($(strip $(BR2_PACKAGE_LIBXSLT)),y)
ASTERISK_EXTRAS+=libxslt
ASTERISK_CONFIGURE_ARGS+= --with-libxslt="$(STAGING_DIR)/usr"
else
ASTERISK_CONFIGURE_ARGS+= --without-libxslt
endif

endif
endif

# define ASTERISK_EXTRACT_CMDS
# # lists the actions to be performed to extract the package.
# # This is generally not needed as tarballs are automatically handled by Buildroot.
# # However, if the package uses a non-standard archive format, such as a ZIP or RAR file,
# # or has a tarball with a non-standard organization, this variable allows to override
# # the package infrastructure default behavior.
# # $(WGET) -P $(DL_DIR) $(ASTERISK_SITE)/$(ASTERISK_SOURCE); \
# # zcat $(DL_DIR)/$(ASTERISK_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
#
# endef

define ASTERISK_CONFIGURE_CMDS
# lists the actions to be performed to configure the package before its compilation.
# asterisk-clean
rm -Rf $(STAGING_DIR)/usr/include/asterisk
rm -Rf $(TARGET_DIR)/stat/etc/asterisk
rm -Rf $(TARGET_DIR)/etc/asterisk
rm -Rf $(TARGET_DIR)/usr/lib/asterisk
rm -Rf $(TARGET_DIR)/stat/var/lib/asterisk
rm -Rf $(TARGET_DIR)/stat/var/spool/asterisk
rm -Rf $(TARGET_DIR)/var/lib/asterisk
rm -Rf $(TARGET_DIR)/var/spool/asterisk
rm -f $(TARGET_DIR)/etc/init.d/asterisk
rm -f $(TARGET_DIR)/usr/sbin/upgrade-asterisk-sounds
rm -f $(TARGET_DIR)/usr/sbin/safe_asterisk
rm -f $(TARGET_DIR)/usr/sbin/asterisk-sip-monitor
rm -f $(TARGET_DIR)/usr/sbin/asterisk-sip-monitor-ctrl
rm -f $(TARGET_DIR)/usr/sbin/ast_tls_cert
rm -f $(TARGET_DIR)/usr/sbin/stereorize
rm -f $(TARGET_DIR)/usr/sbin/streamplayer
rm -rf $(STAGING_DIR)/usr/include/asterisk
rm -Rf $(TARGET_DIR)/stat/var/lib/asterisk
rm -Rf $(TARGET_DIR)/stat/var/spool/asterisk
rm -Rf $(TARGET_DIR)/stat/etc/asterisk
rm -f $(TARGET_DIR)/usr/share/snmp/mibs/ASTERISK-MIB.txt
rm -f $(TARGET_DIR)/usr/share/snmp/mibs/DIGIUM-MIB.txt
$(MAKE) -C $(ASTERISK_DIR) clean
# rm -rf $(BUILD_DIR)/asterisk;
# rm -rf $(BUILD_DIR)/asterisk-$(ASTERISK_VERSION);
# asterisk-sounds-clean
rm -rf $(TARGET_DIR)/stat/var/lib/asterisk/sounds
# asterisk-moh-clean
rm -rf $(TARGET_DIR)/stat/var/lib/asterisk/mohmp3
rm -rf $(TARGET_DIR)/stat/etc/asterisk/musiconhold.conf
# asterisk-dirclean
# rm -rf $(ASTERISK_DIR);
cd $(ASTERISK_DIR); rm -rf config.cache configure
$(HOST_CONFIGURE_OPTS) ./bootstrap.sh
$(TARGET_CONFIGURE_OPTS) \
./configure \
--target=$(GNU_TARGET_NAME) \
--host=$(GNU_TARGET_NAME) \
--build=$(GNU_HOST_NAME) \
--prefix=/usr \
--exec-prefix=/usr \
--datadir=/usr/share \
--sysconfdir=/etc \
--without-pwlib \
--with-ltdl=$(STAGING_DIR)/usr \
$(ASTERISK_CONFIGURE_ARGS) \
$(ASTERISK_CONFIGURE_ENV) \
CFLAGS='$(TARGET_CFLAGS) -pthread -lresolv' \
LDFLAGS='-pthread -lresolv' \
CPPFLAGS='$(TARGET_CFLAGS)' \
LIBS='$(ASTERISK_LIBS) -lresolv'; \
cd $(ASTERISK_DIR)/menuselect; \
$(HOST_CONFIGURE_OPTS) \
./configure; \
$(HOST_MAKE_ENV) LD_RUN_PATH="$(HOST_DIR)/usr/lib" \
$(MAKE) -C $(ASTERISK_DIR)/menuselect menuselect; \
if [ $(strip $(BR2_PACKAGE_ASTERISK_MENUSELECT))=y ]; then \
	$(HOST_MAKE_ENV) LD_RUN_PATH="$(HOST_DIR)/usr/lib" \
	$(MAKE) -C $(ASTERISK_DIR) \
		GLOBAL_MAKEOPTS=$(ASTERISK_GLOBAL_MAKEOPTS) \
		USER_MAKEOPTS= \
		menuselect; \
else \
	$(HOST_MAKE_ENV) LD_RUN_PATH="$(HOST_DIR)/usr/lib" \
	$(MAKE) -C $(ASTERISK_DIR) \
		GLOBAL_MAKEOPTS=$(ASTERISK_GLOBAL_MAKEOPTS) \
		USER_MAKEOPTS= \
		menuselect.makeopts; \
	if [ $(strip $(BR2_PACKAGE_MYSQL_CLIENT))=y ]; then \
		cd $(ASTERISK_DIR); \
		menuselect/menuselect --enable app_mysql --enable cdr_mysql --enable res_config_mysql menuselect.makeopts; \
	fi; \
	if [ $(strip $(BR2_PACKAGE_UW_IMAP))=y ]; then \
		cd $(ASTERISK_DIR); \
		menuselect/menuselect --enable IMAP_STORAGE menuselect.makeopts; \
	fi; \
	if [ $(ASTERISK_VERSION_SINGLE)!=1 ]; then \
		cd $(ASTERISK_DIR); \
		menuselect/menuselect --enable app_meetme --enable app_page menuselect.makeopts; \
	fi; \
	cd $(ASTERISK_DIR); \
	menuselect/menuselect --enable res_pktccops menuselect.makeopts; \
	menuselect/menuselect --disable CORE-SOUNDS-EN-GSM --disable MOH-OPSOUND-WAV menuselect.makeopts; \
fi
endef

define ASTERISK_BUILD_CMDS
# lists the actions to be performed to compile the package.
$(TARGET_MAKE_ENV) \
$(MAKE) -C $(ASTERISK_DIR) \
	GLOBAL_MAKEOPTS=$(ASTERISK_GLOBAL_MAKEOPTS) \
	USER_MAKEOPTS= \
	ASTVARRUNDIR=/var/run/asterisk \
	full
endef

define HOST_ASTERISK_INSTALL_CMDS
# lists the actions to be performed to install the package,
# when the package is a host package. The package must install
# its files to the directory given by $(HOST_DIR).
# All files, including development files such as headers should be installed,
# since other packages might be compiled on top of this package.
endef

define ASTERISK_INSTALL_TARGET_CMDS
# lists the actions to be performed to install the package
# to the target directory, when the package is a target package.
# The package must install its files to the directory given by $(TARGET_DIR).
# Only the files required for execution of the package have to be installed.
# Header files, static libraries and documentation will be removed again when
# the target filesystem is finalized.
$(TARGET_MAKE_ENV) \
$(MAKE1) -C $(ASTERISK_DIR) \
	GLOBAL_MAKEOPTS=$(ASTERISK_GLOBAL_MAKEOPTS) \
	USER_MAKEOPTS=menuselect.makeopts \
	ASTVARRUNDIR=/var/run/asterisk \
	SOUNDS_CACHE_DIR=$(DL_DIR) \
	DESTDIR=$(TARGET_DIR) samples basic-pbx progdocs install
mv $(TARGET_DIR)/usr/include/asterisk.h \
	 $(TARGET_DIR)/usr/include/asterisk \
	 $(STAGING_DIR)/usr/include/
# rm -Rf $(TARGET_DIR)/usr/share/man
$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/asterisk/asterisk.init $(TARGET_DIR)/etc/init.d/asterisk
$(INSTALL) -D -m 0644 $(BR2_EXTERNAL)/package/asterisk/asterisk.logrotate $(TARGET_DIR)/etc/logrotate.d/asterisk
$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/asterisk/upgrade-asterisk-sounds $(TARGET_DIR)/usr/sbin/upgrade-asterisk-sounds
$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/asterisk/safe_asterisk $(TARGET_DIR)/usr/sbin/safe_asterisk
$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/asterisk/asterisk-sip-monitor $(TARGET_DIR)/usr/sbin/asterisk-sip-monitor
$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/asterisk/asterisk-sip-monitor-ctrl $(TARGET_DIR)/usr/sbin/asterisk-sip-monitor-ctrl
$(INSTALL) -D -m 0755 $(ASTERISK_DIR)/contrib/scripts/ast_tls_cert $(TARGET_DIR)/usr/sbin/ast_tls_cert
mkdir -p $(TARGET_DIR)/stat/var/lib/asterisk
mv $(TARGET_DIR)/var/lib/asterisk/* $(TARGET_DIR)/stat/var/lib/asterisk/
rm -rf $(TARGET_DIR)/var/lib/asterisk
rm -f $(TARGET_DIR)/stat/var/lib/asterisk/astdb
ln -sf /var/db/astdb $(TARGET_DIR)/stat/var/lib/asterisk/astdb
if [ $(ASTERISK_VERSION_SINGLE)=1 ]; then \
	rm -f $(TARGET_DIR)/stat/var/lib/asterisk/astdb.sqlite3; \
	ln -sf /var/db/astdb.sqlite3 $(TARGET_DIR)/stat/var/lib/asterisk/astdb.sqlite3; \
fi; \
mkdir -p $(TARGET_DIR)/stat/var/spool
mv $(TARGET_DIR)/var/spool/asterisk $(TARGET_DIR)/stat/var/spool/
touch -c $(TARGET_DIR)/$(ASTERISK_TARGET_BINARY)
rm -f $(TARGET_DIR)/etc/asterisk/*.old
rm -f $(TARGET_DIR)/stat/var/lib/asterisk/mohmp3/*
# Remove unwanted MOH sound files to save space
rm -f $(TARGET_DIR)/stat/var/lib/asterisk/moh/macroform-robot_dity.*
rm -f $(TARGET_DIR)/stat/var/lib/asterisk/moh/macroform-cold_day.*
if [ -d $(BR2_EXTERNAL)/package/asterisk/config ]; then \
	mkdir -p $(TARGET_DIR)/stat/etc/asterisk; \
	rsync -a --exclude=".svn" $(BR2_EXTERNAL)/package/asterisk/config/ $(TARGET_DIR)/stat/etc/asterisk/; \
else \
	cp -R $(TARGET_DIR)/etc/asterisk $(TARGET_DIR)/stat/etc/; \
fi; \
$(INSTALL) -D -m 0755 $(BR2_EXTERNAL)/package/asterisk/logger.conf $(TARGET_DIR)/stat/etc/asterisk/logger.conf
chmod -R 750 $(TARGET_DIR)/stat/etc/asterisk
rm -rf $(TARGET_DIR)/etc/asterisk
ln -sf /stat/etc/asterisk $(TARGET_DIR)/etc/asterisk
$(INSTALL) -D -m 0755 $(ASTERISK_DIR)/configs/basic-pbx/*.conf $(TARGET_DIR)/stat/etc/asterisk
ln -sf /var/tmp/asterisk/sounds/custom-sounds $(TARGET_DIR)/stat/var/lib/asterisk/sounds/custom-sounds
ln -sf /var/tmp/asterisk/agi-bin/custom-agi $(TARGET_DIR)/stat/var/lib/asterisk/agi-bin/custom-agi
if [ -d $(TARGET_DIR)/usr/share/snmp/mibs ]; then \
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL)/package/asterisk/mibs/ASTERISK-MIB.txt $(TARGET_DIR)/usr/share/snmp/mibs/ ; \
	$(INSTALL) -D -m 0644 $(BR2_EXTERNAL)/package/asterisk/mibs/DIGIUM-MIB.txt $(TARGET_DIR)/usr/share/snmp/mibs/ ; \
fi
endef

define ASTERISK_INSTALL_STAGING_CMDS
# lists the actions to be performed to install the package to the staging directory,
# when the package is a target package. The package must install its files to the directory
# given by $(STAGING_DIR). All development files should be installed, since they might
# be needed to compile other packages.

endef

define ASTERISK_INSTALL_IMAGES_CMDS
# lists the actions to be performed to install the package to the images directory,
# when the package is a target package. The package must install its files to the
# directory given by $(BINARIES_DIR). Only files that are binary images (aka images)
# that do not belong in the TARGET_DIR but are necessary for booting the board should be placed here.
# For example, a package should utilize this step if it has binaries which would be similar
# to the kernel image, bootloader or root filesystem images.
endef

define ASTERISK_INSTALL_INIT_SYSV
endef

define ASTERISK_INSTALL_INIT_SYSTEMD
# list the actions to install init scripts either for the systemV-like init systems (busybox, sysvinit, etc.)
# or for the systemd units. These commands will be run only when the relevant init system is installed
# (i.e. if systemd is selected as the init system in the configuration, only ASTERISK_INSTALL_INIT_SYSTEMD will be run).
endef

define ASTERISK_HELP_CMDS
endef


#############################################################
#
# Toplevel Makefile options
#
#############################################################
$(eval $(generic-package))
