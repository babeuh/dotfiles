{ inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.arkenfox.hmModules.default
    inputs.nixvim.homeManagerModules.nixvim
    ./font.nix
    ../features/cli
  ] ++ (builtins.attrValues outputs.homeManagerModules);

  colorscheme = lib.mkDefault colorSchemes.gruvbox-dark-hard;
  wallpaper = lib.mkDefault ../backgrounds/vettel-years.jpg;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.file.".colorscheme".text = config.colorscheme.slug;

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # Add Caches
      substituters = ["https://hyprland.cachix.org" "https://cache.nixos.org/"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];
    };
  };

  nixpkgs.overlays = lib.mkDefault [
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  home = {
    username = lib.mkDefault "babeuh";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = lib.mkDefault "22.05";
  };
}
