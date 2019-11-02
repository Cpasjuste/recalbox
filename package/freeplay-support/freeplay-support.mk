################################################################################
#
# freeplay-support
#
################################################################################

FREEPLAY_SUPPORT_VERSION = 9d4cb3dca7f78c7dd4fce7a8c7147f03493fce4f
FREEPLAY_SUPPORT_SITE = $(call github,Cpasjuste,freeplay-support,$(FREEPLAY_SUPPORT_VERSION))
FREEPLAY_SUPPORT_DEPENDENCIES += rpi-firmware recalbox-themes

define FREEPLAY_SUPPORT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(FREEPLAY_SUPPORT_PKGDIR)/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
	cp -r $(@D)/themes/recalbox-gpicase $(TARGET_DIR)/recalbox/share_init/system/.emulationstation/themes/
endef

$(eval $(generic-package))
