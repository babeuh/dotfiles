{
  xsession.windowManager.bspwm = {
    enable = true;
    monitors = {
      # 1: Browser; 2: Media; 3: Editors; 4: Communication; 5: Game Launchers; 6: Games;
      DP-0 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" ];
    };
    rules = {
      # class_name:instance_name:name
      "firefox" = {
        desktop = "I";
      };
      "spotify" = {
        desktop = "II";
      };
      "*:*:GNU Image Manipulation Program" = {
        desktop = "III";
      };
      "discord" = {
        desktop = "IV";
      };
      "heroic" = {
        desktop = "V";
      };
      "Steam" = {
        desktop = "V";
      };
      "steam_app_0" = {
        desktop = "VI";
      };
    };
    settings = {
      border_width       = 2;
      window_gap         = 12;
      split_ratio        = 0.52;
      borderless_monocle = true;
      gapless_monocle    = true;
    };
    startupPrograms = [ "alacritty --class spotify -e \"ncspot\""];
  };
}
