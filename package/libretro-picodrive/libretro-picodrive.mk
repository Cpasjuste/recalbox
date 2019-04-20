################################################################################
#
# PICODRIVE
#
################################################################################

LIBRETRO_PICODRIVE_VERSION = 445ce5c3e937350aa4cce07ae6bda12dd8274f50
LIBRETRO_PICODRIVE_SITE = git://github.com/libretro/picodrive.git
LIBRETRO_PICODRIVE_DEPENDENCIES = libpng
LIBRETRO_PICODRIVE_GIT_SUBMODULES=y

PICOPLATFORM=$(RETROARCH_LIBRETRO_PLATFORM)

# RPI 0 and 1
ifeq ($(BR2_arm1176jzf_s),y)
PICOPLATFORM=$(RETROARCH_LIBRETRO_PLATFORM) armasm
endif

# RPI 2 and 3
ifeq ($(BR2_cortex_a7)$(BR2_cortex_a53),y)
PICOPLATFORM=$(RETROARCH_LIBRETRO_PLATFORM) armasm
endif

# odroid xu4
ifeq ($(BR2_cortex_a15)$(BR2_cortex_a15_a7),y)
PICOPLATFORM=$(RETROARCH_LIBRETRO_PLATFORM) armasm
endif

#Odroidc2
ifeq ($(BR2_aarch64),y)
PICOPLATFORM=aarch64
endif

define LIBRETRO_PICODRIVE_BUILD_CMDS
	$(MAKE) -C $(@D)/cpu/cyclone CONFIG_FILE=$(@D)/cpu/cyclone_config.h
	CFLAGS="$(TARGET_CFLAGS)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
		$(MAKE) CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" -C  $(@D) -f Makefile.libretro platform="$(PICOPLATFORM)"
endef

define LIBRETRO_PICODRIVE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/picodrive_libretro.so \
		$(TARGET_DIR)/usr/lib/libretro/picodrive_libretro.so
endef

$(eval $(generic-package))
