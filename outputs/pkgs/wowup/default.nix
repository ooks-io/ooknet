{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "2.22.1-beta.2";
  pname = "wowup";

  src = fetchurl {
    url = "https://github.com/WowUp/WowUp/releases/download/v${version}/WowUp-${version}.AppImage";
    hash = "sha256-z1HGPSNXOAK2YJE1g1dKx0PYNrIaHdp3ID2UU9SYkC0=";
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
