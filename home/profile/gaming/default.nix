{ config, lib, ... }:
let
  cfg = config.profiles.gaming;
in
{

  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    homeModules.desktop = {
      gaming = {
        factorio.enable = true;
      };
    };
  };
}
