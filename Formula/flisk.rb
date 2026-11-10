# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.49"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.49/flisk-darwin-arm64"
      sha256 "1dd01b6a2b14b4963f968892025bde99c28ed79ec4ebaa44bcc3644a1a4f2b86"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.49/flisk-darwin-amd64"
      sha256 "84ec1f2ebc641be79e1dfd380e81da70a02bd01f1526a7309fecfaaec16d0e4e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.49/flisk-linux-arm64"
      sha256 "a632590f570e56b248d3a8d19c2baf9caf1cbed11779652e2b58d7deddc6db56"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.49/flisk-linux-amd64"
      sha256 "088a859227c7550403ad973b81b2abb5417cb6bfc2826a61a81072dc2237b2ce"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.49/flisk-cli-engine.tar.gz"
    sha256 "30b675c8259f6e5080015650b0a0143b994239be98de93413d37ea4d316fcb65"
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
