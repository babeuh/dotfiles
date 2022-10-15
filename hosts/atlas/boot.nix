{ config, pkgs, ... }: {

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        useOSProber = true;
      };
    };

    initrd.luks.devices = {
      root = {
        device = "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
    kernelModules = [ "i2c-dev" "i2c-piix4" ];
    # kernelPackages = pkgs.linuxPackages_latest;
  };
}
