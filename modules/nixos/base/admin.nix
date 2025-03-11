{
  config,
  pkgs,
  ...
}: let
  inherit (config.ooknet.host) admin;
  inherit (config.ooknet.secrets) keys;
  inherit (config.age) secrets;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = {
    users.users.${admin.name} = {
      isNormalUser = true;
      shell = pkgs.${admin.shell};
      initialHashedPassword = "";
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
          "www"
        ];
    };
  };
}
