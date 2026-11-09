# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.46"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.46/flisk-darwin-arm64"
      sha256 "b4905c019ee52cd2085434cf94cec54ee2bbd6998da770970bbe9b593aee9f63"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.46/flisk-darwin-amd64"
      sha256 "52495d415d344eff7766e0bcb34db8b41e5276a0699110bdbfa390dee4970654"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.46/flisk-linux-arm64"
      sha256 "a8a195b7c7c9f14afb412f5b32e371d6026395dd64c442fb0339e529d6459260"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.46/flisk-linux-amd64"
      sha256 "5abe678b289a0fd6969d5ac46efa190cb630427d6399019373657e57bd0d4321"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.46/flisk-cli-engine.tar.gz"
    sha256 "b0802f6c15f342449541dc826cb028d0082b9c0e58948f9cf967aa8dbcb20d54"
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
