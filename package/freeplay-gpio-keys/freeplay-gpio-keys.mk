################################################################################
#
# freeplay-gpio-keys
#
################################################################################

FREEPLAY_GPIO_KEYS_VERSION = 6f94dbc24ccfdebe712ff3c72389231cfc2180d5
FREEPLAY_GPIO_KEYS_SITE = $(call github,Cpasjuste,freeplay-gpio-keys,$(FREEPLAY_GPIO_KEYS_VERSION))
FREEPLAY_GPIO_KEYS_DEPENDENCIES += rpi-firmware

define FREEPLAY_GPIO_KEYS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/gpio-keys-freeplay-min.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/gpio-keys-freeplay-min.dtbo
	$(INSTALL) -D -m 0644 $(@D)/gpio-keys-freeplay.dtbo $(BINARIES_DIR)/rpi-firmware/overlays/gpio-keys-freeplay.dtbo
endef

$(eval $(generic-package))
