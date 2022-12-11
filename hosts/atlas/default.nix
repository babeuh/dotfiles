{ inputs, lib, config, pkgs, ... }: {

  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./boot.nix
    ./graphics.nix
    ./networking.nix
    ./audio.nix
    ./syncthing.nix
  ];

  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-run"
        "nvidia"
        "nvidia-x11"
        "nvidia-settings"
      ];
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking.hostName = "atlas";

  users.users = {
    babeuh = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd" ];
    };
  };

  environment = {
    # FIXME: Probably not the right way to do this
    systemPackages = with pkgs; [ openrgb i2c-tools ddccontrol git nano home-manager virt-manager ];

    # FIXME: Definitely not the right way to do this
    sessionVariables = rec {
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      # Steam needs this to find Proton-GE
      STEAM_EXTRA_COMPAT_TOOLS_PATHS =
        "\${HOME}/.steam/root/compatibilitytools.d";
      # NOTE: this doesn't replace PATH, it just adds to it
      PATH = [ "\${XDG_BIN_HOME}" ];
    };

    # FIXME: i have no idea why this is here or what it does (taken from last config)
    # pathsToLink = [ "/libexec" ];
  };
  # Fixes https://nix-community.github.io/home-manager/index.html#_why_do_i_get_an_error_message_about_literal_ca_desrt_dconf_literal_or_literal_dconf_service_literal
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # For steam controller etc.
  # hardware.steam-hardware.enable = true;

  # Enable trash
  services.gvfs.enable = true;

  # Locales and shit
  # TODO: move this to a common file
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  time.timeZone = "Europe/Paris";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.05";

  # shells
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.dnsname.enable = true;
    };
  };
}
