Fractal README
=============

This repository is Fractal's fork of FFmpeg, with a few modifications. To build this version of FFmpeg for Windows, refer to the Fractal repository [`ffmpeg-windows-build-helpers`](https://github.com/fractalcomputers/ffmpeg-windows-build-helpers). To build the Fractal version of FFmepg on Linux Ubuntu, please refer to [this document](https://docs.google.com/document/d/1HsY4_qABX1Drp5TENAqexesnTOvIV4Yv8GIGSDDPSuk/edit) for further information, and follow the instructions below to build via Docker.

Before building or modifying the code, you should pull the latest changes from the public `FFmpeg/FFmpeg` repository that this repository is forked from. This ensures we are always working with the latest FFmpeg code. You can do so by running:

```
git clone https://github.com/fractalcomputers/FFmpeg.git && cd FFmpeg
git remote add public https://github.com/FFmpeg/FFmpeg.git
git pull public master
git push origin master
```

Here's a list of modifications we have made to the original FFmpeg fork:
- Add 0RGB32 Cuda resizing to the `scale_cuda` filter (to replace `sw_scale` entirely in the Nvidia GPU) 

We have also added a Docker script to compile FFmpeg targeting Emscripten, the web-assembly compiler tool we use to compile the Fractal client to run in the browser, this allows using FFmpeg in the browser, and Docker scripts to compile FFmpeg on Linux Ubuntu 18.04 and Linux Ubuntu 20.04.

## Building

### Linux Ubuntu - Docker

To build FFmpeg targeting Linux Ubuntu inside of a Docker container, install and setup `docker` on your machine, then run `./docker-build.sh X` where `X` is the version of Ubuntu you want to build it inside. Currently, versions 18, for Ubuntu 18.04, and 20, for Ubuntu 20.04, are implemented, created by Dockerfiles `Dockerfile.18` and `Dockerfile.20` respectively. The built dynamic libraries will appear in the `docker-builds` folder.

### Emscripten

To build targeting Emscripten, install and setup `docker` on your machine, then run `./docker-emcc-build`. The built static library will appear in the root of this directory.

---

FFmpeg README
=============

FFmpeg is a collection of libraries and tools to process multimedia content
such as audio, video, subtitles and related metadata.

## Libraries

* `libavcodec` provides implementation of a wider range of codecs.
* `libavformat` implements streaming protocols, container formats and basic I/O access.
* `libavutil` includes hashers, decompressors and miscellaneous utility functions.
* `libavfilter` provides a mean to alter decoded Audio and Video through chain of filters.
* `libavdevice` provides an abstraction to access capture and playback devices.
* `libswresample` implements audio mixing and resampling routines.
* `libswscale` implements color conversion and scaling routines.

## Tools

* [ffmpeg](https://ffmpeg.org/ffmpeg.html) is a command line toolbox to
  manipulate, convert and stream multimedia content.
* [ffplay](https://ffmpeg.org/ffplay.html) is a minimalistic multimedia player.
* [ffprobe](https://ffmpeg.org/ffprobe.html) is a simple analysis tool to inspect
  multimedia content.
* Additional small tools such as `aviocat`, `ismindex` and `qt-faststart`.

## Documentation

The offline documentation is available in the **doc/** directory.

The online documentation is available in the main [website](https://ffmpeg.org)
and in the [wiki](https://trac.ffmpeg.org).

### Examples

Coding examples are available in the **doc/examples** directory.

## License

FFmpeg codebase is mainly LGPL-licensed with optional components licensed under
GPL. Please refer to the LICENSE file for detailed information.

## Contributing

Patches should be submitted to the ffmpeg-devel mailing list using
`git format-patch` or `git send-email`. Github pull requests should be
avoided because they are not part of our review process and will be ignored.
