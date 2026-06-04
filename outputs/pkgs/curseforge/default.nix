{
  lib,
  appimageTools,
  fetchurl,
}: let
  version = "1.0";
  pname = "curseforge";

  src = fetchurl {
    url = "https://curseforge.overwolf.com/downloads/curseforge-latest-linux.AppImage";
    hash = "sha256-8jvwfDNUqTTry/RJAEZkMmnCITGDHOs3WV+gVS6Jh5c=";
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
