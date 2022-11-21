{ pkgs, config, ... }: {
  config.fontProfiles = {
    enable = true;
    monospace = {
      family = "Hack Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "Hack" ]; };
    };
    regular = {
      family = "Hack";
      package = pkgs.hack-font;
    };
  };
}
