################################################################################
#
# Recalbox themes for EmulationStation : https://gitlab.com/recalbox/recalbox-themes
#
################################################################################

RECALBOX_THEMES_VERSION = b0238f0e97b40ed34ccdc2a2e936fd2a1c26d5e7
RECALBOX_THEMES_SITE = https://gitlab.com/recalbox/recalbox-themes
RECALBOX_THEMES_SITE_METHOD = git

define RECALBOX_THEMES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/recalbox/share_init/system/.emulationstation/themes/
	cp -r $(@D)/themes/recalbox-next \
		$(TARGET_DIR)/recalbox/share_init/system/.emulationstation/themes/
endef

$(eval $(generic-package))
