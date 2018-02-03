################################################################################
#
# sdl2_net
#
################################################################################

SDL2_NET_VERSION = 2.0.1
SDL2_NET_SITE = http://www.libsdl.org/projects/SDL_net/release
SDL2_NET_SOURCE = SDL2_net-$(SDL2_NET_VERSION).tar.gz
SDL2_NET_LICENSE = zlib
SDL2_NET_LICENSE_FILES = COPYING

SDL2_NET_CONF_OPTS = \
	--with-sdl-prefix=$(STAGING_DIR)/usr \
	--with-sdl-exec-prefix=$(STAGING_DIR)/usr

SDL2_NET_INSTALL_STAGING = YES

SDL2_NET_DEPENDENCIES = sdl2

$(eval $(autotools-package))
