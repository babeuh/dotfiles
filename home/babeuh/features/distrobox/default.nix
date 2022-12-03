{ pkgs, config, ... }: {
  home.packages = with pkgs; [ distrobox xorg.xhost ];

  systemd.user.services.distrobox-xhost = {
    Unit = {
      Description = "Configure xhost for distrobox";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.xorg.xhost}/bin/xhost +si:localuser:${config.home.username}";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
