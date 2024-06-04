{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.eza;
in

{
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
    };
  };
}
