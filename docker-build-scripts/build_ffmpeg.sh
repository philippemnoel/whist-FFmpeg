#!/bin/bash
# Configure and Build FFmpeg on Linux Ubuntu

# Configure FFmpeg with relevant flags to build static libs, add --enable-shared --disable-static to build shared libs
cd FFmpeg
./configure \
--arch=x86_64 --extra-cflags=-O3 \
--enable-gpl --enable-nonfree --enable-version3 \
--disable-programs --disable-doc --disable-debug --disable-sdl2 \
--enable-opengl --enable-frei0r --enable-libfdk-aac --enable-libx264 --enable-libx265 \
--enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc \
--enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libmfx \
	    --enable-filter=frei0r --enable-filter=scale_cuda \
	    --disable-static --enable-shared

# Build FFmpeg and move static/shared libs
make -j8 && rm -rf linux-build && mkdir linux-build
find ./ -type f \( -iname \*.so -o -iname \*.a \) | xargs -I % cp % linux-build/ 
make install && ldconfig
