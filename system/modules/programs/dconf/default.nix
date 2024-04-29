{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.programs.dconf;
in

{
  options.systemModules.programs.dconf.enable = mkEnableOption "Enable dconf system module";

  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
