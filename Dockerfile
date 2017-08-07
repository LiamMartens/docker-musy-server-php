FROM liammartens/phalcon
MAINTAINER Liam Martens <hi@liammartens.com>

RUN apk add --update screen nano curl python3 alpine-sdk g++ zlib-dev zlib libjpeg jpeg-dev libpng libpng-dev tiff tiff-dev \
            freetype freetype-dev lcms lcms-dev libwebp libwebp-dev openjpeg openjpeg-dev python3-dev
# for building ffmpeg
RUN apk add --update autoconf automake libass-dev sdl2-dev libtheora-dev libtool libva-dev libvdpau-dev \
            libvorbis-dev xcb-util-dev texinfo wget zlib yasm nasm x264-dev x265-dev fdk-aac-dev@testing lame-dev rtmpdump-dev \
            opus-dev libvpx-dev

RUN mkdir /ffmpeg && cd /ffmpeg && \
    wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && tar xjvf ffmpeg-snapshot.tar.bz2 && \
    cd ffmpeg && \
    ./configure --prefix=/usr \
                --enable-avresample \
                --enable-avfilter \
                --enable-gpl \
                --enable-libmp3lame \
                --enable-librtmp \
                --enable-libvorbis \
                --enable-libvpx \
                --enable-libx264 \
                --enable-libx265 \
                --enable-libtheora \
                --enable-postproc \
                --enable-pic \
                --enable-pthreads \
                --enable-shared \
                --disable-stripping \
                --disable-static \
                --enable-vaapi \
                --enable-libopus \
                --enable-libfreetype \
                --enable-libfontconfig \
                --disable-debug && \
    make && make install && cd / && rm -rf /ffmpeg

RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && rm get-pip.py
RUN pip3 install Pillow

# add rust
RUN apk add rust cargo