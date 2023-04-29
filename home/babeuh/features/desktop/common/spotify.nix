{ pkgs, ... }:
let
 spotify = pkgs.makeDesktopItem {
    name = "spotify";
    desktopName = "Spotify";
    exec = "${pkgs.spotifywm}/bin/spotifywm";
  };
in {
  home.packages = [ spotify ];
}
