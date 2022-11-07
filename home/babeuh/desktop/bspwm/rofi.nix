{ config, ... }: {
  programs.rofi = {
    enable = true;
    font = "monospace;2";
    location = "center";
    plugins = [ ];
    terminal = "alacritty";
    theme = "gruvbox-dark-soft";
  };
}
