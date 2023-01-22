{ config, pkgs, ... }: {
  networking = {
    hostName = "atlas";
    firewall.enable = true;

    wireguard.enable = true;
    networkmanager.enable = true;
  };
  services.mullvad-vpn.enable = true;
}
