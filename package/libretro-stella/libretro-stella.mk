################################################################################
#
# STELLA
#
################################################################################

LIBRETRO_STELLA_VERSION = 3112c4deb03a95f147afb0d2108509c18d220c18
LIBRETRO_STELLA_SITE = $(call github,stella-emu,stella,$(LIBRETRO_STELLA_VERSION))

define LIBRETRO_STELLA_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/src/libretro/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/src/libretro -f \
		Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_STELLA_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/libretro/stella_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/stella_libretro.so
endef

$(eval $(generic-package))
