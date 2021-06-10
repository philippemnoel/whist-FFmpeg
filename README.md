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

We have also added Docker scripts to compile FFmpeg on Linux Ubuntu 18.04 and Linux Ubuntu 20.04. 

We have modified the data alignment in `libavutil/mem.c` to force `av_malloc` to align with system pagesize, instead of a fixed number like 16/32. This allows us to shave one memcpy when integrating with SDL's rendering system under Metal on macOS.

## Building

After every push to `main`, shared FFmpeg libraries will be built and published to AWS S3, which will be deployed automatically during the next `fractal/fractal` update. **Only stable changes should be deployed to `main`.**

The workflow is in `.github/workflows/build-and-publish-ffmpeg.yml`. The instructions for building on local machines are essentially identical to the publishing workflow, so we describe both below and note any differences. 

After FFmpeg has built libraries successfully, move them into the `fractal/protocol/lib/64/ffmpeg/$OS/` folder and edit `protocol/CMakeLists.txt` accordingly if version numbers have changed. In addition, move the header files for `libavcodec`, `libavdevice`, `libavfilter`, `libavformat`, `libavutil`, `libpostproc`, `libswresample`, and `libswscale` into `fractal/protocol/include/ffmpeg/`. Not all the header files are needed; see the YAML workflow script to see which ones protocol uses.

### macOS

To build FFmpeg on macOS, first install homebrew and the ffmpeg dependencies via
```
brew install \
automake fdk-aac git lame libass libtool libvorbis libvpx \
opus sdl shtool texi2html theora wget x264 x265 xvid nasm
```

Then, run `./configure` with the desired flags. The flags used in the build and publish workflow are
```
./configure \
--prefix=@loader-path --libdir=@loader-path \
--enable-gpl --enable-nonfree --enable-version3 \
--disable-programs --disable-doc --disable-debug --disable-sdl2 \
--enable-opengl --enable-libfdk-aac --enable-libx264 --enable-libx265 \
--enable-videotoolbox --enable-audiotoolbox --enable-pthreads \
--disable-static --enable-shared
```
To customize the build, run `./configure --help` or read `configure` to see what flags are available. Finally, run `make`. The libraries will be in the `libavcodec`, `libavdevice`, etc. folders.

### Linux Ubuntu - Docker

To build FFmpeg targeting Linux Ubuntu inside of a Docker container, install and setup `docker` on your machine, then run `./docker-build.sh X` where `X` is the version of Ubuntu you want to build it inside. Currently, versions 18, for Ubuntu 18.04, and 20, for Ubuntu 20.04, are implemented, created by Dockerfiles `Dockerfile.18` and `Dockerfile.20` respectively. The built dynamic libraries will appear in the `docker-builds` folder. The docker build script contains the flags we use when building on Linux, so if you want to build static libraries or enable/disable different components, you must modify `docker-build.sh`. As above, to see what flags are valid, run `./configure --help` or read the `configure` file.

### Windows

We use Media Autobuild Suite to compile FFmpeg on Windows whose `media-autobuild_suite.bat` file is the equivalent of `./configure && make`. First, clone `https://github.com/fractal/media-autobuild_suite` into `C:\media-autobuild_suite` and `cd` there; our own fork uses our fork of FFmpeg rather than upstream FFmpeg. Then, copy all files except the `.ps1` script in `.github/workflows/helpers/` to the `build/` directory in Media Autobuild Suite. There should be no need to touch the `.sh` scripts. Configuration is done through `media-autobuild_suite.ini`, `ffmpeg_options.txt`, and `mpv_options.txt`. The `options.txt` files contain compile flags for their respective programs; feel free to comment/uncomment flags, and add new ones under the `Fractal-added options` heading. The `.ini` file contains Media Autobuild Suite options. The options in the `.ini` file are documented in `media-autobuild_suite.bat`; importantly, to build shared or static libraries, you MUST change `ffmpegB2` instead of changing the flags in `ffmpeg_options.txt`.

Then, make sure CUDA is installed. You can install the desired version of CUDA either through the Nvidia website or using the `install_cuda_windows.ps1` script in `.github/workflows/helpers/`. Before running the script, set `$env:cuda` to the desired version you want.

Finally, run `media-autobuild_suite.bat`. The first build will take a while, probably at least an hour, because the batch file also needs to install a lot of packages via msys2. The shared libraries will be in `local64/bin-video` and static libraries will be in `local64/lib`.

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
