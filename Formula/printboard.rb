class Printboard < Formula
  desc "Print the Enabler project board's papers at the right size, count, and version"
  homepage "https://github.com/jcalixte/board-setup"
  url "https://github.com/jcalixte/board-setup/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "1e386bec61817f99ff5ddb68fd3ebfc76eec38fb04f6ee22057e80afdbd2c44b"
  license "MIT"

  depends_on "ghostscript"    # gs — scale each page to its exact A3/A4 size before printing
  depends_on "poppler"        # pdftotext — read slide titles from the export
  depends_on "python@3.12"
  depends_on "rclone"         # export the org-restricted Slides deck to PDF

  def install
    # Ship the script and the default manifest together (the manifest carries the
    # board deck url); the script finds it next to itself, or in ~/.config/printboard/.
    libexec.install "printboard", "manifest.json"
    (bin/"printboard").write_env_script libexec/"printboard",
                                         PATH: "#{formula_opt_bin("python@3.12")}:$PATH"
  end

  def caveats
    <<~EOS
      One-time per user (the deck is org-restricted):
        printboard setup
        printboard doctor

      setup authorises rclone (read-only), then shows the board deck and asks you to
      confirm it — press Enter. To print from another deck, answer n and paste its URL
      (or pass --deck "<URL or id>"): that saves a doc_id override to
      ~/.config/printboard/config.json. If your Workspace blocks third-party OAuth
      apps, create your own OAuth client in Google Cloud Console and re-run
      `rclone config`.
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/printboard --help")
  end
end
