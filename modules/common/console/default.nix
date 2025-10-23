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
  ];

  home-manager.users = mkIf admin.homeManager {
    "${admin.name}" = {
      imports = ["${self}/modules/home/console"];
    };
  };
}
