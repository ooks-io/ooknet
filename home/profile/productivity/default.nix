{ config, lib, ... }:
let
  cfg = config.profiles.productivity;
in
{

  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    ooknet.desktop = {
      productivity = {
        obsidian.enable = true;
        zathura.enable = true;
        office.enable = true;
      };
    };
  };
}
