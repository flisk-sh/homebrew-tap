# Homebrew tap for Flisk

Install the [Flisk CLI](https://flisk.sh) on macOS or Linux:

```bash
brew install flisk-sh/tap/flisk
```

Upgrade with `brew upgrade flisk`.

The formula installs the same prebuilt binary and bundled engine as the [official installer](https://flisk.sh/install.sh), from [flisk-sh/releases](https://github.com/flisk-sh/releases/releases), checked against that release's `checksums.txt`.

Each hour, [a workflow](.github/workflows/update.yml) looks for a new release. It installs and tests the new formula on macOS (Apple Silicon and Intel) and Linux (x86-64) before pushing it. Linux on ARM uses the same formula, but that platform is not tested here.

`Formula/flisk.rb` is written by `scripts/update-formula.sh`. To change it, change the script.

Bugs in Flisk itself go to [flisk-sh/flisk](https://github.com/flisk-sh/flisk/issues).
