# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.65"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.65/flisk-darwin-arm64"
      sha256 "d8cbce7387299e21d470041bbdf70b9c3d679bddc4a096327778f7a236afafb2"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.65/flisk-darwin-amd64"
      sha256 "5a4123580550a359c82a8026516205d84f3ec77a50ae06f795cc759e561ea5f7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.65/flisk-linux-arm64"
      sha256 "d9694a725af09ef80e12ce41750fb9059d17098b00697a7334de2fde2aa939a3"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.65/flisk-linux-amd64"
      sha256 "4006ecfb09efa254d588242c1b1ef2e7c87100e70f5f1f4a0ae1770b2c7a211d"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.65/flisk-cli-engine.tar.gz"
    sha256 "7deed6e8cc44aeef5464a07f988a8830e522a95f58f131b92efd889a848e1432"
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
