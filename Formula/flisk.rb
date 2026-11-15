# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.66"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.66/flisk-darwin-arm64"
      sha256 "5f946ab6a7c85e1b9fd08ae9ba75777ab9f69108b0f76805f563bb343c484e94"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.66/flisk-darwin-amd64"
      sha256 "f2c5279549b5c63447d66e34216c92292c1b12fcc1aa2255b49a8c03a12f0810"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.66/flisk-linux-arm64"
      sha256 "b1b66d5c8ca475a06b36355a1e5b82254927ad901ea65626063e7a1c386fe6f7"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.66/flisk-linux-amd64"
      sha256 "df3aff8ff26548fca4f668a73a85f5aeaafce7f46b5cda789146e5793a17f634"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.66/flisk-cli-engine.tar.gz"
    sha256 "20c9c372ac68cf5b9a690b194ac527540f7c0e02b6a5c2be0c161828a745ad6d"
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
