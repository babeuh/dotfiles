{
  users.users = {
    babeuh = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "libvirtd" ];
    };
  };

  services.pcscd.enable = true;

  security.pam.u2f = {
    enable = true;
    control = "required";
    cue = true;
  };

  services.chrony = {
    enable = true;
    servers = [ "time.cloudflare.com" "ntppool1.time.nl" "nts.netnod.se" "ptbtime1.ptb.de" ];
    enableNTS = true;

    extraConfig = ''
      minsources 2
      authselectmode require

      leapsectz right/UTC
      makestep 0.1 3

      rtcsync
      cmdport 0
    '';
  };
}
