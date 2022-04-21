# 🎬 Docker FFmpeg Compiler

Docker FFmpeg Compiler is a simple way to compile the [FFmpeg](https://ffmpeg.org/) binary for your linux system.

## 📝 Getting Started

This project uses [Docker](https://docs.docker.com/get-docker/), therefore it's highly recommended installing it before
continuing. 😉

## 🐋 Usage

The easiest way to get started is by using the available `make` commands , or derive the docker commands directly from
the [Makefile](./Makefile).

<details>
  <summary>🚀 Build</summary>

Build docker image for specified version.

```shell
make build version="snapshot"
```

* This will build an image from the latest `ffmpeg-snapshot` release and copy the `ffmpeg`, `ffprobe` and `ffplay`
  binaries to `$HOME/bin`.
* Substitute `snapshot` with the desired version, e.g. `5.0.1`, to build an image for
  a [specific release](http://ffmpeg.org/releases/?C=M;O=D).

<sub>Note: building the image with the current dependencies may take a while ... 💤</sub>
</details>
<details>
  <summary>🗑️ Remove</summary>

Remove docker image for specified version.

```shell
make remove version="snapshot"
```

</details>

### 🧰 Customise

You can tinker the Dockerfile to your needs by disabling, enabling or adding more features before building the image.

## ⚠️ License

Distributed under the MIT license. See [LICENSE](./LICENSE) for more information.
