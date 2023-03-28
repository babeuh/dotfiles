{ stdenv
, fetchurl
, lib
, makeWrapper
, dpkg
, alsa-lib
, at-spi2-atk
, cairo
, cups
, dbus
, expat
, ffmpeg
, glib
, gtk3
, libdrm
, libpulseaudio
, libudev0-shim
, libxkbcommon
, mesa
, nspr
, nss
, pango
, xorg
}:
let
  inherit (stdenv.hostPlatform) system;
  pname = "multiviewer-for-f1";
  version = "1.14.2";
  id = "99812509";

  meta = with lib; {
    description = "Unofficial desktop client for F1 TV®";
    homepage = "https://multiviewer.app";
    downloadPage = "https://multiviewer.app/download";
    license = licenses.unfree;
    maintainers = with maintainers; [ babeuh ];
    platforms = [ "x86_64-linux" ];
  };

  src = fetchurl {
    url = "https://releases.multiviewer.dev/download/${id}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-qvwcYzXrU9UI5nL1y6jG9E0mTBdGuV750br9sUr3MbY=";
  };

  deps = [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    ffmpeg
    glib
    gtk3
    libdrm
    libpulseaudio
    libudev0-shim
    libxkbcommon
    mesa
    nspr
    nss
    pango
    xorg.libX11
    xorg.libXcomposite
    xorg.libxcb
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
  ];
in
stdenv.mkDerivation {
    inherit pname version src meta;

    nativeBuildInputs = [ makeWrapper ];

    dontBuild = true;
    dontConfigure = true;

    unpackPhase = ''
      ${dpkg}/bin/dpkg-deb -x $src . || true
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/${pname}

      cp -a usr/share/* $out/share
      cp -a usr/lib/${pname} $out/share/
      mv $out/share/${pname}/"MultiViewer for F1" $out/share/${pname}/${pname}

      rpath="$out/share/${pname}"
      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/share/${pname}/${pname}

      makeWrapper $out/share/${pname}/${pname} $out/bin/${pname} \
        --add-flags $out/share/${pname}/resources/app \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath deps }:$out/share/${pname}"

      runHook postInstall
    '';
  }
