{ config, lib, ... }:
let
  cfg = config.homeModules.theme.qt;
in
{
  options.homeModules.theme.qt.enable = lib.mkEnableOption "Enable qt module";

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      };
  };
}

