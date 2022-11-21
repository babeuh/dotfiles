{ pkgs, ... }: {
  programs.ncspot = {
    enable = true;
    settings = {
      shuffle = true;
      gapless = true;
    };
  };
}
