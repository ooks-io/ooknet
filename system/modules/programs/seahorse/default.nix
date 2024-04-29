{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.programs.seahorse;
in

{
  options.systemModules.programs.seahorse.enable = mkEnableOption "Enable seahorse system module";

  config = mkIf cfg.enable {
    programs.seahorse.enable = true;
  };
}
