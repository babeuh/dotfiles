{
  xsession.windowManager.bspwm = {
    enable = true;
    # alwaysResetDesktop maybe false
    monitors = {
      DP-0 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" ];
    };
    rules = {
      "firefox" = {
        desktop = "I";
      };
    };
    settings = {
      border_width       = 2;
      window_gap         = 12;
      split_ratio        = 0.52;
      borderless_monocle = true;
      gapless_monocle    = true;
    };
    startupPrograms = [];
  };
}
