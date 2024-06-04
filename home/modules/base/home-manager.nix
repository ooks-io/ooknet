{ lib, config, osConfig, ... }:

let
  inherit (lib) mkDefault;
  admin = osConfig.ooknet.host.admin;
in

{
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  
  home = {
    username = admin.name;
    homeDirectory = "/home/${config.home.username}";
    stateVersion = mkDefault "22.05";
    sessionPath = [ "${config.home.homeDirectory}/.local/bin" ];
    sessionVariables = {
      TZ = "Pacific/Auckland";
    };
  };

  # to save space
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
