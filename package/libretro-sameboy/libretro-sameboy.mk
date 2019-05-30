################################################################################
#
# SAMEBOY
#
################################################################################

LIBRETRO_SAMEBOY_VERSION = 3ee2c648996c6eb3a2fb32113b984215f54b7b02
LIBRETRO_SAMEBOY_SITE = $(call github,libretro,SameBoy,$(LIBRETRO_SAMEBOY_VERSION))
LIBRETRO_SAMEBOY_DEPENDENCIES = rgbds

define LIBRETRO_SAMEBOY_BUILD_CMDS
	$(SED) "s|-O2|-O3|g" $(@D)/libretro/Makefile
	# Missing variable definition to  rgb* tools - Use a brutal SED for now
	$(SED) "s|rgbasm|$(HOST_DIR)/usr/bin/rgbasm|g" $(@D)/Makefile
	$(SED) "s|rgblink|$(HOST_DIR)/usr/bin/rgblink|g" $(@D)/Makefile
	# Haha... when using -Werror you should ensure there are actually *NO* warning at all :)
	$(SED) "s|-Werror||g" $(@D)/Makefile
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" -C $(@D) platform="unix" libretro bootroms
endef

define LIBRETRO_SAMEBOY_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/build/bin/sameboy_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/sameboy_libretro.so
	$(INSTALL) -D $(@D)/build/bin/BootROMs/*.bin \
		$(TARGET_DIR)/recalbox/share_init/bios/
endef

$(eval $(generic-package))
