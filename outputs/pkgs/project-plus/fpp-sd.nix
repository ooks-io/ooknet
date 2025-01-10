{
  stdenv,
  fetchzip,
}: let
  version = "3.0.5";
in
  stdenv.mkDerivation {
    name = "fpp-sdcard";
    inherit version;

    src = fetchzip {
      url = "https://github.com/jlambert360/FPM-AppImage/releases/download/v${version}/sd.tar.gz";
      sha256 = "sha256-9QrfAxY62x5RlELOUey+zfVzP3xuDB/sRe/0rVevV6A";
    };

    installPhase = ''
      mkdir -p $out
      cp sd.raw $out
    '';
  }
