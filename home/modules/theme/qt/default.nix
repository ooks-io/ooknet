{ config, lib, ... }:
let
  cfg = config.ooknet.theme.qt;
in
{
  options.ooknet.theme.qt.enable = lib.mkEnableOption "Enable qt module";

  config = lib.mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      };
  };
}

