{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.direnv;
in

{
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
