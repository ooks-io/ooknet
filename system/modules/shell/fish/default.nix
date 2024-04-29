{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  adminShell = config.systemModules.host.admin.shell;
  cfg = config.systemModules.shell.fish;
in

{
  options.systemModules.shell.fish.enable = mkEnableOption "Enable fish module";

  config = mkIf (adminShell == "fish" || cfg.enable) {
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };
}
