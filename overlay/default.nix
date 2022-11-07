# This file defines two overlays and composes them
{ inputs, ... }:
let
  # This one brings our custom packages from the 'pkgs' directory
  additions = self: _super: import ../pkgs { pkgs = self; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = self: super:
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # });
      discord = super.discord.override { withOpenASAR = true; };
    };
in inputs.nixpkgs.lib.composeManyExtensions [ additions modifications ]
