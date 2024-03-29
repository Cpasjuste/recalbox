################################################################################
#
# BEETLE_NGP
#
################################################################################

LIBRETRO_BEETLE_NGP_VERSION = 6130e4057c3d8f9172f0c49bb9b6c61bd1a572d5
LIBRETRO_BEETLE_NGP_SITE = $(call github,libretro,beetle-ngp-libretro,$(LIBRETRO_BEETLE_NGP_VERSION))

define LIBRETRO_BEETLE_NGP_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/ -f Makefile platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_BEETLE_NGP_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/mednafen_ngp_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mednafen_ngp_libretro.so
endef

$(eval $(generic-package))
