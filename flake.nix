{
  description = "Nix Config (dotfiles)";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    # TODO: Add any other flake you might need

    # Shameless plug from misterio77: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    arkenfox-userjs = {
      url = "github:arkenfox/user.js";
      flake = false;
    };
  };

  outputs = { nixpkgs, ...}@inputs:
    let
      _lib = import ./lib { inherit inputs; };
      inherit (_lib) mkSystem mkHome forAllSystems;
      lib = nixpkgs.lib;
    in rec {
      # Your custom packages and modifications
      overlays = {
        default = import ./overlay { inherit inputs; };
        nur = inputs.nur.overlay;
      };

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system: {
        default = legacyPackages.${system}.callPackage ./shell.nix { };
      });

      # This instantiates nixpkgs for each system listed above
      # Allowing you to add overlays and configure it (e.g. allowUnfree)
      # Our configurations will use these instances
      # Your flake will also let you access your package set through nix build, shell, run, etc.
      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          # This adds our overlays to pkgs
          overlays = builtins.attrValues overlays;

          # NOTE: Set `nixpkgs.config` here, it won't work elsewhere

          # NOTE: Need to allow every unfree package here
          config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "nvidia"
            "nvidia-x11"
            "nvidia-settings"
            "discord"
          ];
        }
      );

      nixosConfigurations = {
        atlas = mkSystem {
          hostname = "atlas";
          pkgs = legacyPackages."x86_64-linux";
          persistence = true;
        };
      };

      homeConfigurations = {
        # Desktop
        "babeuh@atlas" = mkHome {
          username = "babeuh";
          hostname = "atlas";
          persistence = true;
          
          colorscheme = "gruvbox";
      };
    };
  }; 
}
