{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.systemModules.programs.wireshark;
in

{
  options.systemModules.programs.wireshark.enable = mkEnableOption "Enable wireshark system module";

  config = mkIf cfg.enable {
    programs.wireshark.enable = true;
  };
}
