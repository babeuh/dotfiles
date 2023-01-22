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

}
