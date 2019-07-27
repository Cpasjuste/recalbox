################################################################################
#
# NXENGINE
#
################################################################################

LIBRETRO_NXENGINE_VERSION = cf371bcb67e6dec1124e5d77167738732e52d5c0
LIBRETRO_NXENGINE_SITE = $(call github,libretro,nxengine-libretro,$(LIBRETRO_NXENGINE_VERSION))

define LIBRETRO_NXENGINE_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(RETROARCH_LIBRETRO_BOARD)"
endef

define LIBRETRO_NXENGINE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/nxengine_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/nxengine_libretro.so
endef

$(eval $(generic-package))
