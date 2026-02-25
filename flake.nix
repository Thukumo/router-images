{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    openwrt-imagebuilder.url = "github:astro/nix-openwrt-imagebuilder";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
  };
  outputs =
    inputs@{
      flake-parts,
      systems,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        let
          inherit (inputs.nixpkgs.lib) mapAttrs;

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
          packages = mapAttrs (
            name: cfg: inputs.openwrt-imagebuilder.lib.build (commonConfig // cfg)
          ) routerConfigs;
        };
    };
}
