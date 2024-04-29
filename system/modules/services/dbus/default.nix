{ lib, config, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.systemModules.services.dbus;
in

{
  options.systemModules.services.dbus.enable = mkEnableOption "Enable dbus system module";

  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = with pkgs; [ dconf gcr udisks2 ];
      implementation = "broker";
    };
  };
}
