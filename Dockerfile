FROM ubuntu:14.04
MAINTAINER Flávio Ribeiro <email@flavioribeiro.com>

# Update apt and install dependencies with multiverse
RUN sh -c "echo 'deb http://us.archive.ubuntu.com/ubuntu trusty main multiverse' >> /etc/apt/sources.list"
RUN apt-get update -qq
RUN apt-get install --force-yes -y -qq libfaac-dev libgpac-dev libmp3lame-dev libjpeg-turbo8-dev libtheora-dev \
  libvorbis-dev libx264-dev libvlccore-dev libvlc-dev git build-essential yasm curl

# Install libvpx with VP8/VP9 support
RUN git clone --depth=1 https://chromium.googlesource.com/webm/libvpx
RUN cd libvpx && ./configure --enable-shared && make -j `grep processor /proc/cpuinfo|wc -l` && make install

# Install ffmpeg with libvpx and enable-shared
RUN git clone --depth=1 git://source.ffmpeg.org/ffmpeg.git
RUN cd ffmpeg && ./configure --enable-shared --enable-swscale --enable-gpl  --enable-libx264 --enable-libvpx \
  --enable-libvorbis --enable-libtheora && make -j `grep processor /proc/cpuinfo|wc -l` && make install

# Install Go
RUN curl -O https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz
RUN tar -xvzf go1.6.linux-amd64.tar.gz
RUN mv go /usr/local

# Set environment variables for go
ENV GOROOT /usr/local/go
ENV PATH $PATH:$GOROOT/bin
RUN mkdir /go
ENV GOPATH /go
