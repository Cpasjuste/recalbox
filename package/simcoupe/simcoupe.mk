################################################################################
#
# MGT SAM Coupe Emulation
#
################################################################################
SIMCOUPE_VERSION = 3be5b80b14143b608f40cbecc4668da76701b448
SIMCOUPE_SITE = $(call github,simonowen,simcoupe,$(SIMCOUPE_VERSION))
SIMCOUPE_DEPENDENCIES = sdl2

define SIMCOUPE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/simcoupe \
		$(TARGET_DIR)/usr/bin/simcoupe
	mkdir -p $(TARGET_DIR)/recalbox/share_init/bios/samcoupe
	cp -R $(@D)/Resource/** $(TARGET_DIR)/recalbox/share_init/bios/samcoupe
endef

define SIMCOUPE_POST_EXTRACT_FIX_SDL2_PATH
    @echo CHANGING CMakeList.txt
    /bin/sed -i -E -e "s|set\(RESOURCE_DIR \\$$\{CMAKE_INSTALL_PREFIX\}/share/\\$$\{PROJECT_NAME\}\)|set(RESOURCE_DIR /recalbox/share_init/bios/samcoupe)|g" $(@D)/CMakeLists.txt
    /bin/sed -i -E -e "s|\r$$||g" $(@D)/Base/Joystick.cpp
endef
 
SIMCOUPE_POST_EXTRACT_HOOKS += SIMCOUPE_POST_EXTRACT_FIX_SDL2_PATH

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
SIMCOUPE_DEPENDENCIES += libgl
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
SIMCOUPE += libgles
endif

$(eval $(cmake-package))


