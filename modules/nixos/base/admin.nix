{
  lib,
  config,
  pkgs,
  inputs,
  inputs',
  self',
  self,
  keys,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) role admin;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = {
    users.users.${admin.name} = {
      isNormalUser = true;
      shell = pkgs.${admin.shell};
      initialPassword = "password";
      openssh.authorizedKeys.keys = [keys.users."${admin.name}"];
      extraGroups =
        [
          "wheel"
          "video"
          "audio"
        ]
        ++ ifTheyExist [
          "git"
          "media"
          "network"
          "libvirtd"
          "streamer"
          "torrenter"
        ];
    };
    home-manager = mkIf (role == "workstation" || admin.homeManager) {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.old";
      verbose = true;
      extraSpecialArgs = {inherit inputs inputs' self self';};
      users.${admin.name} = {
        imports = ["${self}/modules/home/base"];
      };
    };
  };
}
