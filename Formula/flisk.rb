# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.67"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.67/flisk-darwin-arm64"
      sha256 "92e7b1741ef32023071ac224e953b6b49d8e6de47ed1351081458e49f94fe503"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.67/flisk-darwin-amd64"
      sha256 "55abd4ef94e946efbc492603bba9d2f48b761f5e8ad6b408f694e4e294e02a3b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.67/flisk-linux-arm64"
      sha256 "fda2354d3eb39c1947ad7962dd2139f3b45a1a5f4c52de153591fcdab55cf2d8"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.67/flisk-linux-amd64"
      sha256 "7619b1d9980da1a6f02ffd05ff3bf760e578ac00228b92bc05232a1107e53777"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.67/flisk-cli-engine.tar.gz"
    sha256 "327797abe858481116a8aaeae187416fc2ee7f678496c303cc5fbf80811f0d71"
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
