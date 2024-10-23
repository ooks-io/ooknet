{
  lib,
  config,
  inputs',
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.programs) rofi;
in {
  config = mkIf rofi.enable {
    home.packages = [inputs'.ooks-scripts.packages.powermenu];
    ooknet.binds.powerMenu = "powermenu -c dmenu";
  };
}
