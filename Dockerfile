FROM ubuntu:22.10

ARG FFMPEG_VERSION

ENV FFMPEG_VERSION=${FFMPEG_VERSION:-snapshot}

MAINTAINER ToshY

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    build-essential \
    wget \
    cmake \
    git-core \
    meson \
    ninja-build \
    nasm \
    yasm \
    meson \
    pkg-config \
    texinfo \
    zlib1g-dev

COPY ./package.list /root

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $(grep -o '^[^#]*' /root/package.list)

# dav1d
RUN mkdir -p ~/ffmpeg_sources \
  && cd ~/ffmpeg_sources \
  && export GIT_SSL_NO_VERIFY=1 \
  && git -C dav1d pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/dav1d.git \
  && mkdir -p dav1d/build \
  && cd dav1d/build \
  && meson setup -Denable_tools=false -Denable_tests=false --default-library=static .. --prefix "$HOME/ffmpeg_build" --libdir="$HOME/ffmpeg_build/lib" \
  && ninja \
  && ninja install

# svt-av1
RUN cd ~/ffmpeg_sources \
  && export GIT_SSL_NO_VERIFY=1 \
  && git -C SVT-AV1 pull 2> /dev/null || git clone https://gitlab.com/AOMediaCodec/SVT-AV1.git \
  && mkdir -p SVT-AV1/build \
  && cd SVT-AV1/build \
  && PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DCMAKE_BUILD_TYPE=Release -DBUILD_DEC=OFF -DBUILD_SHARED_LIBS=OFF .. \
  && PATH="$HOME/bin:$PATH" make \
  && make install

RUN cd ~/ffmpeg_sources \
  && wget -O ffmpeg-$FFMPEG_VERSION.tar.bz2 http://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.bz2 \
  && mkdir -p ffmpeg-$FFMPEG_VERSION \
  && tar xjvf ffmpeg-$FFMPEG_VERSION.tar.bz2 -C ffmpeg-$FFMPEG_VERSION --strip-components=1 \
  && cd ffmpeg-$FFMPEG_VERSION \
  && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
    --prefix="$HOME/ffmpeg_build" \
    --extra-cflags="-I$HOME/ffmpeg_build/include" \
    --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
    --extra-libs="-lpthread -lm" \
    --ld="g++" \
    --bindir="$HOME/bin" \
    --enable-gpl \
    --disable-stripping \
    --disable-libfdk-aac \
    --enable-ladspa \
    --enable-libaom \
    --enable-libass \
    --enable-libbluray \
    --enable-libcaca \
    --enable-libcodec2 \
    --enable-libdav1d \
    --enable-fontconfig \
    --enable-libfreetype \
    --enable-libfribidi \
    --enable-libgme \
    --enable-libjack \
    --enable-libmp3lame \
    --enable-libopenjpeg \
    --enable-libopenmpt \
    --enable-libopus \
    --disable-libpulse \
    --enable-librsvg \
    --enable-librubberband \
    --enable-libshine \
    --enable-libsnappy \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libsvtav1 \
    --enable-libtheora \
    --enable-libtwolame \
    --enable-libvidstab \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxml2 \
    --enable-libxvid \
    --enable-libzvbi \
    --enable-lv2 \
    --enable-omx \
    --enable-openal \
    --enable-opencl \
    --enable-opengl \
    --enable-sdl2 \
    --enable-libdc1394 \
    --disable-libdrm \
    --enable-frei0r \
    --enable-nvenc \
    --enable-static \
    --enable-nonfree \
  && PATH="$HOME/bin:$PATH" make \
  && make install \
  && make distclean \
  && hash -r
