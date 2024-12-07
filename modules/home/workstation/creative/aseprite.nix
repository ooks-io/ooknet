{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "creative" profiles) {
    home.packages = [pkgs.aseprite];
  };
}
