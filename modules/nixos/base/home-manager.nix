{
  inputs,
  inputs',
  self,
  self',
  lib,
  config,
  hozen,
  ook,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) guest admin;
in {
  config = mkIf (admin.homeManager || guest.homeManager) {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.old";
      verbose = true;
      extraSpecialArgs = {inherit ook hozen inputs inputs' self self';};
      users = {
        ${admin.name} = mkIf admin.homeManager {
          imports = ["${self}/modules/home/base"];
        };
        ${guest.name} = mkIf guest.homeManager {
          imports = ["${self}/modules/home/base}"];
        };
      };
    };
  };
}
