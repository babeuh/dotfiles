{ pkgs, hostname, lib, outputs, ... }: {
  imports = [
    ./discord.nix
    ./dragon.nix
    ./firefox
    ./gtk.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./qt.nix
    ./alacritty.nix
    ./spotify.nix
    ./keepassxc.nix
    ./dunst.nix
    ./helix.nix
    ./logseq.nix
  ];

  home.packages = with pkgs; [ pulseaudio gimp mullvad-vpn ];
  xdg.mimeApps.enable = true;
}
