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
    ./nvidia
    ./gaming
    ./laptop
    ./mediaServer
  ];

  options = {
    activeProfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
    
    systemProfile = {
      base = {
        enable = lib.mkEnableOption "Enable the base profile";
      };
      gaming = {
        enable = lib.mkEnableOption "Enable the gaming profile";
      };
      laptop = {
        enable = lib.mkEnableOption "Enable the laptop profile";
      };
      nvidia = {
        enable = lib.mkEnableOption "Enable the nvidia profile";
      };
      mediaServer = {
        enable = lib.mkEnableOption "Enable the mediaServer profile";
      };
    };
  };
  
  config.systemProfile = profileEnabler;
}
