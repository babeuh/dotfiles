{ config, pkgs, ... }: {
  imports = [
    ./sxhkd.nix
    ./bspwm.nix
  ];

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";
  };
}
