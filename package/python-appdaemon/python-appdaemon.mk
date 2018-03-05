################################################################################
#
# python-appdaemon
#
################################################################################

PYTHON_APPDAEMON_VERSION = 3.0.0b4
PYTHON_APPDAEMON_SOURCE = appdaemon-$(PYTHON_APPDAEMON_VERSION).tar.gz
PYTHON_APPDAEMON_SITE = https://pypi.python.org/packages/68/ff/ecdeccd3dc1c27d06b6dd763a390c1f5b9bbc8c9a497d5b84d5a674fa925
PYTHON_APPDAEMON_DEPENDENCIES = python3
PYTHON_APPDAEMON_LICENSE = Apache v2.0
PYTHON_APPDAEMON_LICENSE_FILES = LICENSE.md
PYTHON_APPDAEMON_SETUP_TYPE = setuptools

$(eval $(python-package))