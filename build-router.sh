#!/usr/bin/env bash
set -euo pipefail

# ビルド対象の構成名 (main-router, sub-router など) を引数から取得
CONFIG_NAME=${1:-}

if [ -z "$CONFIG_NAME" ]; then
    echo "Usage: $0 <config-name>"
    echo "Example: $0 sub-router"
    exit 1
fi

BUILDER_PATH="$(pwd)/nix-openwrt-imagebuilder"

if [ ! -d "$BUILDER_PATH" ]; then
    echo "Error: $BUILDER_PATH が見つかりません。先に update-builder.sh を実行してください。"
    exit 1
fi

echo "Building $CONFIG_NAME using local builder override..."
# readme.md に基づき、ローカルのディレクトリを override-input してビルド
# 絶対パスを使用するために git+file:// を利用
nix build --override-input openwrt-imagebuilder "git+file://$BUILDER_PATH" ".#$CONFIG_NAME"

echo "Build complete. Output image location: $(readlink -f result)"
