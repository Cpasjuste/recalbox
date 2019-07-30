################################################################################
#
# VICE_X64
#
################################################################################

LIBRETRO_VICE_X64_VERSION = df6e5f45cd88035317107d5a33e483cd551351d5
LIBRETRO_VICE_X64_SITE = $(call github,libretro,vice-libretro,$(LIBRETRO_VICE_X64_VERSION))

define LIBRETRO_VICE_X64_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile.libretro
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		SHARED="$(TARGET_SHARED)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(RETROARCH_LIBRETRO_PLATFORM)" EMUTYPE=x64
endef

define LIBRETRO_VICE_X64_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/vice_x64_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/vice_x64_libretro.so
endef

define LIBRETRO_VICE_X64_PRE_PATCH_FIXUP
	$(SED) 's/\r//g' $(@D)/libretro/libretro-core.c
endef

LIBRETRO_VICE_X64_PRE_PATCH_HOOKS += LIBRETRO_VICE_X64_PRE_PATCH_FIXUP

$(eval $(generic-package))
