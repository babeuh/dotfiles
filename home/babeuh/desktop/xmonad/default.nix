{ config, pkgs, ... }:
{
  imports = [
    ../common
    ./xidlehook.nix
    ./betterlockscreen.nix
    ./background.nix
    ./scrot.nix
    ./feh.nix
  ];

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = pkgs.writeText "xmonad.hs" ''
        ${builtins.readFile ./config.hs}
      '';
        # TODO: fix this
        #myFocusedBorderColor = "${colorscheme.accent-primary}"
        #myNormalBorderColor = "${colorscheme.bg-primary-bright}"
    };
  };
}
