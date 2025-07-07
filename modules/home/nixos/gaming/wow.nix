{
  lib,
  osConfig,
  self',
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    home.packages = [self'.packages.wowup];
  };
}
