{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.gaming.gamescope;
in {
  config = mkIf cfg.enable {
    hardware.graphics.extraPackages = [pkgs.gamescope];
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
}
