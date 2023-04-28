{ config, pkgs, ... }: {

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl

        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      # nvidia-drm.modeset=1
      modesetting.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver
    egl-wayland
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;

    #  Key autorepeat
    autoRepeatDelay = 500;
    autoRepeatInterval = 20;

    screenSection = ''
      Option        "metamodes" "2560x1440_144 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}
    '';
  };
}
