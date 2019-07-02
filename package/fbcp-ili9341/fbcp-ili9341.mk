################################################################################
#
# fbcp-ili9341
#
################################################################################

FBCP_ILI9341_VERSION = 0b46b04f1d05a5f5088e750bfde28b2099b8da7d
FBCP_ILI9341_SITE = $(call github,juj,fbcp-ili9341,$(FBCP_ILI9341_VERSION))
FBCP_ILI9341_DEPENDENCIES += rpi-userland

define FBCP_ILI9341_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/CMakeLists.txt
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/CMakeLists.txt
	$(SED) 's|bcm_host|bcm_host vchostif|g' $(@D)/CMakeLists.txt
endef

FBCP_ILI9341_PRE_CONFIGURE_HOOKS += FBCP_ILI9341_CROSS_FIXUP

FBCP_ILI9341_CONF_OPTS = -DFREEPLAYTECH_WAVESHARE32B=ON -DSPI_BUS_CLOCK_DIVISOR=30 -DARMV8A=ON
FBCP_ILI9341_CONF_OPTS += -DCMAKE_CXX_FLAGS="--std=gnu++98"
#TODO: -DSPI_BUS_CLOCK_DIVISOR=6

define FBCP_ILI9341_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/fbcp-ili9341 $(TARGET_DIR)/usr/bin
endef

define FBCP_ILI9341_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(FBCP_ILI9341_PKGDIR)/S13fbcp-ili9341 $(TARGET_DIR)/etc/init.d/S13fbcp-ili9341
endef

$(eval $(cmake-package))
