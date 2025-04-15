{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkMerge mkIf;
in {
  security = {
    sudo = mkMerge [
      {
        extraConfig = ''
          Defaults pwfeedback # password feedback
          Defaults lecture = never # disable warning message
          Defaults timestamp_timeout=10 # set sudo timeout to 10 minutes
        '';
      }
      (mkIf isLinux {
        # allow wheel user to execute sudo without a password
        wheelNeedsPassword = false;
        # only allow users in the wheel access to sudo
        execWheelOnly = true;
      })
    ];
  };
}
