# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.75"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.75/flisk-darwin-arm64"
      sha256 "4b9e9823e9377e0ca6a0d7e86dbddecda98698bd9deca03428c42d032fa1213a"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.75/flisk-darwin-amd64"
      sha256 "9d100a18e3eea0482d3c4aacf976f94e08232fccf1a1f40c792c1781c4afe73c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.75/flisk-linux-arm64"
      sha256 "aa070b7e7c1f6070623f22c34e3f06f0a50aaa6b9bec977d28032b074bccf26c"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.75/flisk-linux-amd64"
      sha256 "757fe46eea249a5ffd19ba788c4bb9827be85d5fb10538dad1fd2d5c6e27dee8"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.75/flisk-cli-engine.tar.gz"
    sha256 "d06d8775050f3c8c3a752669971a62d6f0577189e6521b7ae65a299aca10056c"
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
