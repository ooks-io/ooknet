{ lib, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.programs.kdeconnect;
in

{
  config = mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
