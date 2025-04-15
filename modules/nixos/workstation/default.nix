{
  config,
  self,
  lib,
  ...
}: let
  inherit (lib) optionalAttrs;
  inherit (config.ooknet.host) admin guest;

  workstationModules = [
    "${self}/modules/home/nixos"
    "${self}/modules/home/common"
  ];
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
        imports = workstationModules;
      };
    })
    // (optionalAttrs guest.homeManager {
      "${guest.name}" = {
        imports = workstationModules;
      };
    });
}
