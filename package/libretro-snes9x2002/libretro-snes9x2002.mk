################################################################################
#
# SNES9X2002 / POCKETSNES
#
################################################################################

LIBRETRO_SNES9X2002_VERSION = 903c003cad96add4599f0a94fab7a03735e20d3e
LIBRETRO_SNES9X2002_SITE = $(call github,libretro,snes9x2002,$(LIBRETRO_SNES9X2002_VERSION))

define LIBRETRO_SNES9X2002_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)
endef

define LIBRETRO_SNES9X2002_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/snes9x2002_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/snes9x2002_libretro.so
endef

$(eval $(generic-package))
