{ lib, config, ... }:

let
  cfg = config.homeModules.config.userDirs;
in

{
  config = lib.mkIf cfg.enable {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  }; 
}
