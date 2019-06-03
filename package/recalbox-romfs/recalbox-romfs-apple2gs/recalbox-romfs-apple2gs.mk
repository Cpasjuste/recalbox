################################################################################
#
# recalbox-romfs-apple2gs
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --system apple2gs --extension '.2mg .2MG' --fullname 'Apple IIGS' --platform apple2gs --theme apple2gs BR2_PACKAGE_GSPLUS

# Name the 3 vars as the package requires
RECALBOX_ROMFS_APPLE2GS_SOURCE = 
RECALBOX_ROMFS_APPLE2GS_SITE = 
RECALBOX_ROMFS_APPLE2GS_INSTALL_STAGING = NO
# Set the system name
SYSTEM_NAME_APPLE2GS = apple2gs
SYSTEM_XML_APPLE2GS = $(@D)/$(SYSTEM_NAME_APPLE2GS).xml
# System rom path
SOURCE_ROMDIR_APPLE2GS = $(RECALBOX_ROMFS_APPLE2GS_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot

ifneq ($(BR2_PACKAGE_GSPLUS),)
define CONFIGURE_APPLE2GS
	$(call RECALBOX_ROMFS_CALL_ADD_STANDALONE_SYSTEM,$(SYSTEM_XML_APPLE2GS),Apple IIGS,$(SYSTEM_NAME_APPLE2GS),.2mg .2MG,apple2gs,apple2gs,$(SOURCE_ROMDIR_APPLE2GS),$(@D))
endef
RECALBOX_ROMFS_APPLE2GS_CONFIGURE_CMDS += $(CONFIGURE_APPLE2GS)
endif

$(eval $(generic-package))
