################################################################################
#
# ARMSNES
#
################################################################################

LIBRETRO_ARMSNES_VERSION = ca2fcbb55b83b18ef7a14618be318b9b226fda69
LIBRETRO_ARMSNES_SITE = $(call github,rmaz,ARMSNES-libretro,$(LIBRETRO_ARMSNES_VERSION))

LIBRETRO_ARMSNES_TARGET = libarmsnes.so

define ARMSNES_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" \
		CFLAGS="$(TARGET_CFLAGS)" LD="$(TARGET_LD)" \
		TARGET="$(LIBRETRO_ARMSNES_TARGET)" -C $(@D) all
endef

define ARMSNES_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/$(LIBRETRO_ARMSNES_TARGET) \
		$(TARGET_DIR)/usr/lib/libretro/$(LIBRETRO_ARMSNES_TARGET)
endef

$(eval $(generic-package))
