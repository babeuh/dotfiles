{
  description = "XMonad Config";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };
  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      haskellDeps = ps:
        with ps; [
          xmonad
          xmonad-contrib
          xmonad-extras
          haskell-language-server
        ];
    in flake-utils.lib.simpleFlake {
      inherit self nixpkgs;
      name = "XMonad Dev environment";
      shell = { pkgs ? import <nixpkgs> }:
        pkgs.mkShell {
          buildInputs = with pkgs; [ (ghc.withPackages haskellDeps) ];
        };
    };
}
