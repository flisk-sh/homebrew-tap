# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.43"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.43/flisk-darwin-arm64"
      sha256 "976042c0f6b02e27171a5c2b0071d75699ba50501c10232ebe5929238d82b8ce"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.43/flisk-darwin-amd64"
      sha256 "9731fd39655ff43c4212909664b5537a33347d9155531c8125d8a48e8b0ed2d2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.43/flisk-linux-arm64"
      sha256 "9109304b76d14d212a0271ff0247085bbbfc2a45d18e9b92f83bd920e951b64d"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.43/flisk-linux-amd64"
      sha256 "d9f7d73ffa9265c837eb8a1b794bc45e1e3b6c3c981c3c395634ac1766280fa8"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.43/flisk-cli-engine.tar.gz"
    sha256 "ffea830a85674866a5988b5c58bef2792ea9bd78fe47d03eb5de49fe49e1429e"
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
