FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y upgrade && apt-get -y clean

RUN apt-get -y install build-essential autoconf automake libtool git pkg-config yasm
RUN apt-get -y install frei0r-plugins-dev
RUN apt-get -y install libfdk-aac-dev

# intel mediasdk
RUN apt-get -y install curl lsb-release
RUN curl -L -s https://github.com/Intel-Media-SDK/MediaSDK/releases/download/intel-mediasdk-20.1.1/MediaStack.tar.gz | tar xz \
&& cd MediaStack && ./install_media.sh


RUN apt-get -y install libssl-dev && apt-get install -y cmake
# intel gmm
RUN git clone https://github.com/intel/gmmlib && cd gmmlib && mkdir build && cd build \
    && cmake .. && make -j6 && make install

# libva
RUN apt-get -y install libdrm-dev
RUN git clone https://github.com/intel/libva && cd libva && ./autogen.sh \
    && make -j6 && make install

RUN apt-get -y install libpciaccess-dev

# now we can finally get intel media driver for VAAPI
RUN git clone https://github.com/intel/media-driver && mkdir build_media && cd build_media \
    && cmake ../media-driver && make -j6 && make install

#This might be a problem right here
# sudo reboot now
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/lib/x86_64-linux-gnu/"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/intel/mediasdk/lib64
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/opt/intel/mediasdk/lib64/pkgconfig


RUN apt-get -y install libopencore-amrnb-dev && \
 apt-get -y install libopencore-amrwb-dev && \
 apt-get -y install libvo-amrwbenc-dev && \
 apt-get -y install libx264-dev && \
 apt-get -y install libx265-dev && \
 apt-get -y install mesa-common-dev && \
 apt-get -y install nvidia-cuda-toolkit
#  ln -s /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/x86_64-linux-gnu/libGL.so.1.0.0

RUN env
RUN git clone https://github.com/ffmpeg/nv-codec-headers && cd nv-codec-headers \
    && make && make install

# potentially others needed?
# RUN apt-get purge libavcodec libavdevice
RUN apt autoremove

VOLUME ["/FFmpeg"]

ARG FFmpegrepo
COPY $FFmpegrepo /FFmpeg

ADD docker-build-scripts/build_ffmpeg.sh /
RUN chmod +x /build_ffmpeg.sh
RUN /build_ffmpeg.sh
# RUN git clone https://github.com/fractalcomputers/FFmpeg && cd FFmpeg \
#     ./configure --enable-version3 --disable-debug --arch=x86_64 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-opengl --enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libmfx --enable-gpl --enable-frei0r --enable-filter=frei0r --enable-libx264 --enable-libx265 --extra-cflags=-O3 --enable-shared --disable-static --enable-nonfree --enable-libfdk-aac --enable-filter=scale_cuda \
#     make -j8 && rm -rf linux-build && mkdir linux-build \
#     find . -name "*.so" | xargs -I % cp % linux-build/ \
#     make install && ldconfig
# eventually we won't need to do the below

# make install
# sudo ldconfig # to register the new ffmpeg install to the linker

