################################################################################
#
# freeplay-support
#
################################################################################

FREEPLAY_SUPPORT_VERSION = b5197174aded98d903de9d3ae12359a3bc2f633d
FREEPLAY_SUPPORT_SOURCE = 
#FREEPLAY_SUPPORT_SITE = $(call github,Cpasjuste,freeplay-support,$(FREEPLAY_SUPPORT_VERSION))
FREEPLAY_SUPPORT_DEPENDENCIES += rpi-firmware

define FREEPLAY_SUPPORT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(FREEPLAY_SUPPORT_PKGDIR)/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
endef

$(eval $(generic-package))
