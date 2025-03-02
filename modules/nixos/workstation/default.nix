{
  config,
  self,
  lib,
  ...
}: let
  inherit (lib) optionalAttrs;
  inherit (config.ooknet.host) admin guest;
in {
  imports = [
    ./options.nix
    ./themes
    ./services
    ./programs
    ./gaming
    ./environment
    ./virtualization
  ];

  home-manager.users =
    (optionalAttrs admin.homeManager {
      "${admin.name}" = {
        imports = ["${self}/modules/home/workstation"];
      };
    })
    // (optionalAttrs guest.homeManager {
      "${guest.name}" = {
        imports = ["${self}/modules/home/workstation"];
      };
    });
}
