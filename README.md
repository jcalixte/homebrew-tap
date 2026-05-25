# homebrew-tinyimg

Homebrew tap for [tinyimg](https://github.com/jcalixte/tinyimg) — losslessly
optimize PNG and JPG images with a minimal terminal UI.

## Install

```sh
brew install jcalixte/tinyimg/tinyimg
```

That command auto-taps `jcalixte/homebrew-tinyimg` and installs the formula.

## What gets installed

- `tinyimg` binary in your Homebrew prefix (`/opt/homebrew/bin` on Apple Silicon,
  `/usr/local/bin` on Intel)
- Runtime dependencies: `erlang`, `oxipng`, `jpeg-turbo` (provides `jpegtran`)
- Build-time dependency: `gleam`

## Upgrading

```sh
brew update && brew upgrade tinyimg
```
