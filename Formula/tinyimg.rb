class Tinyimg < Formula
  desc "Losslessly optimize PNG and JPG images with a minimal terminal UI"
  homepage "https://github.com/jcalixte/tinyimg"
  url "https://github.com/jcalixte/tinyimg/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "2f7db303f4c8060f39027ed2edb2545a03b557394806e3e0256aa6d89a088753"
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
    assert_match "1.3.0", shell_output("#{bin}/tinyimg --version")
  end
end
