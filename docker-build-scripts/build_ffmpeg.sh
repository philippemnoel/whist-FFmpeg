#!/bin/bash

# Configure and Build FFmpeg on Linux Ubuntu with relevant flags to build shared libs

cd FFmpeg
./configure \
--arch=x86_64 \
--extra-cflags=-O2 \
--disable-programs \
--disable-doc \
--disable-debug \
--disable-sdl2 \
--enable-opengl \
--enable-libopus \
--enable-cuda-nvcc \
--enable-nvenc \
--enable-libmfx \
--enable-pthreads \
--enable-filter=scale_cuda \
--disable-static \
--enable-shared

# Build FFmpeg and move static/shared libs
make -j && rm -rf linux-build && mkdir linux-build
find ./ -type f \( -iname \*.so -o -iname \*.a \) | xargs -I % cp % linux-build/ 
make install && ldconfig
