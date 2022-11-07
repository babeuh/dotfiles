{
  services.polybar = {
    enable = true;
    script = "polybar top &";
    settings = {
      "colors" = {
        background     = "#282A2E";
        background-alt = "#373B41";
        foreground     = "C5C8C6";
        primary        = "F0C674";
        secondary      = "#8ABEB7";
        alert          = "#A54242";
        disabled       = "#707880";
      };
      "bar/top" = {
        width = "100%";
        height = "24pt";
        # radius = 6;
        # dpi = 96;
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";
        line-size = "3pt";
        border = {
          size = "0pt";
          color = "#00000000";
        };
        padding = {
          left = 0;
          right = 1;
        };
        module-margin = 1;
        separator = "|";
        separator-foreground = "\${colors.disabled}";
        font = [ "monospace;2" ];
        modules = {
          left = "xworkspaces xwindow";
          right = "filesystem pulseaudio xkeyboard memory cpu eth date";
        };
        cursor = {
          click = "pointer";
          scroll = "ns-resize";
        };
        enable-ipc = false;
        tray-position = "right";
        wm-restack = "bspwm";
        # override-redirect = true
      };
      "module/xworkspaces" = {
        type = "internal/xworkspaces";
        label = {
          active = "%name%";
          active-background = "\${colors.background.alt}";
          active-underline = "\${colors.primary}";
          active-padding = 1;
          occupied = "%name%";
          occupied-padding = 1;
          urgent = "%name";
          urgent-background = "\${colors.alert}";
          urgent-padding = 1;
          empty = "%name%";
          empty-foreground = "\${colors.disabled}";
          empty-padding = 1;
        };
      };
      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
      };
      "module/filesystem" = {
        type = "internal/fs";
        interval = 25;
        mount = [ "/" ];
        label = {
          mounted = "%{F#F0C674}%mountpoint%%{F-} %percentage_used%%";
          unmounted = "%mountpoint% ?%";
          unmounted-foreground = "\${colors.disabled}";
        };
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        format-volume-prefix = "VOL ";
        format-volume-prefix-foreground = "\${colors.primary}";
        format-volume = "<label-volume>";
        label-volume = "%percentage%%";
        label-muted = "muted";
        label-muted-foreground = "\${colors.disabled}";
      };
      "module/xkeyboard" = {
        type = "internal/xkeyboard";
        blacklist = [ "num lock" ];
        label-layout = "%layout%";
        label-layout-foreground = "\${colors.primary}";
        label-indicator = {
          padding = 2;
          margin = 1;
          foreground = "\${colors.background}";
          background = "\${colors.secondary}";
        };
      };
      "module/cpu" = {
        type = "internal/cpu";
        interval = 2;
        format = {
          prefix = "CPU ";
          prefix-foreground = "\${colors.primary}";
        };
        label = "%percentage:2%%";
      };
      "network-base" = {
        type = "internal/network";
        interval = 5;
        format = {
          connected = "<label-connected>";
          disconnected = "<label-disconnected>";
        };
        label-disconnected = "%{F#F0C675}%ifname%%{F#707880} disconnected";
      };
      "module/eth" = {
        "inherit" = "network-base";
        interface.type = "wired";
        label.connected = "%{F#F0C675}%ifname%%{F-} %local_ip%";
      };
      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%H:%M";
        date-alt = "%Y-%m-%d %H:%M:%S";
        label = "%date%";
        label-foreground = "\${colors.primary}";
      };
      "settings" = {
        screenchange-reload = true;
        pseudo-transparency = true;
      };
    };
  };
}
