{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.virtualization.host.containers;
in {
  config = mkIf cfg.enable {
    virtualisation.containers.enable = true;

    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
