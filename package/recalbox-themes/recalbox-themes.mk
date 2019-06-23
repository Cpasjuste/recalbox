################################################################################
#
# Recalbox themes for EmulationStation : https://gitlab.com/recalbox/recalbox-themes
#
################################################################################

RECALBOX_THEMES_VERSION = a83b9300eb6cabdea07ae79f7a1ac1add119e4a6
RECALBOX_THEMES_SITE = https://gitlab.com/recalbox/recalbox-themes
RECALBOX_THEMES_SITE_METHOD = git

define RECALBOX_THEMES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/recalbox/share_init/system/.emulationstation/themes/
	cp -r $(@D)/themes/recalbox-next \
		$(TARGET_DIR)/recalbox/share_init/system/.emulationstation/themes/
endef

$(eval $(generic-package))
