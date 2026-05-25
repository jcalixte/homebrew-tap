class Tinyimg < Formula
  desc "Losslessly optimize PNG and JPG images with a minimal terminal UI"
  homepage "https://github.com/jcalixte/tinyimg"
  url "https://github.com/jcalixte/tinyimg/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "889af923648ac99d3fb9612e15221fee5905934d8955482698e70f28d404abc4"
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
    assert_match "1.2.0", shell_output("#{bin}/tinyimg --version")
  end
end
