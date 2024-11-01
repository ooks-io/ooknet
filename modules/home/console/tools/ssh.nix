{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.console.tools.ssh;
in {
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      compression = true;
      hashKnownHosts = true;
      matchBlocks = {
        "github.com" = {
          user = "git";
          hostname = "github.com";
          identityFile = "${osConfig.age.secrets.github_key.path}";
        };
        "git.ooknet.org" = {
          user = "forgejo";
          port = 2222;
          hostname = "git.ooknet.org";
          identityFile = "${osConfig.age.secrets.ooknet_org.path}";
        };
      };
    };
  };
}
