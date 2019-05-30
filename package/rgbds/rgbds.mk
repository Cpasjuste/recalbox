################################################################################
#
# RGBDS
#
################################################################################

RGBDS_VERSION = v0.3.8
RGBDS_SITE = $(call github,rednex,rgbds,$(RGBDS_VERSION))
RGBDS_DEPENDENCIES = libpng

define RGBDS_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define RGBDS_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/rgbasm $(HOST_DIR)/usr/bin/
	$(INSTALL) -D $(@D)/rgbfix $(HOST_DIR)/usr/bin/
	$(INSTALL) -D $(@D)/rgbgfx $(HOST_DIR)/usr/bin/
	$(INSTALL) -D $(@D)/rgblink $(HOST_DIR)/usr/bin/
endef

$(eval $(generic-package))
