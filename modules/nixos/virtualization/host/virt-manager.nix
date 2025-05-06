{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.virtualization.host.virt-manager;
in {
  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;
  };
}
