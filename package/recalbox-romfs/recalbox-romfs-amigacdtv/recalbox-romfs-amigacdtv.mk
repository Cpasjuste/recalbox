################################################################################
#
# recalbox-romfs-amigacdtv
#
################################################################################

# Package generated with :
# ./scripts/linux/empack.py --system amigacdtv --extension '.adf .Adf .ADF .uae' --fullname 'Amiga CDTV' --platform amiga --theme amigacdtv BR2_PACKAGE_AMIBERRY

# Name the 3 vars as the package requires
RECALBOX_ROMFS_AMIGACDTV_SOURCE = 
RECALBOX_ROMFS_AMIGACDTV_SITE = 
RECALBOX_ROMFS_AMIGACDTV_INSTALL_STAGING = NO
# Set the system name
SYSTEM_NAME_AMIGACDTV = amigacdtv
SYSTEM_XML_AMIGACDTV = $(@D)/$(SYSTEM_NAME_AMIGACDTV).xml
# System rom path
SOURCE_ROMDIR_AMIGACDTV = $(RECALBOX_ROMFS_AMIGACDTV_PKGDIR)/roms

# CONFIGGEN_STD_CMD is defined in recalbox-romfs, so take good care that
# variables are global across buildroot


ifeq ($(BR2_PACKAGE_AMIBERRY),y)
define CONFIGURE_AMIGACDTV
	$(call RECALBOX_ROMFS_CALL_ADD_STANDALONE_SYSTEM,$(SYSTEM_XML_AMIGACDTV),Amiga CDTV,$(SYSTEM_NAME_AMIGACDTV),.adf .Adf .ADF .uae,amiga,amigacdtv,$(SOURCE_ROMDIR_AMIGACDTV),$(@D))
endef
RECALBOX_ROMFS_AMIGACDTV_CONFIGURE_CMDS += $(CONFIGURE_AMIGACDTV)
endif

$(eval $(generic-package))
