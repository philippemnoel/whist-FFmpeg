#!/bin/bash

docker pull gcc:4
docker run -it \
    -v $PWD:/usr/src \
    gcc:9.1 \
    sh -c 'cd /usr/src && ./configure --disable-x86asm && make -j'
