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
      betterlockscreen = super.betterlockscreen.overrideAttrs (oldAttrs: rec {
        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin
          cp betterlockscreen $out/bin/betterlockscreen
          wrapProgram "$out/bin/betterlockscreen" \
            --prefix PATH : "$out/bin:${with super; inputs.nixpkgs.lib.makeBinPath [ feh bc coreutils dbus dunst i3lock-color gawk gnugrep gnused imagemagick procps xorg.xdpyinfo xorg.xrandr xorg.xset xorg.xrdb ]}"

          runHook postInstall
        '';
      });
      cozette = super.cozette.overrideAttrs (oldAttrs: rec {
        version = "1.18.1";
        name = "Cozette-${version}";
        url = "https://github.com/slavfox/Cozette/releases/download/v.${version}/CozetteFonts.zip";
        postFetch = ''
          mkdir -p $out/share/fonts
          unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
          unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
          unzip -j $downloadedFile \*.bdf -d $out/share/fonts/misc
          unzip -j $downloadedFile \*.otb -d $out/share/fonts/misc
       '';
      });
    };
in inputs.nixpkgs.lib.composeManyExtensions [ additions modifications ]
