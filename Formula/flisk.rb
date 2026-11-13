# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.60"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.60/flisk-darwin-arm64"
      sha256 "bc8a7d69ae9d4e27c1ace763f75873a2b60a67ec7fa40bf16a9dd62777f45327"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.60/flisk-darwin-amd64"
      sha256 "9058924b3179ed1cacc13d0d7eb61471813f4c0e9eb38f2e53db2a13b955baae"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.60/flisk-linux-arm64"
      sha256 "93f2192be47826e1f413d66a36704c34411a1f04c7c81f665ee6316925f051a4"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.60/flisk-linux-amd64"
      sha256 "e34bdb654fae2034caae0ba0ca71abca9bc03b9386f464f1f0d4658e21b65e3e"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.60/flisk-cli-engine.tar.gz"
    sha256 "47f165b5867e6a8eceaf14c4aba442e74f82cfcd69f4176ff38d53157b2bd037"
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
