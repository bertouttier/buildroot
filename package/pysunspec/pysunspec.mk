#############################################################
#
# pySunSpec
#
##############################################################

PYSUNSPEC_VERSION = 5242ea9e4c687061cc0b8de4417b1943ed8f9264
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
