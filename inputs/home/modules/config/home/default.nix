{ lib, config, ... }:

let
  cfg = config.homeModules.config.home;
in

{
  config = lib.mkIf cfg.enable {

    programs.home-manager.enable = true;
    
    home = {
      username = lib.mkDefault "ooks";
      homeDirectory = lib.mkDefault "/home/${config.home.username}";
      stateVersion = lib.mkDefault "22.05";
      sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
      sessionVariables = {
        TZ = "Pacific/Auckland";
      };
    };

    # to save space
    manual = {
      html.enable = false;
      json.enable = false;
      manpages.enable = true;
    };
  };  
}
