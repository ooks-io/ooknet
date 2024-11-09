{
  inputs,
  inputs',
  self,
  self',
  lib,
  config,
  hozen,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
in {
  config = mkIf admin.homeManager {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.old";
      verbose = true;
      extraSpecialArgs = {inherit hozen inputs inputs' self self';};
      users.${admin.name} = {
        imports = ["${self}/modules/home/base"];
      };
    };
  };
}
