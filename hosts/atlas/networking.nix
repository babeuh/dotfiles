{ config, pkgs, ... }: {

  networking = {
    # TODO: Maybe rename networking hostname for consistency
    hostName = "atlas";

    useDHCP = true;
    interfaces.enp3s0.useDHCP = true;
  };
}
