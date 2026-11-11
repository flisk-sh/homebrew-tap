# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.54"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.54/flisk-darwin-arm64"
      sha256 "bc9e1cb8d7ee20bd2de9547850b12c42790ff75d810fffe1e67c1b57b2dc7057"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.54/flisk-darwin-amd64"
      sha256 "395f5e6f8c58b864168a32a843a64d2c5a7524afa515865ec39b49849cd5cf51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.54/flisk-linux-arm64"
      sha256 "e1f1c825457831deed872b790d357c304e5375bb2113db329747cb24a954c21b"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.54/flisk-linux-amd64"
      sha256 "7170e365bec4d66a2350f611dcdc085b08eb4854a338595a0c69b215e1914055"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.54/flisk-cli-engine.tar.gz"
    sha256 "18a050f99520d5716edc564a9e35d61b96dccdd3655a3404b979cbb49402f8de"
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
