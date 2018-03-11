FROM ubuntu:16.04
MAINTAINER digitalLumberjack <digitallumberjack@recalbox.com>

ENV TERM xterm
ENV ARCH ''
ENV RECALBOX_VERSION_LABEL ''
ENV RECALBOX_CCACHE_DIR ''

# Install dependencies
# needed ? xterm
RUN apt-get update -y && \
apt-get -y install build-essential git libncurses5-dev qt5-default qttools5-dev-tools \
mercurial libdbus-glib-1-dev texinfo zip openssh-client libxml2-utils \
software-properties-common wget cpio bc locales rsync imagemagick \
nano vim automake mtools dosfstools subversion openjdk-8-jdk libssl-dev && \
rm -rf /var/lib/apt/lists/*

# Set the locale needed by toolchain
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen

RUN mkdir -p /work
WORKDIR /work

CMD echo ">>> Setting recalbox version to ${RECALBOX_VERSION_LABEL}" && echo "${RECALBOX_VERSION_LABEL}" > board/recalbox/fsoverlay/recalbox/recalbox.version && \
    echo ">>> Fetching and reseting buildroot submodule" && ( git submodule init; git submodule update; cd buildroot && git reset HEAD --hard && git clean -dfx ) && \
    echo ">>> Making recalbox-${ARCH}_defconfig" && make recalbox-${ARCH}_defconfig && \
    export RECALBOX_CCACHE=${RECALBOX_CCACHE_DIR:+"BR2_CCACHE=y BR2_CCACHE_DIR=$RECALBOX_CCACHE_DIR BR2_CCACHE_INITIAL_SETUP=--max-size=500G BR2_CCACHE_USE_BASEDIR=y"} && \
    echo ">>> Make with cache : ${RECALBOX_CCACHE}" && \
    RECALBOX_VERSION=${RECALBOX_VERSION_LABEL} make BR2_DL_DIR="/share/dl" BR2_HOST_DIR=/share/host $RECALBOX_CCACHE
