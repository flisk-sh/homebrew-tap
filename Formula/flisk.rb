# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.68"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.68/flisk-darwin-arm64"
      sha256 "a839a0ad5a5554d9ba55793801ee0e40f45ae88e0d47b87fcbb5c72bfa215a6f"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.68/flisk-darwin-amd64"
      sha256 "e099396aa9485dbdcef5b22485b79d212e8ff79b9503d27011363cd4ac5c2e38"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.68/flisk-linux-arm64"
      sha256 "bc9fabfb781ed1b809f4bccb3a955e177701c6d6629bebf8a6345e2d86453cbc"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.68/flisk-linux-amd64"
      sha256 "3d354c8fb33cee5d03d3393947a5dd097dd23b01e7b355c2a4136718e31a5129"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.68/flisk-cli-engine.tar.gz"
    sha256 "de6b4c0f67b0a4b8b2260f19ebeba6bcf23e833b56745f72bcd5e15eb025c884"
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
