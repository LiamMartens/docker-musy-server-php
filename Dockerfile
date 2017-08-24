FROM liammartens/phalcon
MAINTAINER Liam Martens <hi@liammartens.com>

RUN apk add --update screen nano curl alpine-sdk g++ zlib-dev libjpeg jpeg-dev libpng libpng-dev tiff tiff-dev \
            freetype freetype-dev lcms lcms-dev libwebp libwebp-dev openjpeg openjpeg-dev
# for building ffmpeg
RUN apk add --update autoconf automake libass-dev sdl2-dev libtheora-dev libtool libva-dev libvdpau-dev \
            libvorbis-dev xcb-util-dev texinfo wget yasm nasm x264-dev x265-dev lame-dev rtmpdump-dev \
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

# add rust
RUN apk add rust cargo xvfb chromium dbus ttf-freefont udev alsa-lib alsa-utils alsaconf && dbus-uuidgen > /var/lib/dbus/machine-id
# install basic caddy for internal server
RUN curl https://getcaddy.com | bash -s http.cgi,http.cors