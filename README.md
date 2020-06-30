Fractal README
=============

This repository is Fractal's fork of FFmpeg, with a few modifications. To build this version of FFmpeg for Windows, refer to the [Fractal repository with Windows FFmpeg build tools](https://github.com/fractalcomputers/ffmpeg-windows-build-helpers). To build the Fractal version of FFmepg on Linux Ubuntu, please refer to [this document](https://docs.google.com/document/d/1HsY4_qABX1Drp5TENAqexesnTOvIV4Yv8GIGSDDPSuk/edit).


Before building or modifying the code, you should pull the latest changes from the public `FFmpeg/FFmpeg` repository that this repository is forked from. This ensures we are always working with the latest FFmpeg code. You can do so by cloning this repository and then running:

```
cd FFmpeg
git remote add public https://github.com/FFmpeg/FFmpeg.git
git pull public master # Creates a merge commit
git push origin master
```

Here's a list of modifications we've made to the original FFmpeg fork:
- Add 0RGB32 Cuda resizing to the `scale_cuda` filter (to replace sw_scale entirely in the GPU)

---
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
