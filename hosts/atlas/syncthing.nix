{
  services = {
    syncthing = {
      enable = true;
      dataDir = "/home/babeuh/Documents";
      configDir = "/home/babeuh/.config/syncthing";
      guiAddress = "localhost:8384";
      openDefaultPorts = true;
      user = "babeuh";
      group = "users";
      overrideDevices = true;     # overrides any devices added or deleted through the WebUI
      overrideFolders = true;     # overrides any folders added or deleted through the WebUI
      devices = {
        "phone" = { id = "C2BBNTV-4Q4XUXE-M2RMD3N-PFIVCCB-MMFINAX-UP4S5MZ-BRODLAL-BVES5AG"; };
      };
      folders = {
        "KeePassXC" = {
          id = "4wmxy-pdg0y";
          label = "KeePassXC";
          path = "/home/babeuh/KeePassXC";
          devices = [ "phone" ];
        };
      };
    };
  };
}
