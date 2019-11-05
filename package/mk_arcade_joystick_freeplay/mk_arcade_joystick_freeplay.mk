################################################################################
#
# MK_ARCADE_JOYSTICK_FREEPLAY
#
################################################################################

MK_ARCADE_JOYSTICK_FREEPLAY_VERSION = 4692beeb5490c6d061de3cacf84ac442bd35b3a3
MK_ARCADE_JOYSTICK_FREEPLAY_SITE = $(call github,Cpasjuste,mk_arcade_joystick_rpi,$(MK_ARCADE_JOYSTICK_FREEPLAY_VERSION))
MK_ARCADE_JOYSTICK_FREEPLAY_DEPENDENCIES = linux

# Needed beacause can't pass cflags to cc
define MK_ARCADE_JOYSTICK_FREEPLAY_RPI2_HOOK
	$(SED) "s/#define PERI_BASE        0x20000000/#define PERI_BASE        0x3F000000/g" $(@D)/mk_arcade_joystick_rpi.c
endef

ifeq ($(BR2_cortex_a7),y)
MK_ARCADE_JOYSTICK_FREEPLAY_PRE_CONFIGURE_HOOKS += MK_ARCADE_JOYSTICK_FREEPLAY_RPI2_HOOK
endif
ifeq ($(BR2_cortex_a53),y)
MK_ARCADE_JOYSTICK_FREEPLAY_PRE_CONFIGURE_HOOKS += MK_ARCADE_JOYSTICK_FREEPLAY_RPI2_HOOK
endif

define MK_ARCADE_JOYSTICK_FREEPLAY_MAKE_HOOK
	cp $(@D)/Makefile.cross $(@D)/Makefile
endef
MK_ARCADE_JOYSTICK_FREEPLAY_PRE_BUILD_HOOKS += MK_ARCADE_JOYSTICK_FREEPLAY_MAKE_HOOK

define MK_ARCADE_JOYSTICK_FREEPLAY_BUILD_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR)
endef

define MK_ARCADE_JOYSTICK_FREEPLAY_INSTALL_TARGET_CMDS
	# mk_arcade_joystick_freeplay.ko will replace mk_arcade_joystick_rpi.ko at runtime (recalbox-hardware)
	cp $(@D)/mk_arcade_joystick_rpi.ko $(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/extra/mk_arcade_joystick_freeplay.ko
endef

$(eval $(generic-package))
