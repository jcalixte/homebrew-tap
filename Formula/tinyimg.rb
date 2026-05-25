class Tinyimg < Formula
  desc "Losslessly optimize PNG and JPG images with a minimal terminal UI"
  homepage "https://github.com/jcalixte/tinyimg"
  url "https://github.com/jcalixte/tinyimg/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "81b18b86f65bec8c8c32b259083a1f066582ef0c76945b5a902b5233be8f4c2c"
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
    assert_match "1.1.0", shell_output("#{bin}/tinyimg --version")
  end
end
