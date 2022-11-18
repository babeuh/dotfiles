{ ... }: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 400;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 0;
        foreground = "#C5C8C6";
        background = "#282A2E";
        frame_color = "#707880";
        font = "monospace;2";
        fullscreen = "pushback";
        separator_color = "#707880";
      };

      urgency_low = {
        timeout = 3;
      };

      urgency_normal = {
        highlight = "#F0C674";
        timeout = 5;
      };

      urgency_critical = {
        frame_color = "#A54242";
        highlight = "#A54242";
        timeout = 10;
        fullscreen = "show";
      };
    };
  };
}
