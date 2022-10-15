
{ inputs, ... }:
let
  inherit (inputs) self home-manager nixpkgs;
  inherit (self) outputs;

  inherit (builtins) attrValues;
  inherit (nixpkgs.lib) nixosSystem genAttrs;
  inherit (home-manager.lib) homeManagerConfiguration;

in
rec {

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
  forAllSystems = genAttrs systems;

  mkSystem =
    { hostname
    , pkgs
    , persistence ? false
    }:
    nixosSystem {
      inherit pkgs;
      specialArgs = {
        inherit inputs outputs hostname persistence;
      };
      modules = attrValues (import ../modules/nixos) ++ [ ../hosts/${hostname} ];
    };

  mkHome =
    { username
    , hostname ? null
    , pkgs ? outputs.nixosConfigurations.${hostname}.pkgs
    , persistence ? false
    , colorscheme ? null
    , wallpaper ? null
    , features ? [ ]
    }:
    homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs outputs hostname username persistence
          colorscheme wallpaper features;
      };
      modules = attrValues (import ../modules/home-manager) ++ [ ../home/${username} ];
    };
}
