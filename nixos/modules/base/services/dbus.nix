{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (lib.lists) any elem;
  hasFunction = f: elem f config.ooknet.host.function;
in

{
  config = mkIf (any hasFunction ["workstation" "gaming"]) {
    services.dbus = {
      enable = true;
      packages = with pkgs; [ dconf gcr udisks2 ];
      implementation = "broker";
    };
  };
}
