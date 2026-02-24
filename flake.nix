{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    openwrt-imagebuilder.url = "github:astro/nix-openwrt-imagebuilder";
  };
  outputs =
    {
      self,
      nixpkgs,
      openwrt-imagebuilder,
    }:
    let
      inherit (nixpkgs.lib) mapAttrs;

      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      commonConfig = {
        inherit pkgs;
        target = "x86";
        variant = "64";
        profile = "generic";
        release = "24.10.5";
      };

      routerConfigs = {
        main-router = {
          packages = [
            # Eth driver
            "kmod-usb-net-rtl8152"
            "kmod-usb-net-rndis"
            "kmod-tg3" # x4
            "kmod-r8168" # x1
            "kmod-r8125" # オンボード

            "luci"
            "luci-i18n-base-ja"

            "mwan3"
            "luci-app-mwan3"
            "luci-i18n-mwan3-ja"
          ];
        };
        sub-router = {
          packages = [
            "kmod-usb-net-rtl8152"

            "luci"
            "luci-i18n-base-ja"
          ];
        };
      };
    in
    {
      packages.x86_64-linux = mapAttrs (
        name: cfg: openwrt-imagebuilder.lib.build (commonConfig // cfg)
      ) routerConfigs;
    };
}
