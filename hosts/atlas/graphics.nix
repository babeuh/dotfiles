{ config, pkgs, ... }: {

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
    };
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    #  Key autorepeat
    autoRepeatDelay = 500;
    autoRepeatInterval = 20;

    screenSection = ''
      Option        "metamodes" "2560x1440_144 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}
    '';

    desktopManager.session = [{
      name = "home-manager";
      start = ''
        ${pkgs.runtimeShell} $HOME/.hm-xsession &
        waitPID=$!
      '';
    }];
  };
}
