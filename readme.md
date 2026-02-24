
# 合宿用ルータのイメージ

## 概要

[astro/nix-openwrt-imagebuilder](https://github.com/astro/nix-openwrt-imagebuilder)を利用して、合宿用ルータに必要なドライバやパッケージを同梱したイメージをビルドします。

## 動作要件

- OS: Linux環境(WSL可)
- Nix: flakes, nix-commandが有効化されていること

Nixの導入が済んでいない場合、[こちら](https://docs.determinate.systems/determinate-nix/)を参考に導入してください。

## 実行

構成の名前については、flake.nixを参照してください。\
参考として、2026/02/25現在は`main-router`と`sub-router`が定義されています。
> [!NOTE]
> パッケージリポジトリのメタデータ取得の実行中に、404などのエラーが発生しても気にせず続けてください。\
> スクリプトの戻り値が0であれば正常に完了しています。

1. パッケージリポジトリのメタデータを取得する\
   新しいバージョンのOpenWrtを利用する場合や、ハッシュの不一致でビルドエラーが出た際に実行してください。\
   使用するOpenWrtのバージョンについては、flake.nix内のそれぞれの構成を参照してください。\
   バージョンを指定しない場合、その時の最新のStableバージョンを指定したものとして実行されます。\
   `$ ./update-builder.sh [OpenWrtのバージョン]`
3. OpenWrtイメージのビルド\
   ビルド成果物については、`result`フォルダ以下に作成されます。\
   `$ ./build-router.sh <ビルドする構成の名前>`
4. イメージの展開\
   WSLでUSBメモリ等に焼く場合、openwrt-\<version>-\<アーキテクチャ>-generic-squashfs-combined-efi.img.gzを解凍し、焼いてください\
   `$ zcat result/openwrt-<version>-<アーキテクチャ>-generic-squashfs-combined-efi.img.gz | sudo dd of=<USBメモリ> bs=4M status=progress`
  
