{ lib, config, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.systemModules.services.kdeconnect;
in

{
  options.systemModules.services.kdeconnect.enable = mkEnableOption "Enable kdeconnect system module";

  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}
