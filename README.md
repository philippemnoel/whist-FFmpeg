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

This fork was originally created to add 0RGB32 Cuda resizing to the `scale_cuda` filter (so that we could replace `sw_scale` entirely in the Nvidia GPU), but this has since been taken care of upstream. Right now, there are no FFmpeg source modifications we have made.

We have also added a Docker script to compile FFmpeg targeting Emscripten, the web-assembly compiler tool we use to compile the Fractal client to run in the browser, and Docker scripts to compile FFmpeg on Linux Ubuntu 18.04 and Linux Ubuntu 20.04. 

We have modified the data alignment in `libavutil/mem.c` to force `av_malloc` to align with system pagesize, instead of a fixed number like 16/32. This allows us to shave one memcpy when integrating with SDL's rendering system under Metal on macOS.

## Building

### Windows

To build this version of FFmpeg for Windows, refer to the Fractal repository [`ffmpeg-windows-build-helpers`](https://github.com/fractal/ffmpeg-windows-build-helpers).


      # run this from cmd

      # 1- echo 3 to build for 64-bit systems
      # 2- echo 1 to build non-free dependencies
      # 3- echo 2 to NOT build standalone binaries for libraries included in FFmpeg
      # 4- echo 2 to NOT build VP8/9 encoder
      # 5- echo 2 to NOT build aom
      # 6- echo 2 to NOT build rav1e
      # 7- echo 2 to NOT build dav1d
      # 8- echo 2 to NOT build libavif
      # 9- echo 2 to NOT build jpeg-xl
      # 10- echo 4 to build x264 with lib/binary with 8 and 10-bit, and libavformat and ffms2
      # 11- echo 1 to build x265 with lib/binary with Main, Main10 and Main12
      # 12- echo 1 to build Kvazaar (H.265 encoder)
      # 13- echo 1 to build SVT-HEVC (H.265 encoder)
      # 14- echo 2 to NOT build xvc (HEVC and AV1 competitor)
      # 15- echo 2 to NOT build Fraunhofer VVC (H.265 successor enc/decoder)
      # 16- echo 2 to NOT build SVT-AV1 (AV1 encoder)
      # 17- echo 2 to NOT build SVT-VP9 (VP9 encoder)
      # 18- echo 2 to NOT build FLAC (Free Lossless Audio Codec)
      # 19- echo 1 to build FDK-AAC (AAC-LC/HE/HEv2 codec)
      # 20- echo 2 to NOT build FAAC (old, low-quality and non-free AAC-LC codec)
      # 21- echo 2 to NOT build exhale binary (open-source ISO/IEC 23003-3 USAC, xHE-AAC encoder)
      # 22- echo 2 to NOT build mediainfo binaries (Multimedia file information tool)
      # 23- echo 2 to NOT build sox binaries (Sound processing tool)
      # 24- echo 1 to build STATIC FFmpeg libraries
      # 25- echo 1 to "Always build FFmpeg when libraries have been updated" -- this is irrelevant here since GHA VMs are wiped after runs
      # 26- echo 1 to "Choose ffmpeg and mpv optional libraries"

      # 27- echo "c" to continue with ffmpeg_options.txt file
      # 28- echo "c" to continue with mpv_options.txt file

      # 29- echo 2 to NOT build mp4box (mp4 muxer/toolbox)
      # 30- echo 2 to NOT build rtmpdump binaries (rtmp tools)
      # 31- echo 2 to NOT build static mplayer/mencoder (UNSUPPORTED)
      # 32- echo 2 to NOT build mpv
      # 33- echo 2 to NOT build vlc
      # 34- echo 2 to NOT build bmx
      # 35- echo 2 to NOT build static curl
      # 36- echo 2 to NOT build FFMedia Broadcast binary (UNSUPPORTED)
      # 37- echo 2 to NOT build cyanrip (CLI CD ripper)
      # 38- echo 2 to NOT build redshift (f.lux FOSS clone)
      # 39- echo 2 to NOT build ripgrep (faster grep in Rust)
      # 40- echo 2 to NOT build jq (CLI JSON processor)
      # 41- echo 2 to NOT build jo (CLI JSON from shell)
      # 42- echo 2 to NOT build dssim (multiscale SSIM in Rust)
      # 43- echo 1 to build avs2 (Audio Video Coding Standard Gen2 encoder/decoder)
      # 44- echo 2 to NOT use clang instead of gcc (Recommended)
      # 45- echo 2 to use 2 cores for compilation (GHA VMs have only 2 cores)
      # 46- echo 1 to delete versioned source folders after compile is done
      # 47- echo 1 to strip compiled files binaries
      # 48- echo 2 to NOT pack compiled files
      # 49- echo 1 to write logs of compilation commands
      # 50- echo 2 to NOT create script to update suite files automatically
      # 51- echo 1 to show timestamps of commands during compilation
      # 52- echo 2 to NOT use ccache when compiling
      # 53- echo 1 to disable mintty and print the output to this console




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
