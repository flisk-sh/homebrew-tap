# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.63"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.63/flisk-darwin-arm64"
      sha256 "62e109d218ffd76e220fc2b4da81b43f2e00c6d7ab47cfb9843177e73e57b122"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.63/flisk-darwin-amd64"
      sha256 "0a914c5bbce6cd2cff3e9eb568c1c9127a0917fc83d59beee30e7e1c31c3dfaa"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.63/flisk-linux-arm64"
      sha256 "17862bfc97b05d81b24b6d7e172dd266d3c2b82c38288ed32f16e2cf8e51d33e"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.63/flisk-linux-amd64"
      sha256 "e8c96cc916fd0dfae56c0ceab2962bbada2520ffd9ae1e82e5ac30de082f8137"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.63/flisk-cli-engine.tar.gz"
    sha256 "7ef9faeef8715edbab575776ded79542df3ed4f0f47ee3a9946032525aba922b"
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
