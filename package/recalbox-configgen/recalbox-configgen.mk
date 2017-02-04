################################################################################
#
# recalbox configgen version https://github.com/digitalLumberjack/recalbox-configgen
#
################################################################################

RECALBOX_CONFIGGEN_VERSION = a43aefa652bf6bcf4d0568b505cf91361dfd4379

RECALBOX_CONFIGGEN_SITE = $(call github,recalbox,recalbox-configgen,$(RECALBOX_CONFIGGEN_VERSION))

RECALBOX_CONFIGGEN_LICENSE = GPL2
RECALBOX_CONFIGGEN_DEPENDENCIES = python

RECALBOX_CONFIGGEN_SETUP_TYPE = distutils

$(eval $(python-package))
