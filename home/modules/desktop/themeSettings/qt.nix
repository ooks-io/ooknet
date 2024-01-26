{ config, lib, ... }:
let
  cfg = config.homeModules.desktop.themeSettings;
in
{
  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme = "gtk";
      };
  };
}
