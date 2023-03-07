{ pkgs, ... }: {
  home.packages = with pkgs; [
    gamemode
    heroic
    protonup-ng
    lutris
    prismlauncher
  ];
}
