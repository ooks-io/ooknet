{
  stdenv,
  fetchzip,
}: let
  version = "3.0.5";
in
  stdenv.mkDerivation {
    inherit version;
    name = "fpp-launcher";

    src = fetchzip {
      url = "https://github.com/jlambert360/FPM-AppImage/releases/download/v${version}/Launcher.tar.gz";
      sha256 = "sha256-Q3F4V/ggePaZRsGFM54hkGBkLb52PaIn2lQ31gYANW0=";
    };

    installPhase = ''
      mkdir -p $out/Launcher
      cp -rf . $out/Launcher
    '';
  }
