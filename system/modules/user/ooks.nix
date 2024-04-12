{ lib, pkgs, config, ... }:

let 
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
  cfg = config.systemModules.user.ooks;
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
      "media"
      "network"
      "libvirtd"
      "deluge"
      "streamer"
      "torrenter"
      ];

    packages = [ pkgs.home-manager ];
    };
    home-manager.users.ooks = import ../../../home/user/ooks/${config.networking.hostName};
  };
}
