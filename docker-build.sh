#!/bin/bash
# function rel_to_abs_path() {
#     cd $1 && pwd
# }
./build-docker-image.sh . 20
# docker run -it --mount type=bind,source=$(rel_to_abs_path $1 ),destination=/FFmpeg ffmpeg-builder-ubuntu18 
# docker run -it ffmpeg-builder-ubuntu18 /bin/bash