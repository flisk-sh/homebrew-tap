# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.58"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.58/flisk-darwin-arm64"
      sha256 "b8e01078755bc8152f6dedeec1023ff5a57a500d3c61ea2a17664a9c0e61481c"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.58/flisk-darwin-amd64"
      sha256 "264d828b6b1af5a12915e6ff0b96ef05be0fb8db58fa5a241f2ab35576291204"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.58/flisk-linux-arm64"
      sha256 "1f0d0428563ed444f87aca65729d2ca7a65cebaa9b79cc2f5efe302112b41f87"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.58/flisk-linux-amd64"
      sha256 "52b68b52870ef7a6afd34e1ccb5b31a4fd0ab804b19b65303abc5a79045606e7"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.58/flisk-cli-engine.tar.gz"
    sha256 "199ad1e8d6e449896aaceeffa908d5a3d46323af53d5677aa3037905a2cf3013"
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
