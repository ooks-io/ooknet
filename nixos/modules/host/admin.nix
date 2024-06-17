{ lib, config, pkgs, inputs, outputs, self, keys, ... }:

let
  cfg = config.ooknet.host.admin;
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  inherit (lib) mkIf;
in

{
  config = {
    users.users.${cfg.name} = {
      isNormalUser = true;
      shell = pkgs.${cfg.shell};
      initialPassword = "password";
      openssh.authorizedKeys.keys = [ (keys.users."${cfg.name}") ];
      extraGroups = [
        "wheel"
        "video"
        "audio"
        ] ++ ifTheyExist [
        "git"
        "media"
        "network"
        "libvirtd"
        "deluge"
        "streamer"
        "torrenter"
      ];
    };
    home-manager = mkIf cfg.homeManager {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm.old";
      verbose = true;
      extraSpecialArgs = { inherit inputs outputs self; };
      users.${cfg.name} = {
        imports = [ "${self}/home" ];
      };
    };
  };
}
