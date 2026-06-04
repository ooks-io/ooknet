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
    # disabled temporarily
    # home.packages = [pkgs.aseprite];
  };
}
