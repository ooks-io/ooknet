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
          # direct to the vps: the public dns name is cloudflare-proxied,
          # which only passes http - ssh dies at the edge
          HostName = "ooknode";
          IdentityFile = "${osConfig.age.secrets.ooknet_org.path}";
        };
      };
    };
  };
}
