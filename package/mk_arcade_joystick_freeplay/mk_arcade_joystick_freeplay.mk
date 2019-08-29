################################################################################
#
# MK_ARCADE_JOYSTICK_FREEPLAY
#
################################################################################

MK_ARCADE_JOYSTICK_FREEPLAY_VERSION = 4692beeb5490c6d061de3cacf84ac442bd35b3a3
MK_ARCADE_JOYSTICK_FREEPLAY_SITE = $(call github,Cpasjuste,mk_arcade_joystick_rpi,$(MK_ARCADE_JOYSTICK_FREEPLAY_VERSION))
MK_ARCADE_JOYSTICK_FREEPLAY_DEPENDENCIES = linux

define MK_ARCADE_JOYSTICK_FREEPLAY_MAKE_HOOK
	cp $(@D)/Makefile.cross $(@D)/Makefile
endef
MK_ARCADE_JOYSTICK_FREEPLAY_PRE_BUILD_HOOKS += MK_ARCADE_JOYSTICK_FREEPLAY_MAKE_HOOK

define MK_ARCADE_JOYSTICK_FREEPLAY_BUILD_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR)
endef

define MK_ARCADE_JOYSTICK_FREEPLAY_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR) modules_install
endef

$(eval $(generic-package))
