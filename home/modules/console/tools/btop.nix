{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.btop;
in

{
  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
    };
  };
}
