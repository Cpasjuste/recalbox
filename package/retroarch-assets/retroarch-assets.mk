################################################################################
#
# RETROARCH ASSETS
#
################################################################################

RETROARCH_ASSETS_VERSION = ffffb2cf4dc5586de41e4e2ae2ca7533c472178e
RETROARCH_ASSETS_SITE = $(call github,libretro,retroarch-assets,$(RETROARCH_ASSETS_VERSION))
RETROARCH_ASSETS_LICENSE = GPL
RETROARCH_ASSETS_DEPENDENCIES = retroarch

define RETROARCH_ASSETS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/retroarch/assets/xmb
	cp -r $(@D)/ozone $(TARGET_DIR)/usr/share/retroarch/assets
	cp -r $(@D)/rgui $(TARGET_DIR)/usr/share/retroarch/assets
	cp -r $(@D)/glui $(TARGET_DIR)/usr/share/retroarch/assets
	cp -r $(@D)/xmb/monochrome $(TARGET_DIR)/usr/share/retroarch/assets/xmb
	cp -r $(@D)/menu_widgets $(TARGET_DIR)/usr/share/retroarch/assets
endef

$(eval $(generic-package))
