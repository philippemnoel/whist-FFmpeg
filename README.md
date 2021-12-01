Fractal README
=============

[![Build & Publish Fractal FFmpeg](https://github.com/fractal/FFmpeg/actions/workflows/build-and-publish-ffmpeg.yml/badge.svg)](https://github.com/fractal/FFmpeg/actions/workflows/build-and-publish-ffmpeg.yml)

This repository is Fractal's fork of FFmpeg, with a few modifications. We forked SDL so that we can control and optimize it for better integration with the Fractal streaming protocol.

## Fractal Changelog

- Modify `av_malloc` to align data to system pagesize to conform with macOS' Metal API, to avoid unnecessary memory copies from CPU to GPU between video decoding and video rendering with SDL

- Created a GitHub Actions workflow, `build-and-publish-ffmpeg.yml`, to build, test and publish on Windows, macOS and Linux Ubuntu, including configuring proper permissions and linking paths (on macOS, notably)

- Added Docker scripts, mainly `Dockerfile.20`, `docker-build.sh`, `build-docker-image.sh` and `docker-build-scripts/build_ffmpeg.sh`, to compile FFmpeg on Linux Ubuntu 20.04

## Development

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

## Building

To see building in action on all OSes, with the flags currently used in production, you can refer to `build-and-publish-ffmpeg.yml`.

### macOS

To build FFmpeg on macOS, first install Homebrew and the FFmpeg dependencies via `brew install x264 ...`. See `build-and-publish.yml` for the full list of dependencies to install.

Then, run `./configure` with the desired flags. See `build-and-publish.yml` for the full list of flags used in production.

To customize the build, run `./configure --help` or read `configure` to see what flags are available. Finally, run `make`. The libraries will be in the `libavcodec`, `libavdevice`, etc. folders.

### Linux Ubuntu 20.04 (via Docker)

To build FFmpeg targeting Linux Ubuntu 20.04 inside of a Docker container, install and setup `docker` on your machine, then run `./docker-build.sh 20.04`. Currently, only Ubuntu 20.04 is supported, via `Dockerfile.20`, for consistency with our infrastructure in `fractal/fractal`.

The built dynamic libraries will appear in the `docker-builds` folder. The Docker build script contains the flags we use when building on Linux, so if you want to build static libraries or enable/disable different components, you must modify `docker-build.sh`. As above, to see what flags are valid, run `./configure --help` or read the `configure` file.

### Windows

We use Media Autobuild Suite to compile FFmpeg on Windows, whose `media-autobuild_suite.bat` file is the equivalent of `./configure && make` on Unix.

First, clone `https://github.com/fractal/media-autobuild_suite` into `C:\media-autobuild_suite` and `cd` into the folder; our own fork uses our fork of FFmpeg rather than upstream FFmpeg. Then, copy all files except the `.ps1` script in this repository's `.github/workflows/helpers/` to the `build/` directory in `C:\media-autobuild_suite`. You should not need to touch the `.sh` scripts. Configuration is done through `media-autobuild_suite.ini`, `ffmpeg_options.txt`, and `mpv_options.txt`. The `options.txt` files contain compile flags for their respective programs. You should feel free to comment/uncomment flags, and add new ones under the `Fractal-added options` heading, to modify the build settings. Please only enable the minimum required flags, to keep libraries as small as possible. The `.ini` file contains Media Autobuild Suite options. The options in the `.ini` file are documented in `media-autobuild_suite.bat`. Importantly, to build shared or static libraries, you MUST change `ffmpegB2` instead of changing the flags in `ffmpeg_options.txt`.

Then, make sure CUDA is installed. You can install the desired version of CUDA either through the Nvidia website or using the `install_cuda_windows.ps1` script in `.github/workflows/helpers/`. Before running the script, set `$env:cuda` to the desired version you want.

Finally, run `media-autobuild_suite.bat`. The first build will take a while, probably at least an hour, because the batch file also needs to install a lot of packages via `msys2`. The shared libraries will be in `local64/bin-video` and static libraries will be in `local64/lib`.

## Publishing

For every push to `main`, for instance when we pull the latest changes from upstream or if we make changes to FFmpeg and merge to `main`, the shared version of FFmpeg on Windows, macOS and Linux Ubuntu will be built and published to AWS S3, via the GitHub Actions workflow `.github/workflows/build-and-publish-ffmpeg.yml`, from where the Fractal protocol retrieves its libraries. The newly-uploaded FFmpeg libraries and headers will be automatically deployed with the next `fractal/fractal` update. Note that not all header files are needed; see the YAML workflow for which ones the Fractal Protocol uses. **Only stable changes should make it to `main`.**

See the Changelog above for the list of changes on top of the public version of FFmpeg that are incorporated in our internal Fractal version of FFmpeg.

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
