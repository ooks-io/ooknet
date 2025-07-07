{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "2.21.0-beta.3";
  pname = "wowup-cf";

  src = fetchurl {
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    hash = "sha256-6UN5YMahrmKBxIjMDyWz2MNLJTxYxnuhR/Y2CYf+eZE=";
  };

  appimageContents = appimageTools.extractType1 {inherit pname version src;};
in
  appimageTools.wrapType1 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

    meta = with lib; {
      license = licenses.mit;
      platforms = ["x86_64-linux"];
    };
  }
