################################################################################
#
# MU
#
################################################################################

LIBRETRO_MU_VERSION = 33f7cb89480ae51cd26ad032e73346bb362d39b2
LIBRETRO_MU_SITE = $(call github,meepingsnesroms,mu,$(LIBRETRO_MU_VERSION))

define LIBRETRO_MU_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/libretroBuildSystem/Makefile.libretro
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" LD="$(TARGET_LD)" AR="$(TARGET_AR)" \
		RANLIB="$(TARGET_RANLIB)" -C $(@D)/libretroBuildSystem -f \
		Makefile.libretro platform="$(RETROARCH_LIBRETRO_PLATFORM)"
endef

define LIBRETRO_MU_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/libretroBuildSystem/mu_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/mu_libretro.so
endef

$(eval $(generic-package))
