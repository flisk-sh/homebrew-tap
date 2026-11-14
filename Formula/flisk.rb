# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.64"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.64/flisk-darwin-arm64"
      sha256 "971079c13d1f2b8b9a8c7b153ca811406dbe2f60d43a958a3c78e85a38dc5787"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.64/flisk-darwin-amd64"
      sha256 "af4352c046fce7542f1c1d947313e5a26eccf58ffb787d74b8a57b8d2d071c48"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.64/flisk-linux-arm64"
      sha256 "2e2c99a7d6d8c7e998c3adbd4d845f0fe539308a3bac0d211dad53049e58d824"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.64/flisk-linux-amd64"
      sha256 "48cbb9e214e189e2b29e57a6a4bc2a0753575177ef768742a89aa3bbdf0bebf0"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.64/flisk-cli-engine.tar.gz"
    sha256 "8e396df92e6b1c6ac823c5899600786430030fe7ad8cdaa9d33a7dc004c8141f"
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
