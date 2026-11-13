# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.62"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.62/flisk-darwin-arm64"
      sha256 "b985f99bb8034930077c7aabc56ac98d65df35cb70c306e88cb703a87dbb9961"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.62/flisk-darwin-amd64"
      sha256 "ca1408fdeaa39bc89559bfbed9d51c70c7f78fef93a2c69a742103b5a54ed7e7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.62/flisk-linux-arm64"
      sha256 "cd8235f7c59bfd962f7e80fde67be3469a2df5bfb7fefe87dac311ff6a55777d"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.62/flisk-linux-amd64"
      sha256 "cad52424322e43ca4f4540efa5d1f43e86da8a55992df564cf1d160d21ee2612"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.62/flisk-cli-engine.tar.gz"
    sha256 "68c8204a993d29db969465f57ba741602eeb12d88ad4ee38e08a602dcc419c4a"
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
