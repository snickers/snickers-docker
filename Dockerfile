FROM ubuntu:14.04
MAINTAINER Flávio Ribeiro <email@flavioribeiro.com>

# Update apt and install dependencies with multiverse
RUN sh -c "echo 'deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse' >> /etc/apt/sources.list"
RUN apt-get update -qq && apt-get install --force-yes -y -qq mediainfo libfaac-dev libgpac-dev libmp3lame-dev libjpeg-turbo8-dev libtheora-dev \
  libvorbis-dev libx264-dev libvlccore-dev libvlc-dev git make cmake yasm curl && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Install libvpx with VP8/VP9 support
RUN git clone --depth=1 https://chromium.googlesource.com/webm/libvpx && \
  cd libvpx && ./configure --enable-shared && make -j `grep processor /proc/cpuinfo|wc -l` && make install && \
  rm -rf libvpx

# Install ffmpeg with libvpx and enable-shared
RUN git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git && \
  cd ffmpeg && ./configure --enable-shared --enable-swscale --enable-gpl  --enable-libx264 --enable-libvpx \
  --enable-libvorbis --enable-libtheora && make -j `grep processor /proc/cpuinfo|wc -l` && make install && \
  rm -rf ffmpeg

# Install Go
RUN curl -L https://storage.googleapis.com/golang/go1.6.3.linux-amd64.tar.gz | tar -C /usr/local -xzf - && \
  mkdir /go

# Set environment variables for go
ENV GOPATH=/go GOROOT=/usr/local/go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN sh -c "echo '/usr/local/lib' >> /etc/ld.so.conf"
RUN ldconfig
