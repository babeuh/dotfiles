{ config, pkgs, ... }:
#let
#  inherit (config.colorscheme) colors;
#in
{
  programs.alacritty = {
    enable = true;

    settings = {
      font = {
        normal.family = config.fontProfiles.monospace.family;
        normal.style = "Regular";
        bold.family = config.fontProfiles.monospace.family;
        bold.style = "Bold";
        italic.family = config.fontProfiles.monospace.family;
        italic.style = "Italic";
        bold_italic.family = config.fontProfiles.monospace.family;
        bold_italic.style = "Bold Italic";

        size = 10;
      };
      
      window = {
        padding = { x = 5; y = 5; };
        dynamic_padding = false;
        opacity = 1.0;
      };
      
      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      shell = {
        # TODO: make this dynamic
        program = "/home/babeuh/.nix-profile/bin/fish";
      };
      # TODO: fix
      colors = {
        primary = {
          #foreground = "#${colors.base05}";
          #background = "#${colors.base00}";
        };
      };
    };
  };
}
