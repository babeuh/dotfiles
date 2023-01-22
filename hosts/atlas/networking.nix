{ config, pkgs, ... }: {
  networking = {
    # TODO: Maybe rename networking hostname for consistency
    hostName = "atlas";
    firewall.enable = true;
    useDHCP = true;
    interfaces.enp3s0.useDHCP = true;
    wireguard.enable = true;
  };
  services.mullvad-vpn.enable = true;
}
