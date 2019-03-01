################################################################################
#
# Vice Emulation
#
################################################################################

VICE_VERSION = 2.4.24
VICE_SITE = https://sourceforge.net/projects/vice-emu/files/development-releases

VICE_CONF_OPTS += \
	--disable-option-checking \
	--enable-sdlui \
	--enable-native-tools=gcc \
	CFLAGS="-march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard -O2"

VICE_DEPENDENCIES = sdl

$(eval $(autotools-package))
