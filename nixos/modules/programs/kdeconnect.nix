{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.programs.kdeconnect;
in

{
  config = mkIf cfg.enable {
    programs.kdeconnect = {
      enable = true;
    };
  };
}
