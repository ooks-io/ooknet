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
      enableDefaultConfig = false;
      settings = {
        "*" = {
          Compression = true;
          HashKnownHosts = true;
        };
        "github.com" = {
          User = "git";
          HostName = "github.com";
          IdentityFile = "${osConfig.age.secrets.github_key.path}";
        };
        "git.ooknet.org" = {
          User = "forgejo";
          Port = 2222;
          HostName = "git.ooknet.org";
          IdentityFile = "${osConfig.age.secrets.ooknet_org.path}";
        };
      };
    };
  };
}
