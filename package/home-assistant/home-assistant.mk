#############################################################
#
# home-assistant
#
##############################################################

HOME_ASSISTANT_VERSION = 0.63.3
HOME_ASSISTANT_SITE = https://github.com/home-assistant/home-assistant.git
HOME_ASSISTANT_SITE_METHOD = git
HOME_ASSISTANT_DEPENDENCIES = python3
HOME_ASSISTANT_LICENSE = Apache v2.0
HOME_ASSISTANT_LICENSE_FILES = LICENSE.md
HOME_ASSISTANT_SETUP_TYPE = setuptools

$(eval $(python-package))
