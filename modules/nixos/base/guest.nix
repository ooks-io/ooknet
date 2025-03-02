{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) guest;
  inherit (config.ooknet.secrets) keys;

  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  config = mkIf guest.enable {
    users.users.${guest.name} = {
      isNormalUser = true;
      shell = pkgs.${guest.shell};
      initialHashedPassword = "$y$j9T$l4Wje1zgcrPIM5G4BRAT6.$AKHmE2MvJLLiipYnwGsljxbD0QmqYtHGlKht0kLLI87";
      openssh.authorizedKeys.keys = [keys.users."${guest.name}"];
      createHome = true;
      home = "/home/${guest.name}";
      extraGroups =
        [
          "video"
          "audio"
        ]
        ++ ifTheyExist [
          "media"
          "network"
        ];
    };
  };
}
