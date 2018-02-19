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
endif

ifeq ($(BR2_PACKAGE_VCONTROLD_VSIM),y)
VCONTROLD_CONF_OPTS += -DVSIM=ON
endif

$(eval $(cmake-package))
