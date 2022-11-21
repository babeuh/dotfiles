{ pkgs, hostname, lib, outputs, ... }: {
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

  home.packages = with pkgs; [ pulseaudio gimp mullvad-vpn gtkcord4 ];
  xdg.mimeApps.enable = true;
}
