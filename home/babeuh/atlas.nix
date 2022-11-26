{ inputs, pkgs, ... }: {
  imports = [ 
    ./global
    ./features/games
    ./features/desktop/bspwm
  ];
  colorscheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;
  wallpaper = ./backgrounds/vettel-years.jpg;
}
