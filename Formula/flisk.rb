# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.56"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.56/flisk-darwin-arm64"
      sha256 "3f2d0faf4f1746c71694ada8ea5ff538efeff4653daa89bd94e3608c86552b5a"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.56/flisk-darwin-amd64"
      sha256 "fbb98ffe79ac13bd8b122cc9f312b0e9297248377c72056d2b77a575cd001522"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.56/flisk-linux-arm64"
      sha256 "65658cad9f3e6eccb5658a581f90a563f7861caea5a6d7de3c13831473ab9149"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.56/flisk-linux-amd64"
      sha256 "c627b59ef0cabfc612cdbfd7b21a5759a483822743713dc247fba2f99023f34c"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.56/flisk-cli-engine.tar.gz"
    sha256 "78beed289d12fe9de34df5590f5f42aee9e24b1450b0fd1803f7d092470538e1"
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
