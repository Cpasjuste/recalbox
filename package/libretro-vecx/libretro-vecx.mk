################################################################################
#
# VECX
#
################################################################################

LIBRETRO_VECX_VERSION = 26585ee701499550e484c11f005db18e926827d9
LIBRETRO_VECX_SITE = $(call github,libretro,libretro-vecx,$(LIBRETRO_VECX_VERSION))

define LIBRETRO_VECX_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_VECX_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/vecx_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/vecx_libretro.so
endef

$(eval $(generic-package))
