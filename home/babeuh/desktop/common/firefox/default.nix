{ pkgs, lib, persistence, ... }:

let
  addons = pkgs.nur.repos.rycee.firefox-addons;
in
{
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      ublock-origin
    ];
    # TODO: Make this better
    profiles.secure.extraConfig = builtins.readFile ./arkenfox/user.js;
  };
}
