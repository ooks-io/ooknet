{ lib, config, ... }:

  let
    inherit (lib) mkIf;
    inherit (builtins) elem;
    function = config.systemModules.host.function;
  in

{
  config = mkIf (elem "workstation" function) {
    systemModules = {

      audio.enable = true;
      video.enable = true;

      programs = {
        dconf.enable = true;
        wireshark.enable = true;
        bandwhich.enable = true;
        kdeconnect.enable = true;
      };

      services = {

      }
    }
  }
  
}
