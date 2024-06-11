{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.services.gvfs;
in

{
  config = mkIf cfg.enable {
    services.gvfs.enable = true;
  };
}
