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
  inherit (lib) optionalAttrs mkIf;
  inherit (config.ooknet.host) guest admin;

  mkHomeUser = name: {
    "${name}" = {
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      home = {
        username = name;
        homeDirectory = "/home/${name}";
        stateVersion = "22.05";
        sessionPath = ["/home/${name}/.local/bin"];
      };
      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };
    };
  };
in {
  config = mkIf (admin.homeManager || guest.homeManager) {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.old";
      verbose = true;
      extraSpecialArgs = {inherit ook hozen inputs inputs' self self';};
      users =
        (optionalAttrs admin.homeManager (mkHomeUser admin.name))
        // (optionalAttrs guest.homeManager (mkHomeUser guest.name));
    };
  };
}
