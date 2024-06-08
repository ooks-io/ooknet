{ lib, config, ... }:

let
  inherit (lib) mkIf mkEnableOption;
  adminShell = config.ooknet.host.admin.shell;
  cfg = config.ooknet.shell.fish;
in

{
  options.ooknet.shell.fish.enable = mkEnableOption "Enable fish module";

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
