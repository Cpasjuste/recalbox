################################################################################
#
# recalbox-romfs-fba_libretro
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --system fba_libretro --extension '.zip .ZIP .fba .FBA .7z .7Z' --fullname 'FinalBurn Alpha' --platform arcade --theme fba_libretro libretro:fbalpha:BR2_PACKAGE_LIBRETRO_FBALPHA

# Name the 3 vars as the package requires
RECALBOX_ROMFS_FBA_LIBRETRO_SOURCE = 
RECALBOX_ROMFS_FBA_LIBRETRO_SITE = 
RECALBOX_ROMFS_FBA_LIBRETRO_INSTALL_STAGING = NO
# Set the system name
SYSTEM_NAME_FBA_LIBRETRO = fba_libretro
SYSTEM_XML_FBA_LIBRETRO = $(@D)/$(SYSTEM_NAME_FBA_LIBRETRO).xml
# System rom path
SOURCE_ROMDIR_FBA_LIBRETRO = $(RECALBOX_ROMFS_FBA_LIBRETRO_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot


ifneq ($(BR2_PACKAGE_LIBRETRO_FBALPHA),)
define CONFIGURE_MAIN_FBA_LIBRETRO_START
	$(call RECALBOX_ROMFS_CALL_ADD_SYSTEM,$(SYSTEM_XML_FBA_LIBRETRO),FinalBurn Alpha,$(SYSTEM_NAME_FBA_LIBRETRO),.zip .ZIP .fba .FBA .7z .7Z,arcade,fba_libretro)
endef

ifneq ($(BR2_PACKAGE_LIBRETRO_FBALPHA),)
define CONFIGURE_FBA_LIBRETRO_LIBRETRO_START
	$(call RECALBOX_ROMFS_CALL_START_EMULATOR,$(SYSTEM_XML_FBA_LIBRETRO),libretro)
endef
ifeq ($(BR2_PACKAGE_LIBRETRO_FBALPHA),y)
define CONFIGURE_FBA_LIBRETRO_LIBRETRO_FBALPHA_DEF
	$(call RECALBOX_ROMFS_CALL_ADD_CORE,$(SYSTEM_XML_FBA_LIBRETRO),fbalpha)
endef
endif

define CONFIGURE_FBA_LIBRETRO_LIBRETRO_END
	$(call RECALBOX_ROMFS_CALL_END_EMULATOR,$(SYSTEM_XML_FBA_LIBRETRO))
endef
endif



define CONFIGURE_MAIN_FBA_LIBRETRO_END
	$(call RECALBOX_ROMFS_CALL_END_SYSTEM,$(SYSTEM_XML_FBA_LIBRETRO),$(SOURCE_ROMDIR_FBA_LIBRETRO),$(@D))
endef
endif

define RECALBOX_ROMFS_FBA_LIBRETRO_CONFIGURE_CMDS
	$(CONFIGURE_MAIN_FBA_LIBRETRO_START)
	$(CONFIGURE_FBA_LIBRETRO_LIBRETRO_START)
	$(CONFIGURE_FBA_LIBRETRO_LIBRETRO_FBALPHA_DEF)
	$(CONFIGURE_FBA_LIBRETRO_LIBRETRO_END)
	$(CONFIGURE_MAIN_FBA_LIBRETRO_END)
endef

$(eval $(generic-package))