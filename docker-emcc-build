#!/bin/bash

docker pull trzeci/emscripten:1.38.45
docker run -it \
    --rm \
    -v $PWD:/src \
    trzeci/emscripten:1.38.45 \
    sh -c '''
    cd /src && \
    emconfigure ./configure \
        --disable-x86asm \
        --disable-inline-asm \
        --disable-doc \
        --disable-gpl \
        --enable-static \
        --disable-shared \
        --disable-stripping \
        --enable-zlib \
        --enable-demuxer=image2 \
        --enable-decoder=png \
        --enable-protocol=file \
        --nm="llvm-nm -g" \
        --ar=emar \
        --cc=emcc \
        --cxx=em++ \
        --objcc=emcc \
        --dep-cc=emcc && \
   emmake make -j && \
   rm -rf Emscripten/ && \
   mkdir -p Emscripten/ && \
   cp **/*.a Emscripten/
'''
