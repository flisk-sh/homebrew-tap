# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.74"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.74/flisk-darwin-arm64"
      sha256 "643ddeba3cf8f33d5a08bcc6281e4c60088c8a03f34195ddcb9732f859af9215"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.74/flisk-darwin-amd64"
      sha256 "b15feb7c1496651cf22c5033d338611a80576047e7ac3677afb60e4f4b033bb2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.74/flisk-linux-arm64"
      sha256 "7699a09b13d5672484b076dd195a6edfe2affb2f38b30c11cc881cc517c92ecb"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.74/flisk-linux-amd64"
      sha256 "bcf53da81bf3117fd976fbd000926a08ed3d0448ebee501666ac72f18cdf5e42"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.74/flisk-cli-engine.tar.gz"
    sha256 "b3d321a2d8298a01939ca997af114bdfcc38f7d58220d8e8029024af99e6f1c5"
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
