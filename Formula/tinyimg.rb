class Tinyimg < Formula
  desc "Losslessly optimize PNG and JPG images with a minimal terminal UI"
  homepage "https://github.com/jcalixte/tinyimg"
  url "https://github.com/jcalixte/tinyimg/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "ec47b17677bbb9905bab2ed9b65105f38d48172a8828eac1815d707e831aba75"
  license "MIT"

  depends_on "gleam" => :build
  depends_on "erlang"
  depends_on "jpeg-turbo"
  depends_on "oxipng"

  def install
    system "gleam", "export", "erlang-shipment"
    libexec.install Dir["build/erlang-shipment/*"]

    (bin/"tinyimg").write <<~SH
      #!/usr/bin/env bash
      exec "#{libexec}/entrypoint.sh" run "$@"
    SH
  end

  test do
    assert_match "1.3.1", shell_output("#{bin}/tinyimg --version")
  end
end
