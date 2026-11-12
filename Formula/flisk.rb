# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.57"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.57/flisk-darwin-arm64"
      sha256 "80be5f7071be3035e67016e6947b5016cc6df5ee983fe5c274c11615163c3f3a"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.57/flisk-darwin-amd64"
      sha256 "f895226091a8644f5ada7bd9cd3dfb8a17d823684c6cb01c93723caf03391e42"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.57/flisk-linux-arm64"
      sha256 "7ca6c64dfbfaa1db288d59300c3ebabc88eb530dcc4f17f9fdc42c2214cff7eb"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.57/flisk-linux-amd64"
      sha256 "d9e9c77ca450c166f216b92ad0a735147fda14bfb1e35a9c743662d8d4636498"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.57/flisk-cli-engine.tar.gz"
    sha256 "8c3b61afa890910f6ce7e6758a0eae4b03207a1f661fc0aca16ef2777fdbe864"
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
