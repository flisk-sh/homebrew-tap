# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.48"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.48/flisk-darwin-arm64"
      sha256 "18b57db199fb81b556d2abb33d66857b904c66cf42938e3bab055ade0c377435"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.48/flisk-darwin-amd64"
      sha256 "44132c9fc88dcb4042e0b678a40030c5951aef33ace727a8154e1e56c309bba9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.48/flisk-linux-arm64"
      sha256 "794d4327a5e2e5575867a1b7fcdf2742693576ff71403a31cf1e109b8dca46ad"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.48/flisk-linux-amd64"
      sha256 "2d49eccce67c15c4cbe3fdaadb3618f1a6f3c37d5fdc6025cf880c06931c1110"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.48/flisk-cli-engine.tar.gz"
    sha256 "3847e64d45663989d74c32e83f6de596d0f6be2df45204c968c3b692af768af4"
  end

  # The binary carries its program after the executable, so it must not be stripped.
  skip_clean "libexec"

  def install
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    libexec.install "flisk-#{os}-#{arch}" => "flisk"
    chmod 0755, libexec/"flisk"
    (libexec/"flisk-cli").install resource("engine")
    # A wrapper, not a symlink: the binary finds flisk-cli next to its own path.
    bin.write_exec_script libexec/"flisk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flisk --version")
    assert_path_exists libexec/"flisk-cli/shared-platform-engineering/docker-templates"
  end
end
