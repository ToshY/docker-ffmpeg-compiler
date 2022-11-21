# 🎬 Docker FFmpeg Compiler

Docker FFmpeg Compiler is a simple way to compile the [FFmpeg](https://ffmpeg.org/) binary for your linux system.

## 📝 Quickstart

### 🐋 Prerequisites

This project requires Docker. See the [Docker installation guide](https://docs.docker.com/get-docker/) to get started.

### 🚀 Setup

The easiest way to get started is by using the [`Makefile`](./Makefile)). Run `make` to see the help.

<details>
  <summary>📦 Container</summary>

### Compile

Build container to compile ffmpeg for version `snapshot`.

```shell
make compile VERSION="snapshot"
```

> Note: You can substitute `snapshot` with the desired version, e.g. `5.1.2`, to build an image for
> a [specific release](http://ffmpeg.org/releases/?C=M;O=D).

### Start

Start container (in detached mode).

```shell
make start VERSION="snapshot"
```

### Stop

Stop container.

```shell
make stop VERSION="snapshot"
```

### Remove

Remove container.

```shell
make remove VERSION="snapshot"
```

</details>
<details>
  <summary>💻️ Host machine</summary>

### Copy

Copy the FFmpeg, FFprobe and FFplay binaries from container to host machine.

```shell
make copy VERSION="snapshot"
```

> Note: This will copy the binaries to the `$HOME/bin` directory on the host machine.

### Install

Install the [`package.list`](./package.list) on host machine.

```shell
make install
```

</details>

### 🧰 Tinker

If you need either more or less libraries for your compiled binaries, you can edit the [`package.list`](./package.list)
and [`Dockerfile`](./Dockerfile) to your
needs before building the image.

## ❕ License

Distributed under the MIT license. See [LICENSE](./LICENSE) for more information.

> Note: The purpose of this repository is purely to show on how to compile FFmpeg with several libraries, disregarding
> library
> specific licenses. Please check the [FFmpeg License and Legal Considerations](https://www.ffmpeg.org/legal.html)
> before compiling and/or using the compiled binary in production.
