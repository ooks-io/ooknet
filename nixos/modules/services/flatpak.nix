{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.services.flatpak;
in

{
  config = mkIf cfg.enable {
    services.flatpak.enable = true;
  };
}
