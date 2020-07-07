#!/bin/bash
docker build -f Dockerfile.$2 --build-arg FFmpegrepo=$1 . -t ffmpeg-builder-ubuntu20