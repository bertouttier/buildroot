#############################################################
#
# pySunSpec
#
##############################################################

PYSUNSPEC_VERSION = v.1.0.8
PYSUNSPEC_SITE = https://github.com/sunspec/pysunspec.git
PYSUNSPEC_SITE_METHOD = git
PYSUNSPEC_GIT_SUBMODULES = YES
PYSUNSPEC_DEPENDENCIES = python3
PYSUNSPEC_LICENSE = MIT
PYSUNSPEC_LICENSE_FILES = LICENSE
PYSUNSPEC_SETUP_TYPE = setuptools

PKG_PYTHON_SETUPTOOLS_INSTALL_TARGET_OPTS = \
        --prefix=$(TARGET_DIR)/usr \
        --root=/

$(eval $(python-package))
