{ lib
, buildGoModule
, fetchFromGitHub
, makeDesktopItem
, gtk4
, gobject-introspection
, libcanberra
, pkg-config
, libadwaita
}:
buildGoModule rec {
  pname = "gtkcord4";
  version = "0.0.6";
  meta = with lib; {
    description = "GTK4 Discord client in Go, attempt #4.";
    homepage = "https://github.com/diamondburned/gtkcord4";
    maintainers = with maintainers; [ babeuh ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = "gtkcord4";
    rev = "v${version}";
    sha256 = "sha256-uEG1pAHMQT+C/E5rKByflvL0NNkC8SeSPMAXanzvhE4=";
  };

  vendorSha256 = "sha256-QZSjSk1xu5ZcrNEra5TxnUVvlQWb5/h31fm5Nc7WMoI=";

  
  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk4 gobject-introspection libcanberra libadwaita ];

  buildPhase = ''
    ls -la
    go install -v -tags libadwaita
  '';


  desktopItem = makeDesktopItem {
    name = "gtkcord4";
    genericName = "Discord Client";
    comment = meta.description;
    exec = "gtkcord4";
    icon = "gtkcord4";
    terminal = false;
    type = "Application";
    categories = [ "GNOME" "GTK" "Network" "Chat" ];
    startupNotify = true;
    desktopName = "gtkcord4";
  };

  postInstall = ''
    cp -r $desktopItem/* $out
  '';
}
