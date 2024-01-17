{ lib, pkgs, config, ... }:

let 
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  cfg = config.systemModule.user.ooks;
in

{
  config = lib.mkIf cfg.enable {
    users.users.ooks = {
      isNormalUser = true;
      extraGroups = [
      "wheel"
      "video"
      "audio"
      ] ++ ifTheyExist [
      "git"
      "network"
      "libvirtd"
      "deluge"
      ];

    packages = [ pkgs.home-manager ];
    };

    home-manager.users.ooks = import ../../../../home/user/ooks/${config.networking.hostName};
  };
}
