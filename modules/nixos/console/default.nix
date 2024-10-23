{
  lib,
  config,
  self,
  ...
}: let
  inherit (config.ooknet.host) admin;
  inherit (lib) mkIf;
in {
  imports = [
    ./shell
    ./profile
    ./options.nix
  ];

  home-manager.users.${admin.name} = mkIf admin.homeManager {
    imports = ["${self}/modules/home/console"];
  };
}
