{ pkgs, ... }: {
  imports = [
    ./bash.nix
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./gpg.nix
    ./starship.nix
    ./vim.nix
  ];
  home.packages = with pkgs; [
    bc # Calculator
    btop # System viewer
    ncdu # TUI disk usage

    exa # Better ls
    ripgrep # Better grep
    fd # Better find

    nixfmt # Nix formatter
    rustup # Rust

    yubikey-manager # Yubikey
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
