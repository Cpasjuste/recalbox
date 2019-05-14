################################################################################
#
# kernelfirmwares
#
################################################################################

KERNELFIRMWARES_VERSION = 1603ba6e02cba120d51cda2f6f190513fa173792
KERNELFIRMWARES_SITE = http://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
KERNELFIRMWARES_SITE_METHOD = git

define KERNELFIRMWARES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware
	cp -pr $(@D)/* $(TARGET_DIR)/lib/firmware/
endef

$(eval $(generic-package))
