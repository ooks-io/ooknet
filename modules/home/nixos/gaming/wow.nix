{
  lib,
  osConfig,
  self',
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    home.packages = attrValues {
      inherit
        (self'.packages)
        wowup
        curseforge
        ;
    };
  };
}
