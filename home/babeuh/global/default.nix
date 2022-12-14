{ inputs, outputs, lib, config, pkgs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    inputs.nix-colors.homeManagerModule
    inputs.arkenfox.hmModules.default
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
