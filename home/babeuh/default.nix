{ inputs, lib, config, pkgs, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    inputs.arkenfox.hmModules.default
    ./cli
    ./desktop/bspwm
  ];

  # nixpkgs.config.allowUnfree = true;

  home = {
    username = "babeuh";
    homeDirectory = "/home/babeuh";
    sessionVariables = {
      NIX_CONFIG = "experimental-features = nix-command flakes";
    };
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
