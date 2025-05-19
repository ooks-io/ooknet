{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mkIf;
  cfg = config.ooknet.hardware.gpu.benchmark;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = attrValues {
      inherit
        (pkgs)
        unigine-heaven
        unigen-superposition
        ;
    };
  };
}
