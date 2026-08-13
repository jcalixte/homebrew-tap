cask "starkit" do
  version "0.2.0"
  sha256 "e3d5076705efc6582db9fac68c56b81e03e16eefbabdeff8adcd151ac9b20221"

  url "https://github.com/jcalixte/starkit/releases/download/v#{version}/Starkit-#{version}.zip",
      verified: "github.com/jcalixte/starkit/"
  name "Starkit"
  desc "Keyboard-summoned launcher for personal automations, written in Gleam"
  homepage "https://github.com/jcalixte/starkit"

  # gleam compiles the Scripts on save. bun runs them, and is deliberately absent: Starkit borrows
  # its toolchain from the login shell and resolves it at every launch, so pinning a second bun in
  # the Cellar would install ~90 MB the app may never pick. A missing one turns the menu bar icon red
  # and names itself, which is the same answer a source install gives.
  depends_on formula: "gleam"
  depends_on macos: :sonoma

  app "Starkit.app"

  # A running bundle cannot be replaced underneath itself, and the instance holding ⌃⌘K has to be the
  # one that was just installed.
  uninstall quit:       "dev.apoena.starkit",
            login_item: "Starkit"

  # ~/.starkit is deliberately not zapped. It is where your Scripts live — the half of the home an
  # install never touches — and `brew uninstall --zap` is not the place to delete source you wrote.
  zap trash: [
    "~/Library/Caches/dev.apoena.starkit",
    "~/Library/Preferences/dev.apoena.starkit.plist",
  ]

  caveats <<~EOS
    Starkit borrows `gleam` and `bun` from your login shell's PATH. `gleam` came with this cask;
    install bun if you have not already:
      brew install bun     # or the installer from bun.sh

    First launch seeds ~/.starkit, builds the Scripts, and turns on Start at Login. The first build
    resolves dependencies, so it is slow — the menu bar item says so while it runs.

    ⌃⌘K summons the bar. Quit Script Kit first: whichever app registers the chord first keeps it,
    and the loser fails silently. Paste asks for Accessibility the first time a Script uses it.
  EOS
end
