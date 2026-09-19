{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "3dprinting" profiles) {
    home.packages = [pkgs.bambu-studio];
  };
}
