{
  config,
  pkgs,
  ook,
  lib,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
  inherit (lib) mkMerge mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.ooknet.secrets) keys;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = {
    users.users.${admin.name} = mkMerge [
      {
        shell = pkgs.${admin.shell};
        openssh.authorizedKeys.keys = [keys.users."${admin.name}"];
        createHome = true;
        home =
          if isLinux
          then "/home/${admin.name}"
          else "/Users/${admin.name}";
      }
      (mkIf isLinux {
        isNormalUser = true;
        initialHashedPassword = "";
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
      })
    ];
  };
}
