################################################################################
#
# HATARI
#
################################################################################

LIBRETRO_HATARI_VERSION = ecfc143efce6e068a4b506dfdaf6516d3c268372
LIBRETRO_HATARI_SITE = $(call github,libretro,hatari,$(LIBRETRO_HATARI_VERSION))
LIBRETRO_HATARI_DEPENDENCIES = libcapsimage

define LIBRETRO_HATARI_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile.libretro
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		ASFLAGS="$(TARGET_ASFLAGS)" PLATFLAGS="$(TARGET_PLATFLAGS)" SHARED="$(TARGET_SHARED)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile.libretro platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_HATARI_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/hatari_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/hatari_libretro.so
endef

define LIBRETRO_HATARI_PRE_PATCH_FIXUP
	$(SED) 's/\r//g' $(@D)/Makefile.libretro
endef

LIBRETRO_HATARI_PRE_PATCH_HOOKS += LIBRETRO_HATARI_PRE_PATCH_FIXUP

$(eval $(generic-package))
