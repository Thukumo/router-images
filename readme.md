<somewhere>
git clone https://github.com/astro/nix-openwrt-imagebuilder
nix run .#release2nix -- $(nix run .#list-versions -- -l)
git add -A

<here>
nix build --override-input openwrt-imagebuilder git+file://<path-to- nix-openwrt-imagebuilder> .#sub-router
zcat result/openwrt-24.10.5-x86-64-generic-squashfs-combined-efi.img.gz | sudo dd of=/dev/sda bs=4M status=progress
