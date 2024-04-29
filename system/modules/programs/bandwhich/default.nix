{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.programs.bandwhich;
in

{
  options.systemModules.programs.bandwhich.enable = mkEnableOption "Enable bandwhich system module";

  config = mkIf cfg.enable {
    programs.bandwhich.enable = true;
  };
}
