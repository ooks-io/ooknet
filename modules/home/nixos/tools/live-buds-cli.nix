{
  osConfig,
  self',
  lib,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.hardware) features;
in {
  config = mkIf (elem "bluetooth" features) {
    home.packages = [self'.packages.live-buds-cli];
  };
}
