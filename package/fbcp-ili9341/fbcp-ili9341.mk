################################################################################
#
# fbcp-ili9341
#
################################################################################

FBCP_ILI9341_VERSION = a075f798fa42e30d4da4fa09aa0084138090bce1
FBCP_ILI9341_SITE = $(call github,Cpasjuste,fbcp-ili9341,$(FBCP_ILI9341_VERSION))
FBCP_ILI9341_DEPENDENCIES += rpi-userland

FBCP_ILI9341_CONF_OPTS = -DBUILDROOT=ON -DARMV8A=ON -DFREEPLAYTECH_WAVESHARE32B=ON -DSPI_BUS_CLOCK_DIVISOR=6 -DDMA_TX_CHANNEL=7 -DDMA_RX_CHANNEL=5 -DSTATISTICS=0 -DDISPLAY_BREAK_ASPECT_RATIO_WHEN_SCALING=ON -DUSE_DMA_TRANSFERS=ON
FBCP_ILI9341_CONF_OPTS += -DCMAKE_CXX_FLAGS="--std=gnu++98 -DALL_TASKS_SHOULD_DMA=1"

define FBCP_ILI9341_CROSS_FIXUP
	$(SED) 's|/opt/vc/include|$(STAGING_DIR)/usr/include|g' $(@D)/CMakeLists.txt
	$(SED) 's|/opt/vc/lib|$(STAGING_DIR)/usr/lib|g' $(@D)/CMakeLists.txt
	$(SED) 's|bcm_host|bcm_host vchostif|g' $(@D)/CMakeLists.txt
endef

FBCP_ILI9341_PRE_CONFIGURE_HOOKS += FBCP_ILI9341_CROSS_FIXUP

define FBCP_ILI9341_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/fbcp-ili9341 $(TARGET_DIR)/usr/bin
endef
define FBCP_ILI9341_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(FBCP_ILI9341_PKGDIR)/S04fbcp-ili9341 $(TARGET_DIR)/etc/init.d/S04fbcp-ili9341
endef

$(eval $(cmake-package))
