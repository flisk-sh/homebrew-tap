# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.47"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.47/flisk-darwin-arm64"
      sha256 "35c94b2095aeafd65da0f726d7821c8901b61906e99cafd16cde4930dc2de79a"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.47/flisk-darwin-amd64"
      sha256 "a3ec28652beb6a0db72dd934c8e56a73beaa292f4c833a02b12e986127f61873"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.47/flisk-linux-arm64"
      sha256 "76a579373a022d02064665bb2ad2f4fbefc4677ecb9fe6aa19fc2059771c8c8b"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.47/flisk-linux-amd64"
      sha256 "d31b7670b1d865ead5b6dd2a8f5f5c3ff6c619b6f67ad7e715df9130a9bec61d"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.47/flisk-cli-engine.tar.gz"
    sha256 "6a12319bcdd28cec86eb7fd1459717c69fd8845b61df7ddcc5139aef1277a453"
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
