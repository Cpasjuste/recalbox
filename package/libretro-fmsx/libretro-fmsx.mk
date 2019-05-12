################################################################################
#
# FMSX
#
################################################################################

LIBRETRO_FMSX_VERSION = 6b241974ffb4d2a3fc681b65a8ff6b717501cb67
LIBRETRO_FMSX_SITE = $(call github,libretro,fmsx-libretro,$(LIBRETRO_FMSX_VERSION))

define LIBRETRO_FMSX_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D) platform="$(RETROARCH_LIBRETRO_PLATFORM)" PLATFORM_DEFINES="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)"
endef

define LIBRETRO_FMSX_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/fmsx_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/fmsx_libretro.so
	# Copy required ROM images
	cp -R $(@D)/fMSX/ROMs/* $(TARGET_DIR)/recalbox/share_init/bios
endef

$(eval $(generic-package))
