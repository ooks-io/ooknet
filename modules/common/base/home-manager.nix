{
  inputs,
  inputs',
  self,
  self',
  lib,
  config,
  ook,
  pkgs,
  ...
}: let
  inherit (lib) optionalAttrs mkIf;
  inherit (config.ooknet.host) guest admin;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  mkHomeUser = name: {
    "${name}" = let
      homeDir =
        if isLinux
        then "/home"
        else "/Users";
    in {
      programs.home-manager.enable = true;
      systemd.user.startServices = "sd-switch";
      home = {
        username = name;
        homeDirectory = "${homeDir}/${name}";
        stateVersion = "22.05";
        sessionPath = ["${homeDir}/${name}/.local/bin"];
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
      extraSpecialArgs = {inherit ook inputs inputs' self self';};
      users =
        (optionalAttrs admin.homeManager (mkHomeUser admin.name))
        // (optionalAttrs guest.homeManager (mkHomeUser guest.name));
    };
  };
}
