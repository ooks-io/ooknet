{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
  inherit (builtins) attrValues;
in {
  config = mkIf (elem "work" profiles) {
    home.packages = attrValues {
      inherit (pkgs) teams-for-linux slack;
    };
  };
}
