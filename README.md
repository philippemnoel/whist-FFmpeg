Fractal README
=============

This repository is Fractal's fork of FFmpeg, with a few modifications.

Before building or modifying the code, you should pull the latest changes from the public [`FFmpeg/FFmpeg`](https://github.com/FFmpeg/FFmpeg) repository that this repository is forked from. To setup your repository, follow these steps: 

1. Clone and enter the repository
```
git clone https://github.com/fractal/FFmpeg && cd FFmpeg
```
2. Add the upstream repository as a remote
```
git remote add upstream https://github.com/FFmpeg/FFmpeg
```
3. Disable pushing to upstream FFmpeg
```
git remote set-url --push upstream DISABLE
```
After this, you should be able to list your remotes with `git remote -v` if you ever need to debug.

Since FFmpeg is a large and active project, we will very often want to work with the latest upstream code; meanwhile, we need to make sure that our own repository has a sane commit history -- we cannot simply periodically merge the latest FFmpeg on top of our own modifications.

Instead, perform the following steps to incorporate changes from upstream:

1. Fetch the latest changes to the `upstream` remote
```
git fetch upstream
```
2. Rebase on top of your current work
```
git rebase upstream/master
# git rebase upstream/<desired branch> for other upstream branches
```
3. Resolve merge conflicts, if any arise, and push to the Fractal FFmpeg repository
```
git push origin <current branch>
```

## Fractal Changelog

Here's a list of modifications we have made to the original FFmpeg fork:

- Add 0RGB32 Cuda resizing to the `scale_cuda` filter (to replace `sw_scale` entirely in the Nvidia GPU) 

We have also added a Docker script to compile FFmpeg targeting Emscripten, the web-assembly compiler tool we use to compile the Fractal client to run in the browser, and Docker scripts to compile FFmpeg on Linux Ubuntu 18.04 and Linux Ubuntu 20.04. 

## Building

### Windows

To build this version of FFmpeg for Windows, refer to the Fractal repository [`ffmpeg-windows-build-helpers`](https://github.com/fractal/ffmpeg-windows-build-helpers).

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
