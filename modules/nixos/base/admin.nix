{
  lib,
  config,
  pkgs,
  keys,
  ...
}: let
  inherit (config.ooknet.host) admin;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = {
    users.users.${admin.name} = {
      isNormalUser = true;
      shell = pkgs.${admin.shell};
      initialHashedPassword = "$y$j9T$l4Wje1zgcrPIM5G4BRAT6.$AKHmE2MvJLLiipYnwGsljxbD0QmqYtHGlKht0kLLI87";
      openssh.authorizedKeys.keys = [keys.users."${admin.name}"];
      createHome = true;
      home = "/home/${admin.name}";
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
  };
}
