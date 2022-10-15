{ pkgs, ... }:
{
  services.xidlehook = {
    enable = true;
    not-when-fullscreen = true;
    not-when-audio = true;
    # NOTE: The delays add onto the previous value (and the value is in seconds)
    timers = [
      {
        delay = 240;
        command = "${pkgs.notify-desktop}/bin/notify-desktop --app-name=betterlockscreen --urgency=critical \"Locking screen in 1 min\"";
        canceller = "${pkgs.notify-desktop}/bin/notify-desktop --app-name=betterlockscreen \"Locking screen cancelled\"";
      }
      {
        delay = 60;
        command = "${pkgs.betterlockscreen}/bin/betterlockscreen --wall blur -l";
      }
    ];
  };
}
