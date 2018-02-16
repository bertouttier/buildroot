#############################################################
#
# freepbx
#
##############################################################
FREEPBX_VERSION = 14.0.1.20
FREEPBX_SOURCE = freepbx-$(FREEPBX_VERSION).tgz
FREEPBX_SITE = http://mirror.freepbx.org/modules/packages/freepbx
FREEPBX_DIR = $(BUILD_DIR)/freepbx-$(ASTERISK_VERSION)
FREEPBX_DEPENDENCIES = asterisk php sqlite host-sqlite

define FREEPBX_CONFIGURE_CMDS
# lists the actions to be performed to configure the package before its compilation.
# asterisk-clean
endef

define FREEPBX_BUILD_CMDS
# lists the actions to be performed to compile the package.
endef

FILES = confbridge_custom.conf \
iax_custom_post.conf \
iax_custom.conf \
sip_notify_custom.conf \
logger_general_custom.conf \
udptl_custom.conf \
queues_custom.conf \
pjsip.aor_custom.conf \
sip_general_custom.conf \
pjsip.transports_custom_post.conf \
pjsip.auth_custom_post.conf \
extensions_custom.conf \
sip_nat.conf \
extensions_override_freepbx.conf \
pjsip.registration_custom.conf \
xmpp_general_custom.conf \
meetme_general_additional.conf \
manager_custom.conf \
pjsip.endpoint_custom.conf \
queues_post_custom.conf \
xmpp_custom.conf \
pjsip.registration_custom_post.conf \
pjsip.aor_custom_post.conf \
ari.conf \
manager_additional.conf \
pjsip_custom.conf \
res_odbc_custom.conf \
pjsip_custom_post.conf \
pjsip.endpoint_custom_post.conf \
logger_logfiles_custom.conf \
cel_general_custom.conf \
sip_custom.conf \
queues_custom_general.conf \
sip_registrations_custom.conf \
musiconhold_custom.conf \
cel_odbc_custom.conf \
http_custom.conf \
features_applicationmap_custom.conf \
globals_custom.conf \
features_featuremap_custom.conf \
pjsip.transports_custom.conf \
pjsip.identify_custom_post.conf \
iax_general_custom.conf \
pjsip.auth_custom.conf \
rtp_custom.conf \
meetme_general_custom.conf \
sip_custom_post.conf \
iax_registrations_custom.conf \
pjsip.identify_custom.conf \
features_general_custom.conf \
cel_custom_post.conf \
motif_custom.conf \
cdr.conf

define FREEPBX_INSTALL_TARGET_CMDS
# lists the actions to be performed to install the package
# to the target directory, when the package is a target package.
# The package must install its files to the directory given by $(TARGET_DIR).
# Only the files required for execution of the package have to be installed.
# Header files, static libraries and documentation will be removed again when
# the target filesystem is finalized.

	# install config files
	cp $(FREEPBX_PKGDIR)/asterisk.conf $(TARGET_DIR)/etc/asterisk/asterisk.conf
	cp $(FREEPBX_PKGDIR)/amportal.conf $(TARGET_DIR)/etc/asterisk/amportal.conf

	# install SQlite databases and prepopulate
	rm $(TARGET_DIR)/var/lib/asterisk/freepbx.db
	rm $(TARGET_DIR)/var/lib/asterisk/cdr.db
	$(HOST_DIR)/usr/bin/sqlite3 $(TARGET_DIR)/var/lib/asterisk/freepbx.db < $(FREEPBX_PKGDIR)/freepbx.sql
	$(HOST_DIR)/usr/bin/sqlite3 $(TARGET_DIR)/var/lib/asterisk/cdr.db < $(FREEPBX_PKGDIR)/cdr.sql

	# chown www-data:www-data /var/lib/asterisk/freepbx.db
	# chmod g+rw /var/lib/freepbx/freepbx.db
	# chown www-data:www-data /var/lib/asterisk/
	# chmod g+rw /var/lib/asterisk/

	mkdir -m 0777 -p $(TARGET_DIR)/var/www/html
	# chown -R asterisk:asterisk $(TARGET_DIR)/var/www/html

	cp -R $(@D)/amp_conf/agi-bin/* $(TARGET_DIR)/var/lib/asterisk/agi-bin/
	cp -R $(@D)/amp_conf/astetc/* $(TARGET_DIR)/etc/asterisk/
	cp -R $(@D)/amp_conf/bin/* $(TARGET_DIR)/var/lib/asterisk/bin/
	cp -R $(@D)/amp_conf/etc/init.d/* $(TARGET_DIR)/etc/init.d/
	cp -R $(@D)/amp_conf/htdocs/* $(TARGET_DIR)/var/www/html/
	mkdir -p $(TARGET_DIR)/var/lib/asterisk/moh/
	cp -R $(@D)/amp_conf/moh/* $(TARGET_DIR)/var/lib/asterisk/moh/

	ln -sf ../../var/lib/asterisk/bin/fwconsole $(TARGET_DIR)/usr/sbin/fwconsole
	ln -sf ../../var/lib/asterisk/bin/amportal $(TARGET_DIR)/usr/sbin/amportal

	chmod 0755 $(TARGET_DIR)/var/lib/asterisk/bin/freepbx_engine
	chmod 0755 $(TARGET_DIR)/var/lib/asterisk/bin/freepbx_setting
	chmod 0755 $(TARGET_DIR)/var/lib/asterisk/bin/fwconsole
	chmod 0755 $(TARGET_DIR)/var/lib/asterisk/bin/gen_amp_conf.php
	chmod 0755 $(TARGET_DIR)/var/lib/asterisk/bin/retrieve_conf
	chmod 0755 $(TARGET_DIR)/usr/sbin/amportal
	chmod 0755 $(TARGET_DIR)/usr/sbin/fwconsole

	mkdir -m 0777 -p $(TARGET_DIR)/var/www/html/admin/modules/_cache
	mkdir -m 0777 -p $(TARGET_DIR)/var/www/html/admin/modules/framework
	mkdir -m 0755 -p $(TARGET_DIR)/var/spool/asterisk/voicemail/device
	mkdir -m 0766 -p $(TARGET_DIR)/var/spool/asterisk/fax
	mkdir -m 0766 -p $(TARGET_DIR)/var/spool/asterisk/monitor

	cp $(@D)/module.xml $(TARGET_DIR)/var/www/html/admin/modules/framework/
	cp $(@D)/module.sig $(TARGET_DIR)/var/www/html/admin/modules/framework/
	cp $(@D)/install.php $(TARGET_DIR)/var/www/html/admin/modules/framework/
	# cp $(@D)/LICENSE $(TARGET_DIR)/var/www/html/admin/modules/framework/
	# cp $(@D)/README.md $(TARGET_DIR)/var/www/html/admin/modules/framework/

	cp $(FREEPBX_PKGDIR)/voicemail.conf $(TARGET_DIR)/etc/asterisk/voicemail.conf
	
	for f in $(FILES) ; do \
    echo "touching $$f" ; \
    touch $(TARGET_DIR)/etc/asterisk/$$f ; \
  done

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
