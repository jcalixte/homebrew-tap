class Printboard < Formula
  desc "Print the Enabler project board's papers at the right size, count, and version"
  homepage "https://github.com/jcalixte/board-setup"
  url "https://github.com/jcalixte/board-setup/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f1b922cf3558af4eb6f15e704bd8fa1d0ced8d8f2fcc75e20e01d0cae497175e"
  license "MIT"

  depends_on "poppler"        # pdftotext — read slide titles from the export
  depends_on "python@3.12"
  depends_on "rclone"         # export the org-restricted Slides deck to PDF

  def install
    # Ship the script and the (doc_id-free) default manifest together; the script
    # finds the manifest next to itself, or ~/.config/printboard/manifest.json.
    libexec.install "printboard", "manifest.json"
    (bin/"printboard").write_env_script libexec/"printboard",
                                         PATH: "#{formula_opt_bin("python@3.12")}:$PATH"
  end

  def caveats
    <<~EOS
      One-time per user (the deck is org-restricted):
        printboard setup --deck "<Google Slides URL or id>"
        printboard doctor

      setup authorises rclone (read-only) and saves the deck id to
      ~/.config/printboard/config.json (it is never shipped in the formula). If your
      Workspace blocks third-party OAuth apps, create your own OAuth client in Google
      Cloud Console and re-run `rclone config`.
    EOS
  end

  test do
    assert_match "usage", shell_output("#{bin}/printboard --help")
  end
end
