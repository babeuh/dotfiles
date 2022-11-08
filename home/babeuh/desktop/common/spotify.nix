{ pkgs, lib, ... }: {
  home.packages = with pkgs; [ spotify-tui ];
  services.spotifyd = {
    enable = true;
    package = (pkgs.spotifyd.override { withKeyring = true; withMpris = true; withPulseAudio = true; });
    settings = {global = {
      username_cmd = "/home/babeuh/.config/spotifyd/username";
      use_keyring = true;
      use_mpris = true;
      dbus_type = "session";
      device_name = "computer";
      bitrate = 320;
      cache_path = "/home/babeuh/.cache/spotifyd/";
      max_cache_size = 1000000000;
      initial_volume = "100";
      autoplay = true;
      device_type = "computer";
      device = "default";
    };};
  };
  systemd.user.services.spotifyd.Unit.After = [ "keepassxc.service" ];

  home.activation = {
    setSpotifyUsername = lib.hm.dag.entryAfter ["writeBoundary"] ''
      user_file="''${HOME}/.config/spotifyd/username"
      if [ -f ''$user_file ];
      then exit 0
      else
      mkdir -p "''${HOME}/.config/spotifyd"
      read -p "Spotify Username/Email: " username
      echo "echo ''${username}" > ''$user_file
      chmod +x ''$user_file
      systemctl restart --user spotifyd.service
      fi
    '';
  };
}
