{ lib, config, ... }:
let
  cfg = config.homeModules.desktop.media.image.imv;
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      imv = {
        enable = true;
      };
    };
  };
}
