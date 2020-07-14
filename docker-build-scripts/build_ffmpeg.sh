#!/bin/bash
cd FFmpeg 
./configure --enable-version3 --disable-debug --arch=x86_64 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-opengl --enable-cuda-nvcc --enable-nvenc --enable-nvdec --enable-libmfx --enable-gpl --enable-frei0r --enable-filter=frei0r --enable-libx264 --enable-libx265 --extra-cflags=-O3 --enable-shared --disable-static --enable-nonfree --enable-libfdk-aac --enable-filter=scale_cuda
make -j8 && rm -rf linux-build && mkdir linux-build
find . -name "*.so" | xargs -I % cp % linux-build/ 
make install && ldconfig
