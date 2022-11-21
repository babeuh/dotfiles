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

    nix-colors.url = "github:misterio77/nix-colors";
    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
  };

  outputs = { self, nixpkgs, home-manager,  ... }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in rec {
      # Your custom packages and modifications
      overlays = {
        default = import ./overlay { inherit inputs; };
        nur = inputs.nur.overlay;
        arkenfox = inputs.arkenfox.overlay;
      };

      nixosModules = import ./modules/nixos;
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
        import nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          # NOTE: Set `nixpkgs.config` here, it won't work elsewhere
          # NOTE: Need to allow every unfree package here
          config.allowUnfreePredicate = pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "nvidia"
              "nvidia-x11"
              "nvidia-settings"
              "discord"
              "steam"
              "steam-original"
              "steam-runtime"
              "steam-run"
            ];
        });

      nixosConfigurations = {
        atlas = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages."x86_64-linux";
          specialArgs = { inherit inputs outputs; };
          modules = builtins.attrValues nixosModules ++ [ ./hosts/atlas ];
        };
      };

      homeConfigurations = {
        # Desktop
        "babeuh@atlas" = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = builtins.attrValues homeManagerModules ++ [ ./home/babeuh ];
        };
      };
    };
}
