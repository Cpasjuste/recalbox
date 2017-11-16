################################################################################
#
# recalbox-romfs-gamegear
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --system gamegear --extension '.gg .GG .zip .ZIP' --fullname 'Sega Game Gear' --platform gamegear --theme gamegear libretro:genesisplusgx:BR2_PACKAGE_LIBRETRO_GENESISPLUSGX

# Name the 3 vars as the package requires
RECALBOX_ROMFS_GAMEGEAR_SOURCE = 
RECALBOX_ROMFS_GAMEGEAR_SITE = 
RECALBOX_ROMFS_GAMEGEAR_INSTALL_STAGING = NO
# Set the system name
SYSTEM_NAME_GAMEGEAR = gamegear
SYSTEM_XML_GAMEGEAR = $(@D)/$(SYSTEM_NAME_GAMEGEAR).xml
# System rom path
SOURCE_ROMDIR_GAMEGEAR = $(RECALBOX_ROMFS_GAMEGEAR_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot


ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX),)
define CONFIGURE_MAIN_GAMEGEAR_START
	$(call RECALBOX_ROMFS_CALL_ADD_SYSTEM,$(SYSTEM_XML_GAMEGEAR),Sega Game Gear,$(SYSTEM_NAME_GAMEGEAR),.gg .GG .zip .ZIP,gamegear,gamegear)
endef

ifneq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX),)
define CONFIGURE_GAMEGEAR_LIBRETRO_START
	$(call RECALBOX_ROMFS_CALL_START_EMULATOR,$(SYSTEM_XML_GAMEGEAR),libretro)
endef
ifeq ($(BR2_PACKAGE_LIBRETRO_GENESISPLUSGX),y)
define CONFIGURE_GAMEGEAR_LIBRETRO_GENESISPLUSGX_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_GAMEGEAR),genesisplusgx)
endef
endif

define CONFIGURE_GAMEGEAR_LIBRETRO_END
	$(call RECALBOX_ROMFS_CALL_END_EMULATOR,$(SYSTEM_XML_GAMEGEAR))
endef
endif



define CONFIGURE_MAIN_GAMEGEAR_END
	$(call RECALBOX_ROMFS_CALL_END_SYSTEM,$(SYSTEM_XML_GAMEGEAR),$(SOURCE_ROMDIR_GAMEGEAR),$(@D))
endef
endif

define RECALBOX_ROMFS_GAMEGEAR_CONFIGURE_CMDS
	$(CONFIGURE_MAIN_GAMEGEAR_START)
	$(CONFIGURE_GAMEGEAR_LIBRETRO_START)
	$(CONFIGURE_GAMEGEAR_LIBRETRO_GENESISPLUSGX_DEF)
	$(CONFIGURE_GAMEGEAR_LIBRETRO_END)
	$(CONFIGURE_MAIN_GAMEGEAR_END)
endef

$(eval $(generic-package))
