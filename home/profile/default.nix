{ lib, config, ... }:

let
  profileEnabler = let
    reducer = l: r: {"${r}".enable = true;} // l;
  in
    builtins.foldl' reducer {} config.activeProfiles;
in
{
  imports = [
    ./base
    ./hyprland
    #./creative
    ./productivity
  ];

  options = {
    activeProfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    
    profiles = {
      base = {
        enable = lib.mkEnableOption "Enable the base profile";
      };
      hyprland = {
        enable = lib.mkEnableOption "Enable the hyprland profile";
      };
      gaming = {
        enable = lib.mkEnableOption "Enable the gaming profile";
      };
      productivity = {
        enable = lib.mkEnableOption "Enable the productivity profile";
      };
    };
  };
  
  config.profiles = profileEnabler;
}
