# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "1.4.73"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.73/flisk-darwin-arm64"
      sha256 "663c484507726d933b7357004a87ccd500aa4ef4f830684859201bb1cebeb557"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.73/flisk-darwin-amd64"
      sha256 "afb63394531206e750b6eca26c6d4c1f303179f8a9ce54089b903a98d24215ee"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.73/flisk-linux-arm64"
      sha256 "59b3be45e78af0ed3ec7090aa192715c91c92f48725d0711f527797052b7d907"
    end
    on_intel do
      url "https://github.com/flisk-sh/releases/releases/download/v1.4.73/flisk-linux-amd64"
      sha256 "6cc8ba925d910ff8df7acabb9eeea3cc8250d7b3ffac75f48271a43fe55f28c3"
    end
  end

  resource "engine" do
    url "https://github.com/flisk-sh/releases/releases/download/v1.4.73/flisk-cli-engine.tar.gz"
    sha256 "df2e0c4c8f3b28506d50ad6fe6f55c8abc856dbf30f7fbe6b4ab91cee414a38e"
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
