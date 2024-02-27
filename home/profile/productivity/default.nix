{ config, lib, ... }:
let
  cfg = config.profiles.productivity;
in
{

  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    homeModules.desktop = {
      productivity = {
        obsidian.enable = true;
      };
    };
  };
}
