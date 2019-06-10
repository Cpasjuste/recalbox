################################################################################
#
# FBNEO
#
################################################################################

LIBRETRO_FBNEO_VERSION = 6df0149698c44815463077a5083bdc5787d9a5b4
LIBRETRO_FBNEO_SITE = $(call github,libretro,FBNeo,$(LIBRETRO_FBNEO_VERSION))

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
LIBRETRO_FBNEO_OPTIONS += "HAVE_NEON=1"
else
LIBRETRO_FBNEO_OPTIONS += "HAVE_NEON=0"
endif

ifeq ($(BR2_arm),y)
LIBRETRO_FBNEO_OPTIONS += USE_CYCLONE=1
endif

define LIBRETRO_FBNEO_BUILD_CMDS
	CFLAGS="$(TARGET_CFLAGS) $(COMPILER_COMMONS_CFLAGS_SO)" \
		CXXFLAGS="$(TARGET_CXXFLAGS) $(COMPILER_COMMONS_CXXFLAGS_SO)" \
		LDFLAGS="$(TARGET_LDFLAGS) $(COMPILER_COMMONS_LDFLAGS_SO)" \
		$(MAKE) CXX="$(TARGET_CXX)" CC="$(TARGET_CC)" -C $(@D)/src/burner/libretro -f Makefile platform="$(RETROARCH_LIBRETRO_BOARD)" $(LIBRETRO_FBNEO_OPTIONS)
endef

define LIBRETRO_FBNEO_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/src/burner/libretro/fbneo_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/fbneo_libretro.so
	mkdir -p $(TARGET_DIR)/recalbox/share_init/bios/fbn/samples
	cp "$(@D)/dats/FinalBurn Neo (ClrMame Pro XML, Arcade only).dat" \
		$(TARGET_DIR)/recalbox/share_init/bios/fbn
	cp "$(@D)/dats/FinalBurn Neo (ClrMame Pro XML, Neogeo only).dat" \
		$(TARGET_DIR)/recalbox/share_init/bios/fbn
	cp -R $(@D)/metadata/* $(TARGET_DIR)/recalbox/share_init/bios/fbn
endef

$(eval $(generic-package))
