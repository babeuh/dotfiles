{ inputs, outputs, lib, pkgs, ... }: {
  imports = [ 
    ./global
    ./features/distrobox
    ./features/games
    ./features/desktop/hyprland
  ];
  #colorscheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-hard;
  wallpaper = ./backgrounds/vettel-years-pixel-gruvboxish.png;

  # Nixpkgs
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    inputs.nur.overlay
    inputs.arkenfox.overlays.default
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "steam"
    "steam-original"
    "spotify"
    "obsidian"
    "multiviewer-for-f1"
  ];
}
