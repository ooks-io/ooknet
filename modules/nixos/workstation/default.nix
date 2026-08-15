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
    ./services
    ./programs
    ./gaming
    ./environment
    ./silent-boot.nix
  ];

  # leave a few cores free during big compiles
  nix.settings.cores = 8;

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
