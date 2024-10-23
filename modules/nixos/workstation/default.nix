{
  config,
  self,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
in {
  imports = [
    ./options.nix
    ./themes
    ./services
    ./programs
    ./gaming
    ./environment
  ];

  home-manager.users.${admin.name} = mkIf admin.homeManager {
    imports = ["${self}/modules/home/workstation"];
  };
}
