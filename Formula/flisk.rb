# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.61"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.61/flisk-darwin-arm64"
      sha256 "327280c11968df7f1eb318c164f44b61fa9e469cf6d790faceecc376de446df8"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.61/flisk-darwin-amd64"
      sha256 "204be885b702f438315dc3f7142a4ee5f5ad4983d378d93aaa0947495510a569"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.61/flisk-linux-arm64"
      sha256 "57be224a12d4326afcd9735a957bfe87b50a6ee555e41e251dfa4520b9b05059"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.61/flisk-linux-amd64"
      sha256 "0db6a162c3b975d0abf3f4adaa7e47ba9129db93d873cab1ad611edd9e8a9760"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.61/flisk-cli-engine.tar.gz"
    sha256 "cb9d9efc07a978a383b3483b2c0c9d96ec1574cbd73c981c7cad085498d7a84b"
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
