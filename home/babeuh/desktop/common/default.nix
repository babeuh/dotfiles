{ pkgs, hostname, lib, outputs, ... }:
let systemConfig = outputs.nixosConfigurations.${hostname}.config;
in {
  imports = [
    ./discord.nix
    ./dragon.nix
    ./firefox
    ./font.nix
    ./gtk.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./qt.nix
    ./alacritty.nix
    ./spotify.nix
    ./keepassxc.nix
    ./dunst.nix
    ./helix.nix
  ];

  home.packages = with pkgs; [ heroic pulseaudio gimp mullvad-vpn gamemode protonup-ng gtkcord4 ];
  xdg.mimeApps.enable = true;
}
