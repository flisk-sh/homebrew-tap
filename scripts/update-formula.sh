#!/usr/bin/env bash
# Writes Formula/flisk.rb for a release of flisk-sh/releases.
# Usage: scripts/update-formula.sh [vX.Y.Z]   (default: the latest release)
set -euo pipefail

releases="https://github.com/flisk-sh/releases/releases"

tag="${1:-}"
if [[ -z "$tag" ]]; then
  # /releases/latest redirects to /releases/tag/<tag>, and needs no token.
  tag="$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$releases/latest")"
  tag="${tag##*/}"
fi
[[ "$tag" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || { echo "not a release tag: $tag" >&2; exit 1; }
version="${tag#v}"

checksums="$(curl -fsSL "$releases/download/$tag/checksums.txt")"

sha() {
  local value
  value="$(awk -v name="$1" '$2 == name { print $1 }' <<<"$checksums")"
  [[ "$value" =~ ^[0-9a-f]{64}$ ]] || { echo "no checksum for $1 in $tag" >&2; exit 1; }
  echo "$value"
}

darwin_arm64="$(sha flisk-darwin-arm64)"
darwin_amd64="$(sha flisk-darwin-amd64)"
linux_arm64="$(sha flisk-linux-arm64)"
linux_amd64="$(sha flisk-linux-amd64)"
engine="$(sha flisk-cli-engine.tar.gz)"

base="$releases/download/v#{version}"
mkdir -p Formula
cat >Formula/flisk.rb <<EOF
# Written by scripts/update-formula.sh. Do not edit by hand.
class Flisk < Formula
  desc "Run your whole app locally with one command"
  homepage "https://flisk.sh"
  version "$version"
  license "MIT"

  on_macos do
    on_arm do
      url "$base/flisk-darwin-arm64"
      sha256 "$darwin_arm64"
    end
    on_intel do
      url "$base/flisk-darwin-amd64"
      sha256 "$darwin_amd64"
    end
  end

  on_linux do
    on_arm do
      url "$base/flisk-linux-arm64"
      sha256 "$linux_arm64"
    end
    on_intel do
      url "$base/flisk-linux-amd64"
      sha256 "$linux_amd64"
    end
  end

  resource "engine" do
    url "$base/flisk-cli-engine.tar.gz"
    sha256 "$engine"
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
EOF

echo "$version"
