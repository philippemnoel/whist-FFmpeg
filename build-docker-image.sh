#!/bin/bash
docker build --build-arg FFmpegrepo=$1 . -t ffmpeg-builder-ubuntu18