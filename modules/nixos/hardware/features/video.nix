{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config.ooknet.hardware) features;
in {
  config = mkIf (elem "video" features) {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
