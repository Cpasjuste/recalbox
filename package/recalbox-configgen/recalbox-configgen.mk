################################################################################
#
# recalbox configgen version
#
################################################################################

RECALBOX_CONFIGGEN_VERSION = b9a3c2975a80e9591de8ccf25ace47b195d2ffed

RECALBOX_CONFIGGEN_SITE = https://gitlab.com/recalbox/recalbox-configgen.git
RECALBOX_CONFIGGEN_SITE_METHOD = git

RECALBOX_CONFIGGEN_LICENSE = GPL2
RECALBOX_CONFIGGEN_DEPENDENCIES = python

RECALBOX_CONFIGGEN_SETUP_TYPE = distutils

$(eval $(python-package))
