{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.media.image.imv;
in

{
  config = mkIf cfg.enable {
    programs = {
      imv = {
        enable = true;
      };
    };
  };
}
