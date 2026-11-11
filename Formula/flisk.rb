# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.52"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.52/flisk-darwin-arm64"
      sha256 "47b21a87ca83b917cc8a73c2d9fa951964af72ef6591bc7481a0a8770f56f19d"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.52/flisk-darwin-amd64"
      sha256 "bdf5fde823373e1f9cb62c11c8328c07bbc322c070185d7213c5555bf4174785"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.52/flisk-linux-arm64"
      sha256 "5a455df735a458b441c61ae98f20f749b2f16b1145d756c2562c432361837ec8"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.52/flisk-linux-amd64"
      sha256 "d490c9126c0c53d14927beed4c043fe9002af3bc1c26db732c88d8e3239d31cf"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.52/flisk-cli-engine.tar.gz"
    sha256 "932f46c8cc0cbbd2864a09f1d86fda8b8d5be9fd3edaf82a90058381de0034d2"
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
