{ config, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.qt;
in

{
  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      };
  };
}

