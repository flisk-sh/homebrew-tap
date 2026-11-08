# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.45"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.45/flisk-darwin-arm64"
      sha256 "7bee8f01ab6589d06c43d8eecd1fe77d7e4bceb5c7a03551e7b6308694b251ac"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.45/flisk-darwin-amd64"
      sha256 "5f7b32cbc4af3ae47b76434895e5e43c771709a5cb9518ada5bb22c3c7f488f0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.45/flisk-linux-arm64"
      sha256 "6dd6be826e4affd97ee57b9256236f5fb797a9c9fe62046d8387c3de0e075eba"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.45/flisk-linux-amd64"
      sha256 "b56d18fdcd4a48a245723f04c34edbb46fdb58e71df847bd9fe28ddb4b3c8a9c"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.45/flisk-cli-engine.tar.gz"
    sha256 "9ef95f9e111b52239d20eba4aa0954d8ce5fb03d249e37d3f28ab21a9f3e50b4"
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
