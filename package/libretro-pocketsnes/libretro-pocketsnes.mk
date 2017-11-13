################################################################################
#
# POCKETSNES / SNES9X2002
#
################################################################################
LIBRETRO_POCKETSNES_VERSION = 077f38e2702c4a704259c9026cf584a423d55982
LIBRETRO_POCKETSNES_SITE = $(call github,libretro,snes9x2002,$(LIBRETRO_POCKETSNES_VERSION))

define LIBRETRO_POCKETSNES_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" LD="$(TARGET_LD)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_POCKETSNES_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/snes9x2002_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/pocketsnes_libretro.so
endef

$(eval $(generic-package))
