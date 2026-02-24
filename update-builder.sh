#!/usr/bin/env bash
set -euo pipefail

# nix-openwrt-imagebuilderをこのディレクトリ直下に置く
REPO_DIR="nix-openwrt-imagebuilder"
REPO_URL="https://github.com/astro/nix-openwrt-imagebuilder"

if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning $REPO_URL..."
    git clone --depth 1 "$REPO_URL" "$REPO_DIR"
fi

pushd "$REPO_DIR" > /dev/null

# 引数があればそれを使用、なければ list-versions の結果を使用
if [ $# -gt 0 ]; then
    VERSION="$1"
    echo "Running release2nix for version: $VERSION"
    nix run .#release2nix -- "$VERSION"
else
    echo "No version specified. Running release2nix for all latest versions..."
    # readme.md の手順に従い、利用可能な全バージョンを対象にする
    nix run .#release2nix -- $(nix run .#list-versions -- -l)
fi

echo "Updating git state in $REPO_DIR..."
git add -A

popd > /dev/null
echo "Done."
