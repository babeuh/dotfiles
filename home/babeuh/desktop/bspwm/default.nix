{ config, pkgs, ... }: {
  imports =
    [ ../common ./xidlehook.nix ./betterlockscreen.nix ./background.nix ./rofi.nix ./wm ];

  home.packages = with pkgs; [ scrot feh ];
  home.file."Pictures/backgrounds".source = ./backgrounds;

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
  };
}
