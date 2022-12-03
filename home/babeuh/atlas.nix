{ inputs, outputs, lib, pkgs, ... }: {
  imports = [ 
    ./global
    ./features/distrobox
    ./features/games
    ./features/desktop/bspwm
  ];
  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-material-dark-hard;
  wallpaper = ./backgrounds/vettel-years.jpg;

  # Nixpkgs
  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    inputs.nur.overlay
    inputs.arkenfox.overlay
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
  ];
}
