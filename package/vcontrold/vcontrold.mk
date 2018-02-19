#############################################################
#
# vcontrold
#
##############################################################

VCONTROLD_VERSION = v0.98.5
VCONTROLD_SITE = https://github.com/openv/vcontrold.git
VCONTROLD_SITE_METHOD = git
VCONTROLD_DEPENDECIES = libxml2

VCONTROLD_CONF_OPTS += -DMANPAGES=OFF

ifeq ($(BR2_PACKAGE_VCONTROLD_VCLIENT),y)
VCONTROLD_CONF_OPTS += -DVCLIENT=ON
else
VCONTROLD_CONF_OPTS += -DVCLIENT=OFF
endif

ifeq ($(BR2_PACKAGE_VCONTROLD_VSIM),y)
VCONTROLD_CONF_OPTS += -DVSIM=ON
else
VCONTROLD_CONF_OPTS += -DVSIM=OFF
endif

$(eval $(cmake-package))
