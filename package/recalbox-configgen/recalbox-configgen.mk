################################################################################
#
# recalbox configgen version https://github.com/digitalLumberjack/recalbox-configgen
#
################################################################################

RECALBOX_CONFIGGEN_VERSION = a5d73cf9523fc1f1faef0b7e89e45455c09859dd

RECALBOX_CONFIGGEN_SITE = $(call github,recalbox,recalbox-configgen,$(RECALBOX_CONFIGGEN_VERSION))

RECALBOX_CONFIGGEN_LICENSE = GPL2
RECALBOX_CONFIGGEN_DEPENDENCIES = python

RECALBOX_CONFIGGEN_SETUP_TYPE = distutils

$(eval $(python-package))
