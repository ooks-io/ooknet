{ config, lib, ... }:
let
  cfg = config.systemProfile.mediaServer;
in 
{
  imports = [
    ../../modules
  ];
  
  config = lib.mkIf cfg.enable {
    systemModules = {
      services = {
        mediaServer.enable = true;
      };
    };
  };
}
