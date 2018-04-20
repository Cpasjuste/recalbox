################################################################################
#
# DESMUME
#
################################################################################
LIBRETRO_DESMUME_VERSION = f5df1820124ee5cbb57385cd9ae9c5c3a7183a33
LIBRETRO_DESMUME_SITE = $(call github,libretro,desmume2015,$(LIBRETRO_DESMUME_VERSION))
LIBRETRO_DESMUME_LICENSE = GPLv2


define LIBRETRO_DESMUME_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" $(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/desmume/ -f Makefile.libretro platform="$(LIBRETRO_PLATFORM)" LDFLAGS="-lpthread"
endef

define LIBRETRO_DESMUME_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/desmume/desmume2015_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/desmume_libretro.so
endef

$(eval $(generic-package))
