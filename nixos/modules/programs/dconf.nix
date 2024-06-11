{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.programs.dconf;
in

{
  config = mkIf cfg.enable {
    programs.dconf.enable = true;
  };
}
