{ config, pkgs, ... }: {
  imports =
    [ ../common ./xidlehook.nix ./betterlockscreen.nix ./background.nix ./rofi.nix ./wm ];

  home.packages = with pkgs; [ scrot feh ];

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
  };
}
