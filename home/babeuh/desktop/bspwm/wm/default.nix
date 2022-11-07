{ config, pkgs, ... }: {
  imports = [ ./sxhkd.nix ./bspwm.nix ./polybar.nix ];

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
  };
}
