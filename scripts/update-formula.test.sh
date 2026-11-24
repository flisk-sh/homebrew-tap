#!/usr/bin/env bash
set -euo pipefail

scripts="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
fixture="$(mktemp -d "$scripts/../.formula-test.XXXXXX")"
trap 'rm -rf -- "$fixture"' EXIT
mkdir -p "$fixture/tap checkout/scripts" "$fixture/caller" "$fixture/bin"
cp "$scripts/update-formula.sh" "$fixture/tap checkout/scripts/"

cat >"$fixture/bin/curl" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
[[ "$*" == '-fsSL https://github.com/flisk-sh/releases/releases/download/v1.2.3/checksums.txt' ]]
printf '%064d  %s\n' 1 flisk-darwin-arm64 2 flisk-darwin-amd64 \
  3 flisk-linux-arm64 4 flisk-linux-amd64 5 flisk-cli-engine.tar.gz
EOF
chmod +x "$fixture/bin/curl"

cd "$fixture/caller"
version="$(PATH="$fixture/bin:$PATH" bash "$fixture/tap checkout/scripts/update-formula.sh" v1.2.3)"
formula="$fixture/tap checkout/Formula/flisk.rb"
if [[ ! -f "$formula" || -e Formula ]]; then
  echo 'Expected the formula in the tap checkout, not the caller directory' >&2
  exit 1
fi
[[ "$version" == 1.2.3 ]]
grep -Fq '  version "1.2.3"' "$formula"
grep -Fq '/v1.2.3/flisk-cli-engine.tar.gz"' "$formula"
grep -Fq "sha256 \"$(printf '%064d' 5)\"" "$formula"
echo 'PASS: generated the requested formula inside the tap checkout'
