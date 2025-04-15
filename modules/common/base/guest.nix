{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (config.ooknet.host) guest;
  inherit (config.ooknet.secrets) keys;

  inherit (pkgs.stdenv) isLinux;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = mkIf guest.enable {
    users.users.${guest.name} = mkMerge [
      {
        shell = pkgs.${guest.shell};
        openssh.authorizedKeys.keys = [keys.users."${guest.name}"];
        createHome = true;
        home =
          if isLinux
          then "/home/${guest.name}"
          else "/Users/${guest.name}";
      }
      (mkIf isLinux {
        initialHashedPassword = "$y$j9T$l4Wje1zgcrPIM5G4BRAT6.$AKHmE2MvJLLiipYnwGsljxbD0QmqYtHGlKht0kLLI87";
        isNormalUser = true;
        extraGroups =
          [
            "video"
            "audio"
          ]
          ++ ifTheyExist [
            "media"
            "network"
          ];
      })
    ];
  };
}
