# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.44"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v#{version}/flisk-darwin-arm64"
      sha256 "570bbc016d3d38244aa5c254ab0f7824579aafc0d3c3f0466b0ce09eff68b47b"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v#{version}/flisk-darwin-amd64"
      sha256 "90546c2b86da9619fe64ac82b85738abb534bb7916253862f75def4b7ee6f875"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v#{version}/flisk-linux-arm64"
      sha256 "db49d6a90d6ed17c29fa8c07d957cbf43d58e117d39dec6970dbc042a9ab4ab6"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v#{version}/flisk-linux-amd64"
      sha256 "0a54560c4e089e80bee56b648ed8cc050adbc9018dcf676edc658f59282c5061"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v#{version}/flisk-cli-engine.tar.gz"
    sha256 "c1d06c0f28d34c1eb11233d2d879817b21299bfe01e7c7b7a6e121a94d532eda"
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
