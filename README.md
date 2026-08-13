# homebrew-tap

Personal Homebrew tap. Currently ships:

- **[tinyimg](https://github.com/jcalixte/tinyimg)** — losslessly optimize PNG
  and JPG images with a minimal terminal UI.
- **[printboard](https://github.com/jcalixte/board-setup)** — print the Enabler
  project board's papers at the right size, count, and version. Needs
  `printboard setup --deck "<url>"` once, because the deck is org-restricted.
- **[starkit](https://github.com/jcalixte/starkit)** (cask) — keyboard-summoned
  launcher for personal automations, written in Gleam. Notarized, so it opens
  without the right-click-open dance. Needs `bun` on your `PATH`;
  `brew info --cask starkit` says why it is not a dependency.

## Install

```sh
brew install jcalixte/tap/tinyimg
```

That command auto-taps `jcalixte/homebrew-tap` and installs the formula.

## What gets installed

- `tinyimg` binary in your Homebrew prefix (`/opt/homebrew/bin` on Apple Silicon,
  `/usr/local/bin` on Intel)
- Runtime dependencies: `erlang`, `oxipng`, `jpeg-turbo` (provides `jpegtran`)
- Build-time dependency: `gleam`

## Upgrading

```sh
brew update && brew upgrade tinyimg
```
