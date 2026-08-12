class Starkit < Formula
  desc "Keyboard-summoned launcher for personal automations, written in Gleam"
  homepage "https://github.com/jcalixte/starkit"
  url "https://github.com/jcalixte/starkit/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "290d00b50a3f7ebc39d5e4b02442599ca8a9b41169e3278f9f8e8ebded3afcfd"
  license "MIT"

  # `gleam` compiles the Scripts on save. `bun` runs the artefacts and is deliberately *not* a
  # dependency: Starkit borrows its toolchain from the login shell's PATH and resolves it at every
  # launch, so pinning a second bun in the Cellar would install ~90 MB that the app may never pick.
  # A missing one is named by install.sh rather than guessed at.
  depends_on "gleam"
  depends_on macos: :sonoma

  # The source tree, not a built app. Everything Homebrew cannot do — signing with your login
  # keychain, writing to /Applications, registering the login item, seeding ~/.starkit — is
  # deferred to `starkit-install`, which runs the repo's own scripts rather than a copy of their
  # logic that would drift from them.
  def install
    libexec.install Dir["*"]

    (bin/"starkit-install").write <<~SH
      #!/usr/bin/env bash
      set -euo pipefail

      if ! command -v swift >/dev/null 2>&1; then
        echo "! Starkit builds from source and the Swift toolchain is missing." >&2
        echo "  Run: xcode-select --install" >&2
        exit 1
      fi

      # Copied out of the Cellar: `swift build` writes .build/ next to Package.swift, and a
      # brew upgrade would wipe it anyway. A clean tree each time has no stale-state failures.
      work="$(mktemp -d)"
      trap 'rm -rf "$work"' EXIT
      cp -R "#{libexec}/." "$work/"
      cd "$work"

      # Idempotent, and cheap after the first run: it is what keeps the Accessibility grant
      # alive across rebuilds, so it is not something to leave to the reader.
      ./scripts/setup-signing.sh
      ./scripts/install.sh "$@"
    SH

    # `Starkit run <keyword>` is documented in SCRIPTING.md, but the CLI lives inside the bundle
    # and no install puts it on PATH. Only the copy in /Applications is the one ⌃⌘K summons, so
    # the shim points there rather than at anything under the Cellar.
    (bin/"Starkit").write <<~SH
      #!/usr/bin/env bash
      app=/Applications/Starkit.app/Contents/MacOS/Starkit
      if [ ! -x "$app" ]; then
        echo "! Starkit is not installed yet — run starkit-install first." >&2
        exit 1
      fi
      exec "$app" "$@"
    SH
  end

  def caveats
    <<~EOS
      Starkit borrows `gleam` and `bun` from your login shell's PATH rather than pinning them.
      `gleam` came with this formula; install bun first if you have not already:
        brew install bun     # or the installer from bun.sh

      Then, one-time, and again after each `brew upgrade starkit`:
        starkit-install

      It signs the app with a self-signed identity in your login keychain, copies it to
      /Applications, seeds ~/.starkit, and turns on Start at Login. Homebrew cannot do those
      parts: signing needs your keychain, and macOS ties the Accessibility grant to the
      signature — an ad-hoc one changes on every build and silently drops the grant.

      It never overwrites a Script you have edited in ~/.starkit/src/scripts/.

      ⌃⌘K summons the bar. Quit Script Kit first: whichever app registers the chord first keeps
      it, and the loser fails silently. Paste asks for Accessibility the first time a Script
      uses it.
    EOS
  end

  test do
    assert_path_exists libexec/"scripts/install.sh"
    # The bundle identifier build.sh reads back out of the plist it vendors: if this drifted, the
    # app's designated requirement would change and the Accessibility grant would go with it.
    assert_equal "dev.apoena.starkit",
      shell_output("/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' " \
                   "#{libexec}/Resources/Info.plist").strip
    # Not run: the shim execs whatever is in /Applications, so its behaviour depends on whether
    # starkit-install has happened. What is checkable is that it points at the installed bundle.
    assert_match "/Applications/Starkit.app", (bin/"Starkit").read
  end
end
