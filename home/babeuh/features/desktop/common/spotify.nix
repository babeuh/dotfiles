{ pkgs, ... }: {
  home.packages = with pkgs; [ spotify ];
  programs.ncspot = {
    enable = true;
    settings = {
      shuffle = true;
      gapless = true;
    };
  };
}
