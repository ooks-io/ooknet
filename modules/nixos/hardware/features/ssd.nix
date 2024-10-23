{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config.ooknet.hardware) features;
in {
  config = mkIf (elem "ssd" features) {
    services.fstrim = {
      enable = true;
    };
    # only run fstrim while connected on AC
    systemd.services.fstrim = {
      unitConfig.ConditionACPower = true;
      serviceConfig = {
        Nice = 19;
        IOSchedulingClass = "idle";
      };
    };
  };
}
