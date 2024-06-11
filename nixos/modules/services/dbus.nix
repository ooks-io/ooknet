{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.services.dbus;
in

{
  config = mkIf cfg.enable {
    services.dbus = {
      enable = true;
      packages = with pkgs; [ dconf gcr udisks2 ];
      implementation = "broker";
    };
  };
}
